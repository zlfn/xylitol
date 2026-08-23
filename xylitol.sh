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
# replace(source: Text, search: Text, replace: Text)
replace__0_v0() {
    local source_2248="${1}"
    local search_2249="${2}"
    local replace_2250="${3}"
    # Here we use a command to avoid #646
    local result_2251=""
    left_comp=("${EXEC_SHELL_VERSION[@]}")
    right_comp=(4 3)
    local comp
    comp="$(
        # Compare if left array >= right array
        len_comp="$( (( "${#left_comp[@]}" < "${#right_comp[@]}" )) && echo "${#left_comp[@]}"|| echo "${#right_comp[@]}")"
        for (( i=0; i<len_comp; i++ )); do
            left="${left_comp[i]?"Index out of bounds (at unknown)"}"
            right="${right_comp[i]?"Index out of bounds (at unknown)"}"
            if (( "${left}" > "${right}" )); then
                echo 1
                exit
            elif (( "${left}" < "${right}" )); then
                echo 0
                exit
            fi
        done
        (( "${#left_comp[@]}" == "${#right_comp[@]}" || "${#left_comp[@]}" > "${#right_comp[@]}" )) && echo 1 || echo 0
)"
    if [ "$(( $([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?) || $(( $([ "_${EXEC_SHELL}" != "_bash" ]; echo $?) && comp )) ))" != 0 ]; then
        result_2251="${source_2248//"${search_2249}"/"${replace_2250}"}"
        __status=$?
    else
        result_2251="${source_2248//"${search_2249}"/${replace_2250}}"
        __status=$?
    fi
    ret_replace0_v0="${result_2251}"
    return 0
}

__SED_VERSION_UNKNOWN_0=0
__SED_VERSION_GNU_1=1
__SED_VERSION_BUSYBOX_2=2
# sed_version()
sed_version__2_v0() {
    # We can't match against a word "GNU" because
    # alpine's busybox sed returns "This is not GNU sed version"
    re='Copyright.+Free Software Foundation'; [[ $(sed --version 2>/dev/null) =~ $re ]]
    __status=$?
    if [ "$(( __status == 0 ))" != 0 ]; then
        ret_sed_version2_v0="${__SED_VERSION_GNU_1}"
        return 0
    fi
    # On BSD single `sed` waits for stdin. We must use `sed --help` to avoid this.
    re='BusyBox'; [[ $(sed --help 2>&1) =~ $re ]]
    __status=$?
    if [ "$(( __status == 0 ))" != 0 ]; then
        ret_sed_version2_v0="${__SED_VERSION_BUSYBOX_2}"
        return 0
    fi
    ret_sed_version2_v0="${__SED_VERSION_UNKNOWN_0}"
    return 0
}

# split(text: Text, delimiter: Text)
split__4_v0() {
    local text_637="${1}"
    local delimiter_638="${2}"
    local result_639=()
    # zsh uses -A for array, bash uses -a, ksh is VERY bad at splitting anything
    if [ "$([ "_${EXEC_SHELL}" != "_zsh" ]; echo $?)" != 0 ]; then
        IFS="${delimiter_638}" read -rd '' -A result_639 < <(printf %s "$text_637")
        __status=$?
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        if [ "$([ "_${delimiter_638}" != "_
" ]; echo $?)" != 0 ]; then
            while read -r -d $'\n'; do result_639+=("$REPLY"); done < <(echo "$text_637")
            __status=$?
        else
            IFS="${delimiter_638}" read -rd '' -a result_639 < <(printf %s "$text_637")
            __status=$?
        fi
    elif [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        IFS="${delimiter_638}" read -rd '' -a result_639 < <(printf %s "$text_637")
        __status=$?
    fi
    ret_split4_v0=("${result_639[@]}")
    return 0
}

# join(list: [Text], delimiter: Text)
join__7_v0() {
    local list_8152=("${!1}")
    local delimiter_8153="${2}"
    local command_2
    command_2="$(IFS="${delimiter_8153}" ; printf "%s
" "${list_8152[*]}")"
    __status=$?
    ret_join7_v0="${command_2}"
    return 0
}

# parse_int(text: Text)
parse_int__13_v0() {
    local text_641="${1}"
    [ -n "${text_641}" ] && [ "${text_641}" -eq "${text_641}" ] 2>/dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_parse_int13_v0=''
        return "${__status}"
    fi
    ret_parse_int13_v0="${text_641}"
    return 0
}

# match_regex(source: Text, search: Text, extended: Bool)
match_regex__19_v0() {
    local source_2244="${1}"
    local search_2245="${2}"
    local extended_2246="${3}"
    sed_version__2_v0 
    local sed_version_2247="${ret_sed_version2_v0}"
    replace__0_v0 "${search_2245}" "/" "\\/"
    search_2245="${ret_replace0_v0}"
    local output_2252=""
    if [ "$(( $(( sed_version_2247 == __SED_VERSION_GNU_1 )) || $(( sed_version_2247 == __SED_VERSION_BUSYBOX_2 )) ))" != 0 ]; then
        # '\b' is supported but not in POSIX standards. Disable it
        replace__0_v0 "${search_2245}" "\\b" "\\\\b"
        search_2245="${ret_replace0_v0}"
    fi
    if [ "${extended_2246}" != 0 ]; then
        # GNU sed versions 4.0 through 4.2 support extended regex syntax,
        # but only via the "-r" option
        if [ "$(( sed_version_2247 == __SED_VERSION_GNU_1 ))" != 0 ]; then
            # '\b' is not in POSIX standards. Disable it
            replace__0_v0 "${search_2245}" "\\b" "\\b"
            search_2245="${ret_replace0_v0}"
            local command_3
            command_3="$(sed -r -ne "/${search_2245}/p" <<<"${source_2244}")"
            __status=$?
            output_2252="${command_3}"
        else
            local command_4
            command_4="$(sed -E -ne "/${search_2245}/p" <<<"${source_2244}")"
            __status=$?
            output_2252="${command_4}"
        fi
    else
        if [ "$(( $(( sed_version_2247 == __SED_VERSION_GNU_1 )) || $(( sed_version_2247 == __SED_VERSION_BUSYBOX_2 )) ))" != 0 ]; then
            # GNU Sed BRE handle \| as a metacharacter, but it is not POSIX standands. Disable it
            replace__0_v0 "${search_2245}" "\\|" "|"
            search_2245="${ret_replace0_v0}"
        fi
        local command_5
        command_5="$(sed -ne "/${search_2245}/p" <<<"${source_2244}")"
        __status=$?
        output_2252="${command_5}"
    fi
    if [ "$([ "_${output_2252}" == "_" ]; echo $?)" != 0 ]; then
        ret_match_regex19_v0=1
        return 0
    fi
    ret_match_regex19_v0=0
    return 0
}

# starts_with(text: Text, prefix: Text)
starts_with__22_v0() {
    local text_13698="${1}"
    local prefix_13699="${2}"
    [[ "${text_13698}" == "${prefix_13699}"* ]]
    __status=$?
    ret_starts_with22_v0="$(( __status == 0 ))"
    return 0
}

# lpad(text: Text, pad: Text, length: Int)
lpad__27_v0() {
    local text_9831="${1}"
    local pad_9832="${2}"
    local length_9833="${3}"
    local __length_6="${text_9831}"
    if [ "$(( length_9833 <= ${#__length_6} ))" != 0 ]; then
        ret_lpad27_v0="${text_9831}"
        return 0
    fi
    local __length_7="${text_9831}"
    local pad_len_9834="$(( length_9833 - ${#__length_7} ))"
    local padding_9835=""
    printf -v padding_9835 "%${pad_len_9834}s" ""
    __status=$?
    padding_9835="${padding_9835// /${pad_9832}}"
    __status=$?
    ret_lpad27_v0="${padding_9835}""${text_9831}"
    return 0
}

# rpad(text: Text, pad: Text, length: Int)
rpad__28_v0() {
    local text_9837="${1}"
    local pad_9838="${2}"
    local length_9839="${3}"
    local __length_8="${text_9837}"
    if [ "$(( length_9839 <= ${#__length_8} ))" != 0 ]; then
        ret_rpad28_v0="${text_9837}"
        return 0
    fi
    local __length_9="${text_9837}"
    local pad_len_9840="$(( length_9839 - ${#__length_9} ))"
    local padding_9841=""
    printf -v padding_9841 "%${pad_len_9840}s" ""
    __status=$?
    padding_9841="${padding_9841// /${pad_9838}}"
    __status=$?
    ret_rpad28_v0="${text_9837}""${padding_9841}"
    return 0
}

# cpad(text: Text, pad: Text, length: Int)
cpad__29_v0() {
    local text_9825="${1}"
    local pad_9826="${2}"
    local length_9827="${3}"
    local __length_10="${text_9825}"
    local text_length_9828="${#__length_10}"
    if [ "$(( length_9827 <= text_length_9828 ))" != 0 ]; then
        ret_cpad29_v0="${text_9825}"
        return 0
    fi
    local total_padding_9829="$(( length_9827 - text_length_9828 ))"
    local left_padding_length_9830="$(( text_length_9828 + $(( total_padding_9829 / 2 )) ))"
    lpad__27_v0 "${text_9825}" "${pad_9826}" "${left_padding_length_9830}"
    local left_padded_9836="${ret_lpad27_v0}"
    rpad__28_v0 "${left_padded_9836}" "${pad_9826}" "${length_9827}"
    local center_padded_9842="${ret_rpad28_v0}"
    ret_cpad29_v0="${center_padded_9842}"
    return 0
}

# dir_exists(path: Text)
dir_exists__38_v0() {
    local path_13855="${1}"
    [ -d "${path_13855}" ]
    __status=$?
    ret_dir_exists38_v0="$(( __status == 0 ))"
    return 0
}

# array_find(array: [Text], value: Text)
array_find__67_v0() {
    local array_13841=("${!1}")
    local value_13842="${2}"
    index_13844=0;
    for element_13843 in "${array_13841[@]}"; do
        if [ "$([ "_${value_13842}" != "_${element_13843}" ]; echo $?)" != 0 ]; then
            ret_array_find67_v0="${index_13844}"
            return 0
        fi
        (( index_13844++ )) || true
    done
    ret_array_find67_v0=-1
    return 0
}

# env_var_get(name: Text)
env_var_get__120_v0() {
    local name_635="${1}"
    if [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        local command_13
        command_13="$(printf "%s
" "${!name_635}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_13}"
        return 0
    elif [ "$([ "_${EXEC_SHELL}" != "_zsh" ]; echo $?)" != 0 ]; then
        local command_14
        command_14="$(printf "%s
" "${(P)name_635}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_14}"
        return 0
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        local command_15
        command_15="$(eval "echo \${$name_635}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_15}"
        return 0
    fi
}

# printf(format: Text, args: [Text])
printf__128_v0() {
    local format_649="${1}"
    local args_650=("${!2}")
    args_650=("${format_649}" "${args_650[@]}")
    __status=$?
    printf "${args_650[@]}"
    __status=$?
}

# printf(format: Text, args: [])
printf__128_v1() {
    local format_658="${1}"
    local args_659=("${!2}")
    args_659=("${format_658}" "${args_659[@]}")
    __status=$?
    printf "${args_659[@]}"
    __status=$?
}

# echo_colored(message: Text, color: Int)
echo_colored__134_v0() {
    local message_646="${1}"
    local color_647="${2}"
    local color_code_648=0
        color_code_648="${color_647}"
    local array_16=("${message_646}")
    printf__128_v0 "\\x1b[${color_code_648}m%s\\x1b[0m
" array_16[@]
}

# Perl Extensions Utilities
command_17="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_3="$([ "_${command_17}" != "_No" ]; echo $?)"
command_18="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_4="$(( $(( ! _perl_disabled_3 )) && $([ "_${command_18}" != "_0" ]; echo $?) ))"
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
_supports_truecolor_7="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_8=0
_primary_color_9=(3 207 159 92)
_secondary_color_10=(3 118 206 94)
_accent_color_11=(234 72 121 95)
# get_supports_truecolor()
get_supports_truecolor__238_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local config_656="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_656}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_7="No"
        ret_get_supports_truecolor238_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_7="No"
        ret_get_supports_truecolor238_v0=0
        return 0
    fi
    local colorterm_657="${ret_env_var_get120_v0}"
    _supports_truecolor_7="$(if [ "$(( $([ "_${colorterm_657}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_657}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor238_v0="$([ "_${_supports_truecolor_7}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__239_v0() {
    local message_651="${1}"
    local r_652="${2}"
    local g_653="${3}"
    local b_654="${4}"
    local fallback_655="${5}"
    if [ "$([ "_${_supports_truecolor_7}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb239_v0="\\x1b[38;2;${r_652};${g_653};${b_654}m""${message_651}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_7}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__238_v0 
        local ret_get_supports_truecolor238_v0__50_17="${ret_get_supports_truecolor238_v0}"
        if [ "${ret_get_supports_truecolor238_v0__50_17}" != 0 ]; then
            ret_colored_rgb239_v0="\\x1b[38;2;${r_652};${g_653};${b_654}m""${message_651}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_655 == 0 ))" != 0 ]; then
            ret_colored_rgb239_v0="${message_651}"
            return 0
        else
            ret_colored_rgb239_v0="\\x1b[${fallback_655}m""${message_651}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_655 == 0 ))" != 0 ]; then
            ret_colored_rgb239_v0="${message_651}"
            return 0
        fi
        ret_colored_rgb239_v0="\\x1b[${fallback_655}m""${message_651}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__241_v0() {
    if [ "$(( ! _got_xylitol_colors_8 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local primary_env_636="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_636}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_636}" ";"
            local parts_640=("${ret_split4_v0[@]}")
            local __length_23=("${parts_640[@]}")
            if [ "$(( ${#__length_23[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_640[0]?"Index out of bounds (at src/utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors241_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_640[1]?"Index out of bounds (at src/utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors241_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_640[2]?"Index out of bounds (at src/utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors241_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_640[3]?"Index out of bounds (at src/utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors241_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
                _primary_color_9=("${ret_parse_int13_v0__115_21}" "${ret_parse_int13_v0__116_21}" "${ret_parse_int13_v0__117_21}" "${ret_parse_int13_v0__118_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local secondary_env_642="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_642}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_642}" ";"
            local parts_643=("${ret_split4_v0[@]}")
            local __length_25=("${parts_643[@]}")
            if [ "$(( ${#__length_25[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_643[0]?"Index out of bounds (at src/utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors241_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_643[1]?"Index out of bounds (at src/utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors241_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_643[2]?"Index out of bounds (at src/utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors241_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_643[3]?"Index out of bounds (at src/utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors241_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_10=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local accent_env_644="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_644}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_644}" ";"
            local parts_645=("${ret_split4_v0[@]}")
            local __length_27=("${parts_645[@]}")
            if [ "$(( ${#__length_27[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_645[0]?"Index out of bounds (at src/utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors241_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_645[1]?"Index out of bounds (at src/utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors241_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_645[2]?"Index out of bounds (at src/utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors241_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_645[3]?"Index out of bounds (at src/utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors241_v0=''
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
get_xylitol_colors__242_v0() {
    inner_get_xylitol_colors__241_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_8=1
}

# colored_primary(message: Text)
colored_primary__243_v0() {
    local message_634="${1}"
    if [ "$(( ! _got_xylitol_colors_8 ))" != 0 ]; then
        get_xylitol_colors__242_v0 
    fi
    colored_rgb__239_v0 "${message_634}" "${_primary_color_9[0]?"Index out of bounds (at src/utils/truecolor.ab:164:48)"}" "${_primary_color_9[1]?"Index out of bounds (at src/utils/truecolor.ab:164:67)"}" "${_primary_color_9[2]?"Index out of bounds (at src/utils/truecolor.ab:164:86)"}" "${_primary_color_9[3]?"Index out of bounds (at src/utils/truecolor.ab:164:105)"}"
    ret_colored_primary243_v0="${ret_colored_rgb239_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__244_v0() {
    local message_660="${1}"
    if [ "$(( ! _got_xylitol_colors_8 ))" != 0 ]; then
        get_xylitol_colors__242_v0 
    fi
    colored_rgb__239_v0 "${message_660}" "${_secondary_color_10[0]?"Index out of bounds (at src/utils/truecolor.ab:171:50)"}" "${_secondary_color_10[1]?"Index out of bounds (at src/utils/truecolor.ab:171:71)"}" "${_secondary_color_10[2]?"Index out of bounds (at src/utils/truecolor.ab:171:92)"}" "${_secondary_color_10[3]?"Index out of bounds (at src/utils/truecolor.ab:171:113)"}"
    ret_colored_secondary244_v0="${ret_colored_rgb239_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__245_v0() {
    local message_663="${1}"
    if [ "$(( ! _got_xylitol_colors_8 ))" != 0 ]; then
        get_xylitol_colors__242_v0 
    fi
    colored_rgb__239_v0 "${message_663}" "${_accent_color_11[0]?"Index out of bounds (at src/utils/truecolor.ab:178:47)"}" "${_accent_color_11[1]?"Index out of bounds (at src/utils/truecolor.ab:178:65)"}" "${_accent_color_11[2]?"Index out of bounds (at src/utils/truecolor.ab:178:83)"}" "${_accent_color_11[3]?"Index out of bounds (at src/utils/truecolor.ab:178:101)"}"
    ret_colored_accent245_v0="${ret_colored_rgb239_v0}"
    return 0
}

# // IO Functions /////
# printf_colored(message: Text, color: Int)
printf_colored__260_v0() {
    local message_13858="${1}"
    local color_13859="${2}"
    # Prints a text with a specified color.
    local array_29=("${message_13858}")
    printf__128_v0 "\\x1b[${color_13859}m%s\\x1b[0m" array_29[@]
}

# eprintf(format: Text, args: [Text])
eprintf__261_v0() {
    local format_80="${1}"
    local args_81=("${!2}")
    args_81=("${format_80}" "${args_81[@]}")
    __status=$?
    printf "${args_81[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__262_v0() {
    local message_78="${1}"
    local color_79="${2}"
    # Prints an error message with a specified color.
    local array_30=("${message_78}")
    eprintf__261_v0 "\\x1b[${color_79}m%s\\x1b[0m" array_30[@]
}

# colored(message: Text, color: Int)
colored__263_v0() {
    local message_661="${1}"
    local color_662="${2}"
    # Returns a text wrapped in color codes.
    ret_colored263_v0="\\x1b[${color_662}m""${message_661}""\\x1b[0m"
    return 0
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# // Application Utilities /////
# print_help()
print_help__424_v0() {
    echo "Usage: ./xylitol.sh <command> [flags]"
    printf '%s\n' ""
    colored_primary__243_v0 "Xylitol"
    local ret_colored_primary243_v0__7_24="${ret_colored_primary243_v0}"
    local array_31=()
    printf__128_v1 "\\x1b[1m""${ret_colored_primary243_v0__7_24}" array_31[@]
    local array_32=()
    printf__128_v1 " - A tool for " array_32[@]
    colored_primary__243_v0 "fresh"
    local ret_colored_primary243_v0__9_12="${ret_colored_primary243_v0}"
    local array_33=()
    printf__128_v1 "${ret_colored_primary243_v0__9_12}" array_33[@]
    local array_34=()
    printf__128_v1 " shell scripts." array_34[@]
    printf '%s\n' ""
    printf '%s\n' ""
    colored_secondary__244_v0 "Flags: "
    local ret_colored_secondary244_v0__13_12="${ret_colored_secondary244_v0}"
    local array_35=()
    printf__128_v1 "${ret_colored_secondary244_v0__13_12}""
" array_35[@]
    echo "  -h, --help        Show this help message"
    echo "  -v, --version     Show version information"
    printf '%s\n' ""
    colored_secondary__244_v0 "Commands: "
    local ret_colored_secondary244_v0__17_12="${ret_colored_secondary244_v0}"
    local array_36=()
    printf__128_v1 "${ret_colored_secondary244_v0__17_12}""
" array_36[@]
    echo "  input             Prompt for some input"
    echo "  choose            Choose from a list of options"
    echo "  confirm           Prompt for a yes/no confirmation"
    echo "  file              Browse filesystem and select a file"
    printf '%s\n' ""
    colored_secondary__244_v0 "Envs: "
    local ret_colored_secondary244_v0__23_12="${ret_colored_secondary244_v0}"
    local array_37=()
    printf__128_v1 "${ret_colored_secondary244_v0__23_12}""
" array_37[@]
    colored__263_v0 "(\"Yes\" or \"No\", default: Yes)" 90
    local ret_colored263_v0__24_78="${ret_colored263_v0}"
    local array_38=()
    printf__128_v1 "  \$XYLITOL_USE_PERL          Use Perl for CJK / Optimization ""${ret_colored263_v0__24_78}""
" array_38[@]
    colored__263_v0 "(\"Yes\" or \"No\", default: Yes)" 90
    local ret_colored263_v0__25_78="${ret_colored263_v0}"
    local array_39=()
    printf__128_v1 "  \$XYLITOL_TRUECOLOR         Enable 24-bit truecolor support ""${ret_colored263_v0__25_78}""
" array_39[@]
    colored__263_v0 "(default: 3;207;159;92)" 90
    local ret_colored263_v0__26_68="${ret_colored263_v0}"
    local array_40=()
    printf__128_v1 "  \$XYLITOL_PRIMARY_COLOR     Set the primary color ""${ret_colored263_v0__26_68}""
" array_40[@]
    colored__263_v0 "(default: 3;118;206;94)" 90
    local ret_colored263_v0__27_70="${ret_colored263_v0}"
    local array_41=()
    printf__128_v1 "  \$XYLITOL_SECONDARY_COLOR   Set the secondary color ""${ret_colored263_v0__27_70}""
" array_41[@]
    colored__263_v0 "(default: 234;72;121;95)" 90
    local ret_colored263_v0__28_67="${ret_colored263_v0}"
    local array_42=()
    printf__128_v1 "  \$XYLITOL_ACCENT_COLOR      Set the accent color ""${ret_colored263_v0__28_67}""
" array_42[@]
    printf '%s\n' ""
    colored_accent__245_v0 "./xylitol.sh <command> --help"
    local ret_colored_accent245_v0__30_21="${ret_colored_accent245_v0}"
    local array_43=()
    printf__128_v1 "Run ""${ret_colored_accent245_v0__30_21}"" for more information on a command.
" array_43[@]
}

# math_floor(number: Int)
math_floor__505_v0() {
    local number_2356="${1}"
    local command_44
    command_44="$(awk '{printf "%d", ($1 < 0 ? int($1) - 1 : int($1))}' <<< "${number_2356}")"
    __status=$?
    ret_math_floor505_v0="${command_44}"
    return 0
}

# math_ceil(number: Int)
math_ceil__506_v0() {
    local number_2355="${1}"
    math_floor__505_v0 "${number_2355}"
    local ret_math_floor505_v0__52_12="${ret_math_floor505_v0}"
    ret_math_ceil506_v0="$(( ret_math_floor505_v0__52_12 + 1 ))"
    return 0
}

# Perl Extensions Utilities
command_45="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_12="$([ "_${command_45}" != "_No" ]; echo $?)"
command_46="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_13="$(( $(( ! _perl_disabled_12 )) && $([ "_${command_46}" != "_0" ]; echo $?) ))"
# perl_get_cjk_width(text: Text)
perl_get_cjk_width__567_v0() {
    local text_2299="${1}"
    if [ "$(( ! _perl_available_13 ))" != 0 ]; then
        ret_perl_get_cjk_width567_v0=''
        return 1
    fi
    local command_47
    command_47="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_2299}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width567_v0=''
        return "${__status}"
    fi
    local width_str_2300="${command_47}"
    parse_int__13_v0 "${width_str_2300}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width567_v0=''
        return "${__status}"
    fi
    local width_2301="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width567_v0="${width_2301}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__568_v0() {
    local text_2308="${1}"
    local max_width_2309="${2}"
    if [ "$(( ! _perl_available_13 ))" != 0 ]; then
        ret_perl_truncate_cjk568_v0=''
        return 1
    fi
    local command_48
    command_48="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_2308}" ${max_width_2309} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk568_v0=''
        return "${__status}"
    fi
    local result_2310="${command_48}"
    ret_perl_truncate_cjk568_v0="${result_2310}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_14=0
_term_size_15=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_lock()
stty_lock__576_v0() {
    local command_50
    command_50="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_2279="${command_50}"
    parse_int__13_v0 "${count_2279}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_2280="${ret_parse_int13_v0}"
    if [ "$(( count_num_2280 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_2280="$(( count_num_2280 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_2280}
    __status=$?
}

# stty_unlock()
stty_unlock__577_v0() {
    local command_51
    command_51="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_2352="${command_51}"
    parse_int__13_v0 "${count_2352}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_2353="${ret_parse_int13_v0}"
    if [ "$(( count_num_2353 > 0 ))" != 0 ]; then
        count_num_2353="$(( count_num_2353 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_2353}
        __status=$?
        if [ "$(( count_num_2353 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# parse_size(text: Text)
parse_size__578_v0() {
    local text_2283="${1}"
    # `match_regex` uses BRE by default, where `+` is a literal character
    match_regex__19_v0 "${text_2283}" "^[0-9][0-9]*\$" 0
    local ret_match_regex19_v0__38_12="${ret_match_regex19_v0}"
    if [ "$(( ! ret_match_regex19_v0__38_12 ))" != 0 ]; then
        ret_parse_size578_v0=0
        return 0
    fi
    parse_int__13_v0 "${text_2283}"
    __status=$?
    ret_parse_size578_v0="${ret_parse_int13_v0}"
    return 0
}

# query_term_size()
query_term_size__579_v0() {
    local command_52
    command_52="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; echo "$height; $width")"
    __status=$?
    local result_2281="${command_52}"
    split__4_v0 "${result_2281}" ";"
    local parts_2282=("${ret_split4_v0[@]}")
    local __length_53=("${parts_2282[@]}")
    if [ "$(( ${#__length_53[@]} != 2 ))" != 0 ]; then
        ret_query_term_size579_v0=0
        return 0
    fi
    parse_size__578_v0 "${parts_2282[0]?"Index out of bounds (at src/./input/../utils/term.ab:53:35)"}"
    local rows_2284="${ret_parse_size578_v0}"
    parse_size__578_v0 "${parts_2282[1]?"Index out of bounds (at src/./input/../utils/term.ab:54:35)"}"
    local cols_2285="${ret_parse_size578_v0}"
    if [ "$(( $(( rows_2284 <= 0 )) || $(( cols_2285 <= 0 )) ))" != 0 ]; then
        ret_query_term_size579_v0=0
        return 0
    fi
    _term_size_15=("${cols_2285}" "${rows_2284}")
    ret_query_term_size579_v0=1
    return 0
}

# stty_term_size()
stty_term_size__580_v0() {
    local command_55
    command_55="$(stty size < /dev/tty 2>/dev/null)"
    __status=$?
    local result_2287="${command_55}"
    split__4_v0 "${result_2287}" " "
    local parts_2288=("${ret_split4_v0[@]}")
    local __length_56=("${parts_2288[@]}")
    if [ "$(( ${#__length_56[@]} != 2 ))" != 0 ]; then
        ret_stty_term_size580_v0=0
        return 0
    fi
    parse_size__578_v0 "${parts_2288[0]?"Index out of bounds (at src/./input/../utils/term.ab:70:35)"}"
    local rows_2289="${ret_parse_size578_v0}"
    parse_size__578_v0 "${parts_2288[1]?"Index out of bounds (at src/./input/../utils/term.ab:71:35)"}"
    local cols_2290="${ret_parse_size578_v0}"
    if [ "$(( $(( rows_2289 <= 0 )) || $(( cols_2290 <= 0 )) ))" != 0 ]; then
        ret_stty_term_size580_v0=0
        return 0
    fi
    _term_size_15=("${cols_2290}" "${rows_2289}")
    ret_stty_term_size580_v0=1
    return 0
}

# get_term_size()
get_term_size__581_v0() {
    query_term_size__579_v0 
    local detected_2286="${ret_query_term_size579_v0}"
    if [ "$(( ! detected_2286 ))" != 0 ]; then
        stty_term_size__580_v0 
        detected_2286="${ret_stty_term_size580_v0}"
    fi
    _got_term_size_14=1
}

# term_width()
term_width__583_v0() {
    if [ "$(( ! _got_term_size_14 ))" != 0 ]; then
        get_term_size__581_v0 
    fi
    ret_term_width583_v0="${_term_size_15[0]?"Index out of bounds (at src/./input/../utils/term.ab:101:23)"}"
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
get_supports_truecolor__594_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local config_2265="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_2265}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_16="No"
        ret_get_supports_truecolor594_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_16="No"
        ret_get_supports_truecolor594_v0=0
        return 0
    fi
    local colorterm_2266="${ret_env_var_get120_v0}"
    _supports_truecolor_16="$(if [ "$(( $([ "_${colorterm_2266}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_2266}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor594_v0="$([ "_${_supports_truecolor_16}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__595_v0() {
    local message_2260="${1}"
    local r_2261="${2}"
    local g_2262="${3}"
    local b_2263="${4}"
    local fallback_2264="${5}"
    if [ "$([ "_${_supports_truecolor_16}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb595_v0="\\x1b[38;2;${r_2261};${g_2262};${b_2263}m""${message_2260}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_16}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__594_v0 
        local ret_get_supports_truecolor594_v0__50_17="${ret_get_supports_truecolor594_v0}"
        if [ "${ret_get_supports_truecolor594_v0__50_17}" != 0 ]; then
            ret_colored_rgb595_v0="\\x1b[38;2;${r_2261};${g_2262};${b_2263}m""${message_2260}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_2264 == 0 ))" != 0 ]; then
            ret_colored_rgb595_v0="${message_2260}"
            return 0
        else
            ret_colored_rgb595_v0="\\x1b[${fallback_2264}m""${message_2260}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_2264 == 0 ))" != 0 ]; then
            ret_colored_rgb595_v0="${message_2260}"
            return 0
        fi
        ret_colored_rgb595_v0="\\x1b[${fallback_2264}m""${message_2260}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__597_v0() {
    if [ "$(( ! _got_xylitol_colors_17 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local primary_env_2254="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_2254}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_2254}" ";"
            local parts_2255=("${ret_split4_v0[@]}")
            local __length_61=("${parts_2255[@]}")
            if [ "$(( ${#__length_61[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_2255[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors597_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2255[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors597_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2255[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors597_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2255[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors597_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
                _primary_color_18=("${ret_parse_int13_v0__115_21}" "${ret_parse_int13_v0__116_21}" "${ret_parse_int13_v0__117_21}" "${ret_parse_int13_v0__118_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local secondary_env_2256="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_2256}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_2256}" ";"
            local parts_2257=("${ret_split4_v0[@]}")
            local __length_63=("${parts_2257[@]}")
            if [ "$(( ${#__length_63[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_2257[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors597_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2257[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors597_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2257[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors597_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2257[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors597_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_19=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local accent_env_2258="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_2258}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_2258}" ";"
            local parts_2259=("${ret_split4_v0[@]}")
            local __length_65=("${parts_2259[@]}")
            if [ "$(( ${#__length_65[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_2259[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors597_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2259[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors597_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2259[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors597_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_2259[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors597_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_17=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__598_v0() {
    inner_get_xylitol_colors__597_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_17=1
}

# colored_primary(message: Text)
colored_primary__599_v0() {
    local message_2253="${1}"
    if [ "$(( ! _got_xylitol_colors_17 ))" != 0 ]; then
        get_xylitol_colors__598_v0 
    fi
    colored_rgb__595_v0 "${message_2253}" "${_primary_color_18[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:164:48)"}" "${_primary_color_18[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:164:67)"}" "${_primary_color_18[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:164:86)"}" "${_primary_color_18[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:164:105)"}"
    ret_colored_primary599_v0="${ret_colored_rgb595_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__600_v0() {
    local message_2267="${1}"
    if [ "$(( ! _got_xylitol_colors_17 ))" != 0 ]; then
        get_xylitol_colors__598_v0 
    fi
    colored_rgb__595_v0 "${message_2267}" "${_secondary_color_19[0]?"Index out of bounds (at src/./input/../utils/truecolor.ab:171:50)"}" "${_secondary_color_19[1]?"Index out of bounds (at src/./input/../utils/truecolor.ab:171:71)"}" "${_secondary_color_19[2]?"Index out of bounds (at src/./input/../utils/truecolor.ab:171:92)"}" "${_secondary_color_19[3]?"Index out of bounds (at src/./input/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary600_v0="${ret_colored_rgb595_v0}"
    return 0
}

# // IO Functions /////
# get_char()
get_char__614_v0() {
    local command_67
    command_67="$(read -n 1 key < /dev/tty; printf "%s" "$key")"
    __status=$?
    local char_2348="${command_67}"
    ret_get_char614_v0="${char_2348}"
    return 0
}

# eprintf(format: Text, args: [Text])
eprintf__617_v0() {
    local format_2326="${1}"
    local args_2327=("${!2}")
    args_2327=("${format_2326}" "${args_2327[@]}")
    __status=$?
    printf "${args_2327[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__618_v0() {
    local message_2336="${1}"
    local color_2337="${2}"
    # Prints an error message with a specified color.
    local array_68=("${message_2336}")
    eprintf__617_v0 "\\x1b[${color_2337}m%s\\x1b[0m" array_68[@]
}

# colored(message: Text, color: Int)
colored__619_v0() {
    local message_2338="${1}"
    local color_2339="${2}"
    # Returns a text wrapped in color codes.
    ret_colored619_v0="\\x1b[${color_2339}m""${message_2338}""\\x1b[0m"
    return 0
}

# remove(cnt: Int)
remove__620_v0() {
    local cnt_2350="${1}"
    if [ "$(( cnt_2350 > 0 ))" != 0 ]; then
        local array_69=("")
        eprintf__617_v0 "\\x1b[${cnt_2350}D\\x1b[K" array_69[@]
    fi
}

# remove_line(cnt: Int)
remove_line__621_v0() {
    local cnt_2359="${1}"
    if [ "$(( cnt_2359 > 0 ))" != 0 ]; then
        local sequence_2360=""
        local __range_start_2361=0
        local __range_end_2361="${cnt_2359}"
        local __dir_2361=$(( ${__range_start_2361} <= ${__range_end_2361} ? 1 : -1 ))
        for (( ____2361=${__range_start_2361}; ____2361 * ${__dir_2361} < ${__range_end_2361} * ${__dir_2361}; ____2361+=${__dir_2361} )); do
            sequence_2360+="\\x1b[2K\\x1b[1A"
done
        local array_70=("")
        eprintf__617_v0 "${sequence_2360}" array_70[@]
    fi
    local array_71=("")
    eprintf__617_v0 "\\x1b[G" array_71[@]
}

# remove_current_line()
remove_current_line__622_v0() {
    local array_72=("")
    eprintf__617_v0 "\\x1b[2K\\x1b[G" array_72[@]
}

# new_line(cnt: Int)
new_line__624_v0() {
    local cnt_2328="${1}"
    local __range_start_2329=0
    local __range_end_2329="${cnt_2328}"
    local __dir_2329=$(( ${__range_start_2329} <= ${__range_end_2329} ? 1 : -1 ))
    for (( ____2329=${__range_start_2329}; ____2329 * ${__dir_2329} < ${__range_end_2329} * ${__dir_2329}; ____2329+=${__dir_2329} )); do
        local array_73=("")
        eprintf__617_v0 "
" array_73[@]
done
}

# go_up(cnt: Int)
go_up__625_v0() {
    local cnt_2347="${1}"
    local array_74=("")
    eprintf__617_v0 "\\x1b[${cnt_2347}A" array_74[@]
}

# go_down(cnt: Int)
go_down__626_v0() {
    local cnt_2358="${1}"
    local array_75=("")
    eprintf__617_v0 "\\x1b[${cnt_2358}B" array_75[@]
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__630_v0() {
    local text_2271="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_76
    command_76="$([[ "${text_2271}" == *$'\x1b'* || "${text_2271}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_2272="${command_76}"
    ret_has_ansi_escape630_v0="$([ "_${has_escape_2272}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__631_v0() {
    local text_2273="${1}"
    local command_77
    command_77="$(printf '%s' "${text_2273}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi631_v0="${command_77}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__632_v0() {
    local text_2295="${1}"
    local command_78
    command_78="$(printf "%s" "${text_2295}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi632_v0="${command_78}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__633_v0() {
    local text_2297="${1}"
    local command_79
    command_79="$(printf "%s" "${text_2297}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_2298="${command_79}"
    ret_is_all_ascii633_v0="$([ "_${result_2298}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__634_v0() {
    local text_2294="${1}"
    strip_ansi__632_v0 "${text_2294}"
    local stripped_2296="${ret_strip_ansi632_v0}"
    # Check if text is all ASCII
    is_all_ascii__633_v0 "${stripped_2296}"
    local ret_is_all_ascii633_v0__150_12="${ret_is_all_ascii633_v0}"
    if [ "$(( ! ret_is_all_ascii633_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__567_v0 "${stripped_2296}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_80="${stripped_2296}"
            ret_get_visible_len634_v0="${#__length_80}"
            return 0
        fi
        ret_get_visible_len634_v0="${ret_perl_get_cjk_width567_v0}"
        return 0
    else
        local __length_81="${stripped_2296}"
        ret_get_visible_len634_v0="${#__length_81}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__635_v0() {
    local text_2305="${1}"
    local max_width_2306="${2}"
    get_visible_len__634_v0 "${text_2305}"
    local visible_len_2307="${ret_get_visible_len634_v0}"
    if [ "$(( visible_len_2307 <= max_width_2306 ))" != 0 ]; then
        ret_truncate_text635_v0="${text_2305}"
        return 0
    fi
    is_all_ascii__633_v0 "${text_2305}"
    local ret_is_all_ascii633_v0__167_12="${ret_is_all_ascii633_v0}"
    if [ "$(( ! ret_is_all_ascii633_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__568_v0 "${text_2305}" "${max_width_2306}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_2305}" | cut -c1-${max_width_2306}
            __status=$?
        fi
        ret_truncate_text635_v0="${ret_perl_truncate_cjk568_v0}"
        return 0
    fi
    local command_82
    command_82="$(printf "%s" "${text_2305}" | cut -c1-${max_width_2306})"
    __status=$?
    ret_truncate_text635_v0="${command_82}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__636_v0() {
    local text_2303="${1}"
    local max_width_2304="${2}"
    has_ansi_escape__630_v0 "${text_2303}"
    local ret_has_ansi_escape630_v0__179_12="${ret_has_ansi_escape630_v0}"
    if [ "$(( ! ret_has_ansi_escape630_v0__179_12 ))" != 0 ]; then
        truncate_text__635_v0 "${text_2303}" "${max_width_2304}"
        ret_truncate_ansi636_v0="${ret_truncate_text635_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_83
    command_83="$([[ "${text_2303}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_2311="${command_83}"
    # Replace \x1b[ with newline, then split
    local command_84
    command_84="$(t="${text_2303}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_2312="${command_84}"
    split__4_v0 "${replaced_2312}" "
"
    local parts_2313=("${ret_split4_v0[@]}")
    local result_2314=""
    local remaining_width_2315="${max_width_2304}"
    local __range_start_2316=0
    local __length_85=("${parts_2313[@]}")
    local __range_end_2316="${#__length_85[@]}"
    local __dir_2316=$(( ${__range_start_2316} <= ${__range_end_2316} ? 1 : -1 ))
    for (( idx_2316=${__range_start_2316}; idx_2316 * ${__dir_2316} < ${__range_end_2316} * ${__dir_2316}; idx_2316+=${__dir_2316} )); do
        local part_2317="${parts_2313[${idx_2316}]?"Index out of bounds (at src/./input/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_2316 == 0 )) && $([ "_${starts_with_ansi_2311}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_2317}" == "_" ]; echo $?) && $(( remaining_width_2315 > 0 )) ))" != 0 ]; then
                truncate_text__635_v0 "${part_2317}" "${remaining_width_2315}"
                local ret_truncate_text635_v0__201_35="${ret_truncate_text635_v0}"
                local truncated_2318="${ret_truncate_text635_v0__201_35}"
                result_2314+="${truncated_2318}"
                get_visible_len__634_v0 "${truncated_2318}"
                local ret_get_visible_len634_v0__203_36="${ret_get_visible_len634_v0}"
                remaining_width_2315="$(( remaining_width_2315 - ret_get_visible_len634_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_86
            command_86="$(__p="${part_2317}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_2319="${command_86}"
            if [ "$([ "_${m_idx_2319}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_87
                command_87="$(__p="${part_2317}"; printf "%s" "${__p:0:${m_idx_2319}}")"
                __status=$?
                local ansi_params_2320="${command_87}"
                result_2314+="\\x1b[""${ansi_params_2320}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_2319}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_2321="${ret_parse_int13_v0__214_41}"
                local text_start_2322="$(( m_idx_num_2321 + 1 ))"
                local command_88
                command_88="$(__p="${part_2317}"; printf "%s" "${__p:${text_start_2322}}")"
                __status=$?
                local text_part_2323="${command_88}"
                if [ "$(( $([ "_${text_part_2323}" == "_" ]; echo $?) && $(( remaining_width_2315 > 0 )) ))" != 0 ]; then
                    truncate_text__635_v0 "${text_part_2323}" "${remaining_width_2315}"
                    local ret_truncate_text635_v0__218_39="${ret_truncate_text635_v0}"
                    local truncated_2324="${ret_truncate_text635_v0__218_39}"
                    result_2314+="${truncated_2324}"
                    get_visible_len__634_v0 "${truncated_2324}"
                    local ret_get_visible_len634_v0__220_40="${ret_get_visible_len634_v0}"
                    remaining_width_2315="$(( remaining_width_2315 - ret_get_visible_len634_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_2317}" == "_" ]; echo $?) && $(( remaining_width_2315 > 0 )) ))" != 0 ]; then
                    truncate_text__635_v0 "${part_2317}" "${remaining_width_2315}"
                    local ret_truncate_text635_v0__225_39="${ret_truncate_text635_v0}"
                    local truncated_2325="${ret_truncate_text635_v0__225_39}"
                    result_2314+="${truncated_2325}"
                    get_visible_len__634_v0 "${truncated_2325}"
                    local ret_get_visible_len634_v0__227_40="${ret_get_visible_len634_v0}"
                    remaining_width_2315="$(( remaining_width_2315 - ret_get_visible_len634_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi636_v0="${result_2314}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__637_v0() {
    local text_2292="${1}"
    local max_width_2293="${2}"
    get_visible_len__634_v0 "${text_2292}"
    local visible_len_2302="${ret_get_visible_len634_v0}"
    if [ "$(( visible_len_2302 <= max_width_2293 ))" != 0 ]; then
        ret_cutoff_text637_v0="${text_2292}"
        return 0
    fi
    truncate_ansi__636_v0 "${text_2292}" "$(( max_width_2293 - 3 ))"
    local ret_truncate_ansi636_v0__243_12="${ret_truncate_ansi636_v0}"
    ret_cutoff_text637_v0="${ret_truncate_ansi636_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__638_v0() {
    local items_2330=("${!1}")
    local total_len_2331="${2}"
    local term_width_2332="${3}"
    local separator_2333=" • "
    local separator_len_2334=3
    # Fast path: no truncation needed
    if [ "$(( total_len_2331 <= term_width_2332 ))" != 0 ]; then
        local iter_2335=0
        while :
        do
            local __length_89=("${items_2330[@]}")
            if [ "$(( iter_2335 >= ${#__length_89[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_2335 > 0 ))" != 0 ]; then
                eprintf_colored__618_v0 "${separator_2333}" 90
            fi
            colored__619_v0 "${items_2330[$(( iter_2335 + 1 ))]?"Index out of bounds (at src/./input/../utils.ab:268:55)"}" 2
            local ret_colored619_v0__268_41="${ret_colored619_v0}"
            local array_90=("")
            eprintf__617_v0 "${items_2330[${iter_2335}]?"Index out of bounds (at src/./input/../utils.ab:268:27)"}"" ""${ret_colored619_v0__268_41}" array_90[@]
            iter_2335="$(( iter_2335 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_2340=0
        local first_2341=1
        local iter_2342=0
        while :
        do
            local __length_91=("${items_2330[@]}")
            if [ "$(( iter_2342 >= ${#__length_91[@]} ))" != 0 ]; then
                break
            fi
            local key_2343="${items_2330[${iter_2342}]?"Index out of bounds (at src/./input/../utils.ab:280:31)"}"
            local action_2344="${items_2330[$(( iter_2342 + 1 ))]?"Index out of bounds (at src/./input/../utils.ab:281:34)"}"
            local __length_92="${key_2343}"
            local __length_93="${action_2344}"
            local part_len_2345="$(( $(( ${#__length_92} + 1 )) + ${#__length_93} ))"
            local needed_2346="${part_len_2345}"
            if [ "$(( ! first_2341 ))" != 0 ]; then
                needed_2346="$(( needed_2346 + separator_len_2334 ))"
            fi
            if [ "$(( $(( current_len_2340 + needed_2346 )) > term_width_2332 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_2341 ))" != 0 ]; then
                eprintf_colored__618_v0 "${separator_2333}" 90
            fi
            colored__619_v0 "${action_2344}" 2
            local ret_colored619_v0__296_33="${ret_colored619_v0}"
            local array_94=("")
            eprintf__617_v0 "${key_2343}"" ""${ret_colored619_v0__296_33}" array_94[@]
            current_len_2340="$(( current_len_2340 + needed_2346 ))"
            first_2341=0
            iter_2342="$(( iter_2342 + 2 ))"
        done
    fi
}

# xyl_input(prompt: Text, placeholder: Text, header: Text, password: Bool)
xyl_input__688_v0() {
    local prompt_2275="${1}"
    local placeholder_2276="${2}"
    local header_2277="${3}"
    local password_2278="${4}"
    stty_lock__576_v0 
    term_width__583_v0 
    local term_width_2291="${ret_term_width583_v0}"
    if [ "$([ "_${header_2277}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__637_v0 "${header_2277}" "${term_width_2291}"
        local ret_cutoff_text637_v0__23_17="${ret_cutoff_text637_v0}"
        local array_95=("")
        eprintf__617_v0 "${ret_cutoff_text637_v0__23_17}""
" array_95[@]
    fi
    new_line__624_v0 2
    # "enter submit" = 12
    local array_96=("enter" "submit")
    render_tooltip__638_v0 array_96[@] 12 "${term_width_2291}"
    go_up__625_v0 2
    local array_97=("")
    eprintf__617_v0 "\\x1b[G" array_97[@]
    local array_98=("")
    eprintf__617_v0 "${prompt_2275}" array_98[@]
    eprintf_colored__618_v0 "${placeholder_2276}" 90
    get_char__614_v0 
    local char_2349="${ret_get_char614_v0}"
    local __length_99="${prompt_2275}"
    remove__620_v0 "${#__length_99}"
    local __length_100="${placeholder_2276}"
    remove__620_v0 "$(( ${#__length_100} + 1 ))"
    local text_2351=""
    if [ "$(( ! password_2278 ))" != 0 ]; then
        stty_unlock__577_v0 
        local command_101
        command_101="$(read -e -i ${char_2349} -p "${prompt_2275}" text < /dev/tty; printf "%s" "$text")"
        __status=$?
        text_2351="${command_101}"
    else
        stty_unlock__577_v0 
        local command_102
        command_102="$(read -es -i ${char_2349} -p "${prompt_2275}" text < /dev/tty; printf "%s" "$text")"
        __status=$?
        text_2351="${command_102}"
    fi
    stty_lock__576_v0 
    # Calculate how many lines the input takes up (prompt + text may wrap)
    get_visible_len__634_v0 "${prompt_2275}""${text_2351}"
    local input_display_len_2354="${ret_get_visible_len634_v0}"
    math_ceil__506_v0 "$(( input_display_len_2354 / term_width_2291 ))"
    local input_lines_2357="${ret_math_ceil506_v0}"
    if [ "$(( input_lines_2357 < 3 ))" != 0 ]; then
        go_down__626_v0 "$(( 2 - input_lines_2357 ))"
        remove_line__621_v0 2
        remove_current_line__622_v0 
    fi
    if [ "$(( input_lines_2357 >= 3 ))" != 0 ]; then
        remove_line__621_v0 "${input_lines_2357}"
    fi
    if [ "$([ "_${header_2277}" == "_" ]; echo $?)" != 0 ]; then
        remove_line__621_v0 1
        remove_current_line__622_v0 
    fi
    stty_unlock__577_v0 
    ret_xyl_input688_v0="${text_2351}"
    return 0
}

# print_input_help()
print_input_help__781_v0() {
    echo "Usage: ./xylitol.sh input [flags]"
    printf '%s\n' ""
    colored_primary__599_v0 "input"
    local ret_colored_primary599_v0__7_12="${ret_colored_primary599_v0}"
    local array_103=()
    printf__128_v1 "${ret_colored_primary599_v0__7_12}" array_103[@]
    local array_104=()
    printf__128_v1 " - Prompt for some input from the user." array_104[@]
    printf '%s\n' ""
    printf '%s\n' ""
    colored_secondary__600_v0 "Flags: "
    local ret_colored_secondary600_v0__11_12="${ret_colored_secondary600_v0}"
    local array_105=()
    printf__128_v1 "${ret_colored_secondary600_v0__11_12}""
" array_105[@]
    echo "  -h, --help                 Show this help message"
    echo "  --placeholder=\"<text>\"     Set the placeholder text (default: 'Type here...')"
    echo "  --prompt=\"<text>\"          Set the prompt text (default: '> ')"
    echo "  --header=\"<text>\"          Set a header text to display above the prompt (ANSI escape supported)"
    echo "  --password                 Hide input (for password entry)"
    printf '%s\n' ""
}

# execute_input(parameters: [Text])
execute_input__832_v0() {
    local parameters_2238=("${!1}")
    local prompt_2239="> "
    local placeholder_2240="Type here..."
    local header_2241=""
    local password_2242=0
    for param_2243 in "${parameters_2238[@]}"; do
        match_regex__19_v0 "${param_2243}" "^-h\$" 0
        local ret_match_regex19_v0__13_12="${ret_match_regex19_v0}"
        match_regex__19_v0 "${param_2243}" "^--help\$" 0
        local ret_match_regex19_v0__13_42="${ret_match_regex19_v0}"
        if [ "$(( ret_match_regex19_v0__13_12 || ret_match_regex19_v0__13_42 ))" != 0 ]; then
            print_input_help__781_v0 
            exit 0
        fi
        match_regex__19_v0 "${param_2243}" "^--prompt=.*\$" 0
        local ret_match_regex19_v0__17_12="${ret_match_regex19_v0}"
        if [ "${ret_match_regex19_v0__17_12}" != 0 ]; then
            split__4_v0 "${param_2243}" "="
            local result_2268=("${ret_split4_v0[@]}")
            prompt_2239="${result_2268[1]?"Index out of bounds (at src/./input/exec.ab:19:29)"}"
        fi
        match_regex__19_v0 "${param_2243}" "^--placeholder=.*\$" 0
        local ret_match_regex19_v0__21_12="${ret_match_regex19_v0}"
        if [ "${ret_match_regex19_v0__21_12}" != 0 ]; then
            split__4_v0 "${param_2243}" "="
            local result_2269=("${ret_split4_v0[@]}")
            placeholder_2240="${result_2269[1]?"Index out of bounds (at src/./input/exec.ab:23:34)"}"
        fi
        match_regex__19_v0 "${param_2243}" "^--header=.*\$" 0
        local ret_match_regex19_v0__25_12="${ret_match_regex19_v0}"
        if [ "${ret_match_regex19_v0__25_12}" != 0 ]; then
            split__4_v0 "${param_2243}" "="
            local result_2270=("${ret_split4_v0[@]}")
            header_2241="${result_2270[1]?"Index out of bounds (at src/./input/exec.ab:27:29)"}"
        fi
        match_regex__19_v0 "${param_2243}" "^--password\$" 0
        local ret_match_regex19_v0__29_12="${ret_match_regex19_v0}"
        if [ "${ret_match_regex19_v0__29_12}" != 0 ]; then
            password_2242=1
        fi
    done
    has_ansi_escape__630_v0 "${header_2241}"
    local ret_has_ansi_escape630_v0__34_44="${ret_has_ansi_escape630_v0}"
    escape_ansi__631_v0 "${header_2241}"
    local ret_escape_ansi631_v0__34_73="${ret_escape_ansi631_v0}"
    colored_primary__599_v0 "${header_2241}"
    local ret_colored_primary599_v0__34_111="${ret_colored_primary599_v0}"
    local display_header_2274
    display_header_2274="$(if [ "$(( $([ "_${header_2241}" != "_" ]; echo $?) || ret_has_ansi_escape630_v0__34_44 ))" != 0 ]; then echo "${ret_escape_ansi631_v0__34_73}"; else echo "\\x1b[1m""${ret_colored_primary599_v0__34_111}"; fi)"
    xyl_input__688_v0 "${prompt_2239}" "${placeholder_2240}" "${display_header_2274}" "${password_2242}"
    ret_execute_input832_v0="${ret_xyl_input688_v0}"
    return 0
}

# Perl Extensions Utilities
command_108="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_21="$([ "_${command_108}" != "_No" ]; echo $?)"
command_109="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_22="$(( $(( ! _perl_disabled_21 )) && $([ "_${command_109}" != "_0" ]; echo $?) ))"
# perl_get_cjk_width(text: Text)
perl_get_cjk_width__970_v0() {
    local text_8042="${1}"
    if [ "$(( ! _perl_available_22 ))" != 0 ]; then
        ret_perl_get_cjk_width970_v0=''
        return 1
    fi
    local command_110
    command_110="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_8042}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width970_v0=''
        return "${__status}"
    fi
    local width_str_8043="${command_110}"
    parse_int__13_v0 "${width_str_8043}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width970_v0=''
        return "${__status}"
    fi
    local width_8044="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width970_v0="${width_8044}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__971_v0() {
    local text_8051="${1}"
    local max_width_8052="${2}"
    if [ "$(( ! _perl_available_22 ))" != 0 ]; then
        ret_perl_truncate_cjk971_v0=''
        return 1
    fi
    local command_111
    command_111="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_8051}" ${max_width_8052} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk971_v0=''
        return "${__status}"
    fi
    local result_8053="${command_111}"
    ret_perl_truncate_cjk971_v0="${result_8053}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_23=0
_term_size_24=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_lock()
stty_lock__979_v0() {
    local command_113
    command_113="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_8020="${command_113}"
    parse_int__13_v0 "${count_8020}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_8021="${ret_parse_int13_v0}"
    if [ "$(( count_num_8021 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_8021="$(( count_num_8021 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_8021}
    __status=$?
}

# stty_unlock()
stty_unlock__980_v0() {
    local command_114
    command_114="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_8149="${command_114}"
    parse_int__13_v0 "${count_8149}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_8150="${ret_parse_int13_v0}"
    if [ "$(( count_num_8150 > 0 ))" != 0 ]; then
        count_num_8150="$(( count_num_8150 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_8150}
        __status=$?
        if [ "$(( count_num_8150 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# parse_size(text: Text)
parse_size__981_v0() {
    local text_8024="${1}"
    # `match_regex` uses BRE by default, where `+` is a literal character
    match_regex__19_v0 "${text_8024}" "^[0-9][0-9]*\$" 0
    local ret_match_regex19_v0__38_12="${ret_match_regex19_v0}"
    if [ "$(( ! ret_match_regex19_v0__38_12 ))" != 0 ]; then
        ret_parse_size981_v0=0
        return 0
    fi
    parse_int__13_v0 "${text_8024}"
    __status=$?
    ret_parse_size981_v0="${ret_parse_int13_v0}"
    return 0
}

# query_term_size()
query_term_size__982_v0() {
    local command_115
    command_115="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; echo "$height; $width")"
    __status=$?
    local result_8022="${command_115}"
    split__4_v0 "${result_8022}" ";"
    local parts_8023=("${ret_split4_v0[@]}")
    local __length_116=("${parts_8023[@]}")
    if [ "$(( ${#__length_116[@]} != 2 ))" != 0 ]; then
        ret_query_term_size982_v0=0
        return 0
    fi
    parse_size__981_v0 "${parts_8023[0]?"Index out of bounds (at src/./choose/../utils/term.ab:53:35)"}"
    local rows_8025="${ret_parse_size981_v0}"
    parse_size__981_v0 "${parts_8023[1]?"Index out of bounds (at src/./choose/../utils/term.ab:54:35)"}"
    local cols_8026="${ret_parse_size981_v0}"
    if [ "$(( $(( rows_8025 <= 0 )) || $(( cols_8026 <= 0 )) ))" != 0 ]; then
        ret_query_term_size982_v0=0
        return 0
    fi
    _term_size_24=("${cols_8026}" "${rows_8025}")
    ret_query_term_size982_v0=1
    return 0
}

# stty_term_size()
stty_term_size__983_v0() {
    local command_118
    command_118="$(stty size < /dev/tty 2>/dev/null)"
    __status=$?
    local result_8028="${command_118}"
    split__4_v0 "${result_8028}" " "
    local parts_8029=("${ret_split4_v0[@]}")
    local __length_119=("${parts_8029[@]}")
    if [ "$(( ${#__length_119[@]} != 2 ))" != 0 ]; then
        ret_stty_term_size983_v0=0
        return 0
    fi
    parse_size__981_v0 "${parts_8029[0]?"Index out of bounds (at src/./choose/../utils/term.ab:70:35)"}"
    local rows_8030="${ret_parse_size981_v0}"
    parse_size__981_v0 "${parts_8029[1]?"Index out of bounds (at src/./choose/../utils/term.ab:71:35)"}"
    local cols_8031="${ret_parse_size981_v0}"
    if [ "$(( $(( rows_8030 <= 0 )) || $(( cols_8031 <= 0 )) ))" != 0 ]; then
        ret_stty_term_size983_v0=0
        return 0
    fi
    _term_size_24=("${cols_8031}" "${rows_8030}")
    ret_stty_term_size983_v0=1
    return 0
}

# get_term_size()
get_term_size__984_v0() {
    query_term_size__982_v0 
    local detected_8027="${ret_query_term_size982_v0}"
    if [ "$(( ! detected_8027 ))" != 0 ]; then
        stty_term_size__983_v0 
        detected_8027="${ret_stty_term_size983_v0}"
    fi
    _got_term_size_23=1
}

# term_width()
term_width__986_v0() {
    if [ "$(( ! _got_term_size_23 ))" != 0 ]; then
        get_term_size__984_v0 
    fi
    ret_term_width986_v0="${_term_size_24[0]?"Index out of bounds (at src/./choose/../utils/term.ab:101:23)"}"
    return 0
}

# term_height()
term_height__987_v0() {
    if [ "$(( ! _got_term_size_23 ))" != 0 ]; then
        get_term_size__984_v0 
    fi
    ret_term_height987_v0="${_term_size_24[1]?"Index out of bounds (at src/./choose/../utils/term.ab:109:23)"}"
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
get_supports_truecolor__997_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local config_7992="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_7992}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_25="No"
        ret_get_supports_truecolor997_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_25="No"
        ret_get_supports_truecolor997_v0=0
        return 0
    fi
    local colorterm_7993="${ret_env_var_get120_v0}"
    _supports_truecolor_25="$(if [ "$(( $([ "_${colorterm_7993}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_7993}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor997_v0="$([ "_${_supports_truecolor_25}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__998_v0() {
    local message_7987="${1}"
    local r_7988="${2}"
    local g_7989="${3}"
    local b_7990="${4}"
    local fallback_7991="${5}"
    if [ "$([ "_${_supports_truecolor_25}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb998_v0="\\x1b[38;2;${r_7988};${g_7989};${b_7990}m""${message_7987}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_25}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__997_v0 
        local ret_get_supports_truecolor997_v0__50_17="${ret_get_supports_truecolor997_v0}"
        if [ "${ret_get_supports_truecolor997_v0__50_17}" != 0 ]; then
            ret_colored_rgb998_v0="\\x1b[38;2;${r_7988};${g_7989};${b_7990}m""${message_7987}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_7991 == 0 ))" != 0 ]; then
            ret_colored_rgb998_v0="${message_7987}"
            return 0
        else
            ret_colored_rgb998_v0="\\x1b[${fallback_7991}m""${message_7987}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_7991 == 0 ))" != 0 ]; then
            ret_colored_rgb998_v0="${message_7987}"
            return 0
        fi
        ret_colored_rgb998_v0="\\x1b[${fallback_7991}m""${message_7987}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1000_v0() {
    if [ "$(( ! _got_xylitol_colors_26 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local primary_env_7981="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_7981}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_7981}" ";"
            local parts_7982=("${ret_split4_v0[@]}")
            local __length_124=("${parts_7982[@]}")
            if [ "$(( ${#__length_124[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_7982[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1000_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_7982[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1000_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_7982[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1000_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_7982[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1000_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
                _primary_color_27=("${ret_parse_int13_v0__115_21}" "${ret_parse_int13_v0__116_21}" "${ret_parse_int13_v0__117_21}" "${ret_parse_int13_v0__118_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local secondary_env_7983="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_7983}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_7983}" ";"
            local parts_7984=("${ret_split4_v0[@]}")
            local __length_126=("${parts_7984[@]}")
            if [ "$(( ${#__length_126[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_7984[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1000_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_7984[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1000_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_7984[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1000_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_7984[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1000_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_28=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local accent_env_7985="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_7985}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_7985}" ";"
            local parts_7986=("${ret_split4_v0[@]}")
            local __length_128=("${parts_7986[@]}")
            if [ "$(( ${#__length_128[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_7986[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1000_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_7986[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1000_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_7986[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1000_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_7986[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1000_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_26=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__1001_v0() {
    inner_get_xylitol_colors__1000_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_26=1
}

# colored_primary(message: Text)
colored_primary__1002_v0() {
    local message_7980="${1}"
    if [ "$(( ! _got_xylitol_colors_26 ))" != 0 ]; then
        get_xylitol_colors__1001_v0 
    fi
    colored_rgb__998_v0 "${message_7980}" "${_primary_color_27[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:164:48)"}" "${_primary_color_27[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:164:67)"}" "${_primary_color_27[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:164:86)"}" "${_primary_color_27[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:164:105)"}"
    ret_colored_primary1002_v0="${ret_colored_rgb998_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1003_v0() {
    local message_8002="${1}"
    if [ "$(( ! _got_xylitol_colors_26 ))" != 0 ]; then
        get_xylitol_colors__1001_v0 
    fi
    colored_rgb__998_v0 "${message_8002}" "${_secondary_color_28[0]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:171:50)"}" "${_secondary_color_28[1]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:171:71)"}" "${_secondary_color_28[2]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:171:92)"}" "${_secondary_color_28[3]?"Index out of bounds (at src/./choose/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary1003_v0="${ret_colored_rgb998_v0}"
    return 0
}

# // IO Functions /////
# get_key()
get_key__1018_v0() {
    local command_130
    command_130="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_8121="${command_130}"
    if [ "$([ "_${var_8121}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1018_v0="UP"
        return 0
    elif [ "$([ "_${var_8121}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1018_v0="DOWN"
        return 0
    elif [ "$([ "_${var_8121}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1018_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_8121}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1018_v0="LEFT"
        return 0
    elif [ "$([ "_${var_8121}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1018_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_8121}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1018_v0="INPUT"
        return 0
    else
        ret_get_key1018_v0="${var_8121}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1020_v0() {
    local format_8008="${1}"
    local args_8009=("${!2}")
    args_8009=("${format_8008}" "${args_8009[@]}")
    __status=$?
    printf "${args_8009[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1021_v0() {
    local message_8006="${1}"
    local color_8007="${2}"
    # Prints an error message with a specified color.
    local array_131=("${message_8006}")
    eprintf__1020_v0 "\\x1b[${color_8007}m%s\\x1b[0m" array_131[@]
}

# colored(message: Text, color: Int)
colored__1022_v0() {
    local message_8081="${1}"
    local color_8082="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1022_v0="\\x1b[${color_8082}m""${message_8081}""\\x1b[0m"
    return 0
}

# remove_line(cnt: Int)
remove_line__1024_v0() {
    local cnt_8136="${1}"
    if [ "$(( cnt_8136 > 0 ))" != 0 ]; then
        local sequence_8137=""
        local __range_start_8138=0
        local __range_end_8138="${cnt_8136}"
        local __dir_8138=$(( ${__range_start_8138} <= ${__range_end_8138} ? 1 : -1 ))
        for (( ____8138=${__range_start_8138}; ____8138 * ${__dir_8138} < ${__range_end_8138} * ${__dir_8138}; ____8138+=${__dir_8138} )); do
            sequence_8137+="\\x1b[2K\\x1b[1A"
done
        local array_132=("")
        eprintf__1020_v0 "${sequence_8137}" array_132[@]
    fi
    local array_133=("")
    eprintf__1020_v0 "\\x1b[G" array_133[@]
}

# remove_current_line()
remove_current_line__1025_v0() {
    local array_134=("")
    eprintf__1020_v0 "\\x1b[2K\\x1b[G" array_134[@]
}

# print_blank(cnt: Int)
print_blank__1026_v0() {
    local cnt_8118="${1}"
    printf '%*s' "${cnt_8118}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__1027_v0() {
    local cnt_8073="${1}"
    local __range_start_8074=0
    local __range_end_8074="${cnt_8073}"
    local __dir_8074=$(( ${__range_start_8074} <= ${__range_end_8074} ? 1 : -1 ))
    for (( ____8074=${__range_start_8074}; ____8074 * ${__dir_8074} < ${__range_end_8074} * ${__dir_8074}; ____8074+=${__dir_8074} )); do
        local array_135=("")
        eprintf__1020_v0 "
" array_135[@]
done
}

# go_up(cnt: Int)
go_up__1028_v0() {
    local cnt_8090="${1}"
    local array_136=("")
    eprintf__1020_v0 "\\x1b[${cnt_8090}A" array_136[@]
}

# go_down(cnt: Int)
go_down__1029_v0() {
    local cnt_8132="${1}"
    local array_137=("")
    eprintf__1020_v0 "\\x1b[${cnt_8132}B" array_137[@]
}

# move the cursor up or down `cnt` lines.
# go_up_or_down(cnt: Int)
go_up_or_down__1030_v0() {
    local cnt_8143="${1}"
    if [ "$(( cnt_8143 > 0 ))" != 0 ]; then
        go_down__1029_v0 "${cnt_8143}"
    else
        go_up__1028_v0 "$(( - cnt_8143 ))"
    fi
}

# hide_cursor()
hide_cursor__1031_v0() {
    local array_138=("")
    eprintf__1020_v0 "\\x1b[?25l" array_138[@]
}

# show_cursor()
show_cursor__1032_v0() {
    local array_139=("")
    eprintf__1020_v0 "\\x1b[?25h" array_139[@]
}

# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__1033_v0() {
    local text_8011="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_140
    command_140="$([[ "${text_8011}" == *$'\x1b'* || "${text_8011}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_8012="${command_140}"
    ret_has_ansi_escape1033_v0="$([ "_${has_escape_8012}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1034_v0() {
    local text_8013="${1}"
    local command_141
    command_141="$(printf '%s' "${text_8013}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1034_v0="${command_141}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1035_v0() {
    local text_8038="${1}"
    local command_142
    command_142="$(printf "%s" "${text_8038}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1035_v0="${command_142}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1036_v0() {
    local text_8040="${1}"
    local command_143
    command_143="$(printf "%s" "${text_8040}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_8041="${command_143}"
    ret_is_all_ascii1036_v0="$([ "_${result_8041}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1037_v0() {
    local text_8037="${1}"
    strip_ansi__1035_v0 "${text_8037}"
    local stripped_8039="${ret_strip_ansi1035_v0}"
    # Check if text is all ASCII
    is_all_ascii__1036_v0 "${stripped_8039}"
    local ret_is_all_ascii1036_v0__150_12="${ret_is_all_ascii1036_v0}"
    if [ "$(( ! ret_is_all_ascii1036_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__970_v0 "${stripped_8039}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_144="${stripped_8039}"
            ret_get_visible_len1037_v0="${#__length_144}"
            return 0
        fi
        ret_get_visible_len1037_v0="${ret_perl_get_cjk_width970_v0}"
        return 0
    else
        local __length_145="${stripped_8039}"
        ret_get_visible_len1037_v0="${#__length_145}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1038_v0() {
    local text_8048="${1}"
    local max_width_8049="${2}"
    get_visible_len__1037_v0 "${text_8048}"
    local visible_len_8050="${ret_get_visible_len1037_v0}"
    if [ "$(( visible_len_8050 <= max_width_8049 ))" != 0 ]; then
        ret_truncate_text1038_v0="${text_8048}"
        return 0
    fi
    is_all_ascii__1036_v0 "${text_8048}"
    local ret_is_all_ascii1036_v0__167_12="${ret_is_all_ascii1036_v0}"
    if [ "$(( ! ret_is_all_ascii1036_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__971_v0 "${text_8048}" "${max_width_8049}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_8048}" | cut -c1-${max_width_8049}
            __status=$?
        fi
        ret_truncate_text1038_v0="${ret_perl_truncate_cjk971_v0}"
        return 0
    fi
    local command_146
    command_146="$(printf "%s" "${text_8048}" | cut -c1-${max_width_8049})"
    __status=$?
    ret_truncate_text1038_v0="${command_146}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1039_v0() {
    local text_8046="${1}"
    local max_width_8047="${2}"
    has_ansi_escape__1033_v0 "${text_8046}"
    local ret_has_ansi_escape1033_v0__179_12="${ret_has_ansi_escape1033_v0}"
    if [ "$(( ! ret_has_ansi_escape1033_v0__179_12 ))" != 0 ]; then
        truncate_text__1038_v0 "${text_8046}" "${max_width_8047}"
        ret_truncate_ansi1039_v0="${ret_truncate_text1038_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_147
    command_147="$([[ "${text_8046}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_8054="${command_147}"
    # Replace \x1b[ with newline, then split
    local command_148
    command_148="$(t="${text_8046}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_8055="${command_148}"
    split__4_v0 "${replaced_8055}" "
"
    local parts_8056=("${ret_split4_v0[@]}")
    local result_8057=""
    local remaining_width_8058="${max_width_8047}"
    local __range_start_8059=0
    local __length_149=("${parts_8056[@]}")
    local __range_end_8059="${#__length_149[@]}"
    local __dir_8059=$(( ${__range_start_8059} <= ${__range_end_8059} ? 1 : -1 ))
    for (( idx_8059=${__range_start_8059}; idx_8059 * ${__dir_8059} < ${__range_end_8059} * ${__dir_8059}; idx_8059+=${__dir_8059} )); do
        local part_8060="${parts_8056[${idx_8059}]?"Index out of bounds (at src/./choose/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_8059 == 0 )) && $([ "_${starts_with_ansi_8054}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_8060}" == "_" ]; echo $?) && $(( remaining_width_8058 > 0 )) ))" != 0 ]; then
                truncate_text__1038_v0 "${part_8060}" "${remaining_width_8058}"
                local ret_truncate_text1038_v0__201_35="${ret_truncate_text1038_v0}"
                local truncated_8061="${ret_truncate_text1038_v0__201_35}"
                result_8057+="${truncated_8061}"
                get_visible_len__1037_v0 "${truncated_8061}"
                local ret_get_visible_len1037_v0__203_36="${ret_get_visible_len1037_v0}"
                remaining_width_8058="$(( remaining_width_8058 - ret_get_visible_len1037_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_150
            command_150="$(__p="${part_8060}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_8062="${command_150}"
            if [ "$([ "_${m_idx_8062}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_151
                command_151="$(__p="${part_8060}"; printf "%s" "${__p:0:${m_idx_8062}}")"
                __status=$?
                local ansi_params_8063="${command_151}"
                result_8057+="\\x1b[""${ansi_params_8063}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_8062}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_8064="${ret_parse_int13_v0__214_41}"
                local text_start_8065="$(( m_idx_num_8064 + 1 ))"
                local command_152
                command_152="$(__p="${part_8060}"; printf "%s" "${__p:${text_start_8065}}")"
                __status=$?
                local text_part_8066="${command_152}"
                if [ "$(( $([ "_${text_part_8066}" == "_" ]; echo $?) && $(( remaining_width_8058 > 0 )) ))" != 0 ]; then
                    truncate_text__1038_v0 "${text_part_8066}" "${remaining_width_8058}"
                    local ret_truncate_text1038_v0__218_39="${ret_truncate_text1038_v0}"
                    local truncated_8067="${ret_truncate_text1038_v0__218_39}"
                    result_8057+="${truncated_8067}"
                    get_visible_len__1037_v0 "${truncated_8067}"
                    local ret_get_visible_len1037_v0__220_40="${ret_get_visible_len1037_v0}"
                    remaining_width_8058="$(( remaining_width_8058 - ret_get_visible_len1037_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_8060}" == "_" ]; echo $?) && $(( remaining_width_8058 > 0 )) ))" != 0 ]; then
                    truncate_text__1038_v0 "${part_8060}" "${remaining_width_8058}"
                    local ret_truncate_text1038_v0__225_39="${ret_truncate_text1038_v0}"
                    local truncated_8068="${ret_truncate_text1038_v0__225_39}"
                    result_8057+="${truncated_8068}"
                    get_visible_len__1037_v0 "${truncated_8068}"
                    local ret_get_visible_len1037_v0__227_40="${ret_get_visible_len1037_v0}"
                    remaining_width_8058="$(( remaining_width_8058 - ret_get_visible_len1037_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1039_v0="${result_8057}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1040_v0() {
    local text_8035="${1}"
    local max_width_8036="${2}"
    get_visible_len__1037_v0 "${text_8035}"
    local visible_len_8045="${ret_get_visible_len1037_v0}"
    if [ "$(( visible_len_8045 <= max_width_8036 ))" != 0 ]; then
        ret_cutoff_text1040_v0="${text_8035}"
        return 0
    fi
    truncate_ansi__1039_v0 "${text_8035}" "$(( max_width_8036 - 3 ))"
    local ret_truncate_ansi1039_v0__243_12="${ret_truncate_ansi1039_v0}"
    ret_cutoff_text1040_v0="${ret_truncate_ansi1039_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__1041_v0() {
    local items_8075=("${!1}")
    local total_len_8076="${2}"
    local term_width_8077="${3}"
    local separator_8078=" • "
    local separator_len_8079=3
    # Fast path: no truncation needed
    if [ "$(( total_len_8076 <= term_width_8077 ))" != 0 ]; then
        local iter_8080=0
        while :
        do
            local __length_153=("${items_8075[@]}")
            if [ "$(( iter_8080 >= ${#__length_153[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_8080 > 0 ))" != 0 ]; then
                eprintf_colored__1021_v0 "${separator_8078}" 90
            fi
            colored__1022_v0 "${items_8075[$(( iter_8080 + 1 ))]?"Index out of bounds (at src/./choose/../utils.ab:268:55)"}" 2
            local ret_colored1022_v0__268_41="${ret_colored1022_v0}"
            local array_154=("")
            eprintf__1020_v0 "${items_8075[${iter_8080}]?"Index out of bounds (at src/./choose/../utils.ab:268:27)"}"" ""${ret_colored1022_v0__268_41}" array_154[@]
            iter_8080="$(( iter_8080 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_8083=0
        local first_8084=1
        local iter_8085=0
        while :
        do
            local __length_155=("${items_8075[@]}")
            if [ "$(( iter_8085 >= ${#__length_155[@]} ))" != 0 ]; then
                break
            fi
            local key_8086="${items_8075[${iter_8085}]?"Index out of bounds (at src/./choose/../utils.ab:280:31)"}"
            local action_8087="${items_8075[$(( iter_8085 + 1 ))]?"Index out of bounds (at src/./choose/../utils.ab:281:34)"}"
            local __length_156="${key_8086}"
            local __length_157="${action_8087}"
            local part_len_8088="$(( $(( ${#__length_156} + 1 )) + ${#__length_157} ))"
            local needed_8089="${part_len_8088}"
            if [ "$(( ! first_8084 ))" != 0 ]; then
                needed_8089="$(( needed_8089 + separator_len_8079 ))"
            fi
            if [ "$(( $(( current_len_8083 + needed_8089 )) > term_width_8077 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_8084 ))" != 0 ]; then
                eprintf_colored__1021_v0 "${separator_8078}" 90
            fi
            colored__1022_v0 "${action_8087}" 2
            local ret_colored1022_v0__296_33="${ret_colored1022_v0}"
            local array_158=("")
            eprintf__1020_v0 "${key_8086}"" ""${ret_colored1022_v0__296_33}" array_158[@]
            current_len_8083="$(( current_len_8083 + needed_8089 ))"
            first_8084=0
            iter_8085="$(( iter_8085 + 2 ))"
        done
    fi
}

# get_page_options(options: [Text], page: Int, page_size: Int)
get_page_options__1091_v0() {
    local options_8093=("${!1}")
    local page_8094="${2}"
    local page_size_8095="${3}"
    local start_8096="$(( page_8094 * page_size_8095 ))"
    local end_8097="$(( start_8096 + page_size_8095 ))"
    local __length_159=("${options_8093[@]}")
    if [ "$(( end_8097 > ${#__length_159[@]} ))" != 0 ]; then
        local __length_160=("${options_8093[@]}")
        end_8097="${#__length_160[@]}"
    fi
    local result_8098=()
    local __range_start_8099="${start_8096}"
    local __range_end_8099="${end_8097}"
    local __dir_8099=$(( ${__range_start_8099} <= ${__range_end_8099} ? 1 : -1 ))
    for (( i_8099=${__range_start_8099}; i_8099 * ${__dir_8099} < ${__range_end_8099} * ${__dir_8099}; i_8099+=${__dir_8099} )); do
        local array_162=("${options_8093[${i_8099}]?"Index out of bounds (at src/./choose/./mod.ab:13:28)"}")
        result_8098+=("${array_162[@]}")
done
    ret_get_page_options1091_v0=("${result_8098[@]}")
    return 0
}

# get_page_start(page: Int, page_size: Int)
get_page_start__1092_v0() {
    local page_8101="${1}"
    local page_size_8102="${2}"
    ret_get_page_start1092_v0="$(( page_8101 * page_size_8102 ))"
    return 0
}

# render_choose_page(page_options: [Text], sel: Int, cursor: Text, display_count: Int, term_width: Int)
render_choose_page__1093_v0() {
    local page_options_8166=("${!1}")
    local sel_8167="${2}"
    local cursor_8168="${3}"
    local display_count_8169="${4}"
    local term_width_8170="${5}"
    local __length_163="${cursor_8168}"
    local cursor_len_8171="${#__length_163}"
    local max_option_width_8172="$(( $(( term_width_8170 - cursor_len_8171 )) - 1 ))"
    local __range_start_8173=0
    local __length_164=("${page_options_8166[@]}")
    local __range_end_8173="${#__length_164[@]}"
    local __dir_8173=$(( ${__range_start_8173} <= ${__range_end_8173} ? 1 : -1 ))
    for (( i_8173=${__range_start_8173}; i_8173 * ${__dir_8173} < ${__range_end_8173} * ${__dir_8173}; i_8173+=${__dir_8173} )); do
        cutoff_text__1040_v0 "${page_options_8166[${i_8173}]?"Index out of bounds (at src/./choose/./mod.ab:26:59)"}" "${max_option_width_8172}"
        local ret_cutoff_text1040_v0__26_34="${ret_cutoff_text1040_v0}"
        local truncated_option_8174="${ret_cutoff_text1040_v0__26_34}"
        if [ "$(( i_8173 == sel_8167 ))" != 0 ]; then
            colored_secondary__1003_v0 "${cursor_8168}""${truncated_option_8174}""
"
            local ret_colored_secondary1003_v0__28_21="${ret_colored_secondary1003_v0}"
            local array_165=("")
            eprintf__1020_v0 "${ret_colored_secondary1003_v0__28_21}" array_165[@]
        else
            print_blank__1026_v0 "${cursor_len_8171}"
            local array_166=("")
            eprintf__1020_v0 "${truncated_option_8174}""
" array_166[@]
        fi
done
    local __length_167=("${page_options_8166[@]}")
    local remaining_slots_8175="$(( display_count_8169 - ${#__length_167[@]} ))"
    if [ "$(( remaining_slots_8175 > 0 ))" != 0 ]; then
        # Amber bug gaurd
        local __range_start_8176=0
        local __range_end_8176="${remaining_slots_8175}"
        local __dir_8176=$(( ${__range_start_8176} <= ${__range_end_8176} ? 1 : -1 ))
        for (( ____8176=${__range_start_8176}; ____8176 * ${__dir_8176} < ${__range_end_8176} * ${__dir_8176}; ____8176+=${__dir_8176} )); do
            local array_168=("")
            eprintf__1020_v0 "\\x1b[K
" array_168[@]
done
    fi
}

# render_multi_choose_page(page_options: [Text], checked: [Bool], page_start: Int, sel: Int, cursor: Text, display_count: Int, term_width: Int)
render_multi_choose_page__1094_v0() {
    local page_options_8104=("${!1}")
    local checked_8105=("${!2}")
    local page_start_8106="${3}"
    local sel_8107="${4}"
    local cursor_8108="${5}"
    local display_count_8109="${6}"
    local term_width_8110="${7}"
    local __length_169="${cursor_8108}"
    local cursor_len_8111="${#__length_169}"
    local check_mark_len_8112=2
    # "✓ " or "• "
    local max_option_width_8113="$(( $(( $(( term_width_8110 - cursor_len_8111 )) - check_mark_len_8112 )) - 1 ))"
    local __range_start_8114=0
    local __length_170=("${page_options_8104[@]}")
    local __range_end_8114="${#__length_170[@]}"
    local __dir_8114=$(( ${__range_start_8114} <= ${__range_end_8114} ? 1 : -1 ))
    for (( i_8114=${__range_start_8114}; i_8114 * ${__dir_8114} < ${__range_end_8114} * ${__dir_8114}; i_8114+=${__dir_8114} )); do
        local global_idx_8115="$(( page_start_8106 + i_8114 ))"
        local check_mark_8116
        check_mark_8116="$(if [ "${checked_8105[${global_idx_8115}]?"Index out of bounds (at src/./choose/./mod.ab:48:36)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__1040_v0 "${page_options_8104[${i_8114}]?"Index out of bounds (at src/./choose/./mod.ab:49:59)"}" "${max_option_width_8113}"
        local ret_cutoff_text1040_v0__49_34="${ret_cutoff_text1040_v0}"
        local truncated_option_8117="${ret_cutoff_text1040_v0__49_34}"
        if [ "$(( i_8114 == sel_8107 ))" != 0 ]; then
            colored_secondary__1003_v0 "${cursor_8108}""${check_mark_8116}""${truncated_option_8117}""
"
            local ret_colored_secondary1003_v0__51_31="${ret_colored_secondary1003_v0}"
            local array_171=("")
            eprintf__1020_v0 "${ret_colored_secondary1003_v0__51_31}" array_171[@]
        elif [ "${checked_8105[${global_idx_8115}]?"Index out of bounds (at src/./choose/./mod.ab:52:21)"}" != 0 ]; then
            print_blank__1026_v0 "${cursor_len_8111}"
            colored_secondary__1003_v0 "${check_mark_8116}""${truncated_option_8117}""
"
            local ret_colored_secondary1003_v0__54_25="${ret_colored_secondary1003_v0}"
            local array_172=("")
            eprintf__1020_v0 "${ret_colored_secondary1003_v0__54_25}" array_172[@]
        else
            print_blank__1026_v0 "${cursor_len_8111}"
            local array_173=("")
            eprintf__1020_v0 "${check_mark_8116}""${truncated_option_8117}""
" array_173[@]
        fi
done
    local __length_174=("${page_options_8104[@]}")
    local remaining_slots_8119="$(( display_count_8109 - ${#__length_174[@]} ))"
    if [ "$(( remaining_slots_8119 > 0 ))" != 0 ]; then
        # Amber bug guard
        local __range_start_8120=0
        local __range_end_8120="${remaining_slots_8119}"
        local __dir_8120=$(( ${__range_start_8120} <= ${__range_end_8120} ? 1 : -1 ))
        for (( ____8120=${__range_start_8120}; ____8120 * ${__dir_8120} < ${__range_end_8120} * ${__dir_8120}; ____8120+=${__dir_8120} )); do
            local array_175=("")
            eprintf__1020_v0 "\\x1b[K
" array_175[@]
done
    fi
}

# render_page_indicator(page: Int, total_pages: Int)
render_page_indicator__1095_v0() {
    local page_8139="${1}"
    local total_pages_8140="${2}"
    if [ "$(( total_pages_8140 > 1 ))" != 0 ]; then
        local array_176=("")
        eprintf__1020_v0 "\\x1b[G\\x1b[K" array_176[@]
        eprintf_colored__1021_v0 "Page $(( page_8139 + 1 ))/${total_pages_8140}" 90
        local array_177=("")
        eprintf__1020_v0 "\\x1b[G" array_177[@]
    fi
}

# xyl_choose(options: [Text], cursor: Text, header: Text, page_size: Int)
xyl_choose__1096_v0() {
    local options_8154=("${!1}")
    local cursor_8155="${2}"
    local header_8156="${3}"
    local page_size_8157="${4}"
    local __length_178=("${options_8154[@]}")
    if [ "$(( ${#__length_178[@]} == 0 ))" != 0 ]; then
        eprintf_colored__1021_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    stty_lock__979_v0 
    hide_cursor__1031_v0 
    term_width__986_v0 
    local term_width_8158="${ret_term_width986_v0}"
    term_height__987_v0 
    local term_height_8159="${ret_term_height987_v0}"
    local max_page_size_8160
    max_page_size_8160="$(( term_height_8159 - $(if [ "$([ "_${header_8156}" != "_" ]; echo $?)" != 0 ]; then echo 2; else echo 3; fi) ))"
    if [ "$(( page_size_8157 > max_page_size_8160 ))" != 0 ]; then
        page_size_8157="${max_page_size_8160}"
    fi
    if [ "$([ "_${header_8156}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__1040_v0 "${header_8156}" "${term_width_8158}"
        local ret_cutoff_text1040_v0__107_17="${ret_cutoff_text1040_v0}"
        local array_179=("")
        eprintf__1020_v0 "${ret_cutoff_text1040_v0__107_17}""
" array_179[@]
    fi
    local __length_180=("${options_8154[@]}")
    math_floor__505_v0 "$(( $(( $(( ${#__length_180[@]} + page_size_8157 )) - 1 )) / page_size_8157 ))"
    local total_pages_8161="${ret_math_floor505_v0}"
    local current_page_8162=0
    local selected_8163=0
    local display_count_8164="${page_size_8157}"
    local __length_181=("${options_8154[@]}")
    if [ "$(( ${#__length_181[@]} < page_size_8157 ))" != 0 ]; then
        local __length_182=("${options_8154[@]}")
        display_count_8164="${#__length_182[@]}"
    fi
    new_line__1027_v0 "${display_count_8164}"
    local array_183=("")
    eprintf__1020_v0 "\\x1b[G" array_183[@]
    if [ "$(( total_pages_8161 > 1 ))" != 0 ]; then
        eprintf_colored__1021_v0 "Page $(( current_page_8162 + 1 ))/${total_pages_8161}" 90
    fi
    new_line__1027_v0 1
    # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
    # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    if [ "$(( total_pages_8161 > 1 ))" != 0 ]; then
        local array_184=("↑↓" "select" "←→" "page" "enter" "confirm")
        render_tooltip__1041_v0 array_184[@] 36 "${term_width_8158}"
    else
        local array_185=("↑↓" "select" "enter" "confirm")
        render_tooltip__1041_v0 array_185[@] 25 "${term_width_8158}"
    fi
    go_up__1028_v0 "$(( display_count_8164 + 1 ))"
    local array_186=("")
    eprintf__1020_v0 "\\x1b[G" array_186[@]
    get_page_options__1091_v0 options_8154[@] "${current_page_8162}" "${page_size_8157}"
    local page_options_8165=("${ret_get_page_options1091_v0[@]}")
    render_choose_page__1093_v0 page_options_8165[@] "${selected_8163}" "${cursor_8155}" "${display_count_8164}" "${term_width_8158}"
    while :
    do
        get_key__1018_v0 
        local key_8177="${ret_get_key1018_v0}"
        local prev_selected_8178="${selected_8163}"
        local prev_page_8179="${current_page_8162}"
        local up_paged_8180=0
        if [ "$(( $([ "_${key_8177}" != "_UP" ]; echo $?) || $([ "_${key_8177}" != "_k" ]; echo $?) ))" != 0 ]; then
            if [ "$(( $(( selected_8163 == 0 )) && $(( total_pages_8161 > 1 )) ))" != 0 ]; then
                if [ "$(( current_page_8162 > 0 ))" != 0 ]; then
                    current_page_8162="$(( current_page_8162 - 1 ))"
                else
                    current_page_8162="$(( total_pages_8161 - 1 ))"
                fi
                up_paged_8180=1
            elif [ "$(( selected_8163 == 0 ))" != 0 ]; then
                local __length_187=("${page_options_8165[@]}")
                selected_8163="$(( ${#__length_187[@]} - 1 ))"
            else
                selected_8163="$(( selected_8163 - 1 ))"
            fi
        elif [ "$(( $([ "_${key_8177}" != "_DOWN" ]; echo $?) || $([ "_${key_8177}" != "_j" ]; echo $?) ))" != 0 ]; then
            local __length_188=("${page_options_8165[@]}")
            if [ "$(( selected_8163 == $(( ${#__length_188[@]} - 1 )) ))" != 0 ]; then
                if [ "$(( current_page_8162 < $(( total_pages_8161 - 1 )) ))" != 0 ]; then
                    current_page_8162="$(( current_page_8162 + 1 ))"
                    selected_8163=0
                else
                    current_page_8162=0
                    selected_8163=0
                fi
            else
                selected_8163="$(( selected_8163 + 1 ))"
            fi
        elif [ "$(( $([ "_${key_8177}" != "_LEFT" ]; echo $?) || $([ "_${key_8177}" != "_h" ]; echo $?) ))" != 0 ]; then
            if [ "$(( current_page_8162 > 0 ))" != 0 ]; then
                current_page_8162="$(( current_page_8162 - 1 ))"
                selected_8163=0
            else
                selected_8163=0
            fi
        elif [ "$(( $([ "_${key_8177}" != "_RIGHT" ]; echo $?) || $([ "_${key_8177}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "$(( current_page_8162 < $(( total_pages_8161 - 1 )) ))" != 0 ]; then
                current_page_8162="$(( current_page_8162 + 1 ))"
                selected_8163=0
            else
                local __length_189=("${page_options_8165[@]}")
                selected_8163="$(( ${#__length_189[@]} - 1 ))"
            fi
        elif [ "$([ "_${key_8177}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
        local __length_190="${cursor_8155}"
        local max_option_width_8181="$(( $(( term_width_8158 - ${#__length_190} )) - 1 ))"
        if [ "$(( prev_page_8179 != current_page_8162 ))" != 0 ]; then
            get_page_options__1091_v0 options_8154[@] "${current_page_8162}" "${page_size_8157}"
            page_options_8165=("${ret_get_page_options1091_v0[@]}")
            if [ "${up_paged_8180}" != 0 ]; then
                local __length_191=("${page_options_8165[@]}")
                selected_8163="$(( ${#__length_191[@]} - 1 ))"
            fi
            go_up__1028_v0 1
            remove_line__1024_v0 "$(( display_count_8164 - 1 ))"
            remove_current_line__1025_v0 
            local array_192=("")
            eprintf__1020_v0 "\\x1b[G" array_192[@]
            render_choose_page__1093_v0 page_options_8165[@] "${selected_8163}" "${cursor_8155}" "${display_count_8164}" "${term_width_8158}"
            render_page_indicator__1095_v0 "${current_page_8162}" "${total_pages_8161}"
        elif [ "$(( prev_selected_8178 != selected_8163 ))" != 0 ]; then
            go_up__1028_v0 "$(( display_count_8164 - prev_selected_8178 ))"
            local array_193=("")
            eprintf__1020_v0 "\\x1b[K" array_193[@]
            local __length_194="${cursor_8155}"
            print_blank__1026_v0 "${#__length_194}"
            cutoff_text__1040_v0 "${page_options_8165[${prev_selected_8178}]?"Index out of bounds (at src/./choose/./mod.ab:218:50)"}" "${max_option_width_8181}"
            local ret_cutoff_text1040_v0__218_25="${ret_cutoff_text1040_v0}"
            local array_195=("")
            eprintf__1020_v0 "${ret_cutoff_text1040_v0__218_25}" array_195[@]
            local diff_8182="$(( selected_8163 - prev_selected_8178 ))"
            go_up_or_down__1030_v0 "${diff_8182}"
            local array_196=("")
            eprintf__1020_v0 "\\x1b[G" array_196[@]
            local array_197=("")
            eprintf__1020_v0 "\\x1b[K" array_197[@]
            cutoff_text__1040_v0 "${page_options_8165[${selected_8163}]?"Index out of bounds (at src/./choose/./mod.ab:224:77)"}" "${max_option_width_8181}"
            local ret_cutoff_text1040_v0__224_52="${ret_cutoff_text1040_v0}"
            colored_secondary__1003_v0 "${cursor_8155}""${ret_cutoff_text1040_v0__224_52}"
            local ret_colored_secondary1003_v0__224_25="${ret_colored_secondary1003_v0}"
            local array_198=("")
            eprintf__1020_v0 "${ret_colored_secondary1003_v0__224_25}" array_198[@]
            go_down__1029_v0 "$(( display_count_8164 - selected_8163 ))"
            local array_199=("")
            eprintf__1020_v0 "\\x1b[G" array_199[@]
        fi
    done
    local total_lines_8183="$(( display_count_8164 + 2 ))"
    if [ "$([ "_${header_8156}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_8183="$(( total_lines_8183 + 1 ))"
    fi
    go_down__1029_v0 1
    remove_line__1024_v0 "$(( total_lines_8183 - 1 ))"
    remove_current_line__1025_v0 
    stty_unlock__980_v0 
    show_cursor__1032_v0 
    local global_selected_8184="$(( $(( current_page_8162 * page_size_8157 )) + selected_8163 ))"
    ret_xyl_choose1096_v0="${options_8154[${global_selected_8184}]?"Index out of bounds (at src/./choose/./mod.ab:244:20)"}"
    return 0
}

# count_checked(checked: [Bool])
count_checked__1097_v0() {
    local checked_8127=("${!1}")
    local count_8128=0
    for c_8129 in "${checked_8127[@]}"; do
        if [ "${c_8129}" != 0 ]; then
            count_8128="$(( count_8128 + 1 ))"
        fi
    done
    ret_count_checked1097_v0="${count_8128}"
    return 0
}

# xyl_multi_choose(options: [Text], cursor: Text, header: Text, limit: Int, page_size: Int)
xyl_multi_choose__1098_v0() {
    local options_8015=("${!1}")
    local cursor_8016="${2}"
    local header_8017="${3}"
    local limit_8018="${4}"
    local page_size_8019="${5}"
    local __length_202=("${options_8015[@]}")
    if [ "$(( ${#__length_202[@]} == 0 ))" != 0 ]; then
        eprintf_colored__1021_v0 "ERROR: No options provided.
" 31
        ret_xyl_multi_choose1098_v0=()
        return 0
    fi
    stty_lock__979_v0 
    hide_cursor__1031_v0 
    term_width__986_v0 
    local term_width_8032="${ret_term_width986_v0}"
    term_height__987_v0 
    local term_height_8033="${ret_term_height987_v0}"
    local max_page_size_8034
    max_page_size_8034="$(( term_height_8033 - $(if [ "$([ "_${header_8017}" != "_" ]; echo $?)" != 0 ]; then echo 2; else echo 3; fi) ))"
    if [ "$(( page_size_8019 > max_page_size_8034 ))" != 0 ]; then
        page_size_8019="${max_page_size_8034}"
    fi
    if [ "$([ "_${header_8017}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__1040_v0 "${header_8017}" "${term_width_8032}"
        local ret_cutoff_text1040_v0__288_17="${ret_cutoff_text1040_v0}"
        local array_204=("")
        eprintf__1020_v0 "${ret_cutoff_text1040_v0__288_17}""
" array_204[@]
    fi
    local __length_205=("${options_8015[@]}")
    math_floor__505_v0 "$(( $(( $(( ${#__length_205[@]} + page_size_8019 )) - 1 )) / page_size_8019 ))"
    local total_pages_8069="${ret_math_floor505_v0}"
    local current_page_8070=0
    local selected_8071=0
    local display_count_8072="${page_size_8019}"
    local __length_206=("${options_8015[@]}")
    if [ "$(( ${#__length_206[@]} < page_size_8019 ))" != 0 ]; then
        local __length_207=("${options_8015[@]}")
        display_count_8072="${#__length_207[@]}"
    fi
    new_line__1027_v0 "${display_count_8072}"
    local array_208=("")
    eprintf__1020_v0 "\\x1b[G" array_208[@]
    if [ "$(( total_pages_8069 > 1 ))" != 0 ]; then
        eprintf_colored__1021_v0 "Page $(( current_page_8070 + 1 ))/${total_pages_8069}" 90
    fi
    new_line__1027_v0 1
    # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
    # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
    # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
    if [ "$(( $(( total_pages_8069 > 1 )) && $(( limit_8018 < 0 )) ))" != 0 ]; then
        local array_209=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
        render_tooltip__1041_v0 array_209[@] 55 "${term_width_8032}"
    elif [ "$(( total_pages_8069 > 1 ))" != 0 ]; then
        local array_210=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
        render_tooltip__1041_v0 array_210[@] 47 "${term_width_8032}"
    elif [ "$(( limit_8018 < 0 ))" != 0 ]; then
        local array_211=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
        render_tooltip__1041_v0 array_211[@] 44 "${term_width_8032}"
    else
        local array_212=("↑↓" "select" "x" "toggle" "enter" "confirm")
        render_tooltip__1041_v0 array_212[@] 36 "${term_width_8032}"
    fi
    go_up__1028_v0 "$(( display_count_8072 + 1 ))"
    local array_213=("")
    eprintf__1020_v0 "\\x1b[G" array_213[@]
    local checked_8091=()
    local __range_start_8092=0
    local __length_215=("${options_8015[@]}")
    local __range_end_8092="${#__length_215[@]}"
    local __dir_8092=$(( ${__range_start_8092} <= ${__range_end_8092} ? 1 : -1 ))
    for (( ____8092=${__range_start_8092}; ____8092 * ${__dir_8092} < ${__range_end_8092} * ${__dir_8092}; ____8092+=${__dir_8092} )); do
        local array_216=(0)
        checked_8091+=("${array_216[@]}")
done
    get_page_options__1091_v0 options_8015[@] "${current_page_8070}" "${page_size_8019}"
    local page_options_8100=("${ret_get_page_options1091_v0[@]}")
    get_page_start__1092_v0 "${current_page_8070}" "${page_size_8019}"
    local page_start_8103="${ret_get_page_start1092_v0}"
    render_multi_choose_page__1094_v0 page_options_8100[@] checked_8091[@] "${page_start_8103}" "${selected_8071}" "${cursor_8016}" "${display_count_8072}" "${term_width_8032}"
    while :
    do
        get_key__1018_v0 
        local key_8122="${ret_get_key1018_v0}"
        local prev_selected_8123="${selected_8071}"
        local prev_page_8124="${current_page_8070}"
        local global_selected_8125="$(( page_start_8103 + selected_8071 ))"
        local up_paged_8126=0
        if [ "$(( $([ "_${key_8122}" != "_UP" ]; echo $?) || $([ "_${key_8122}" != "_k" ]; echo $?) ))" != 0 ]; then
            if [ "$(( $(( selected_8071 == 0 )) && $(( total_pages_8069 > 1 )) ))" != 0 ]; then
                if [ "$(( current_page_8070 > 0 ))" != 0 ]; then
                    current_page_8070="$(( current_page_8070 - 1 ))"
                else
                    current_page_8070="$(( total_pages_8069 - 1 ))"
                fi
                up_paged_8126=1
            elif [ "$(( selected_8071 == 0 ))" != 0 ]; then
                local __length_217=("${page_options_8100[@]}")
                selected_8071="$(( ${#__length_217[@]} - 1 ))"
            else
                selected_8071="$(( selected_8071 - 1 ))"
            fi
        elif [ "$(( $([ "_${key_8122}" != "_DOWN" ]; echo $?) || $([ "_${key_8122}" != "_j" ]; echo $?) ))" != 0 ]; then
            local __length_218=("${page_options_8100[@]}")
            if [ "$(( selected_8071 == $(( ${#__length_218[@]} - 1 )) ))" != 0 ]; then
                if [ "$(( current_page_8070 < $(( total_pages_8069 - 1 )) ))" != 0 ]; then
                    current_page_8070="$(( current_page_8070 + 1 ))"
                    selected_8071=0
                else
                    current_page_8070=0
                    selected_8071=0
                fi
            else
                selected_8071="$(( selected_8071 + 1 ))"
            fi
        elif [ "$(( $([ "_${key_8122}" != "_LEFT" ]; echo $?) || $([ "_${key_8122}" != "_h" ]; echo $?) ))" != 0 ]; then
            if [ "$(( current_page_8070 > 0 ))" != 0 ]; then
                current_page_8070="$(( current_page_8070 - 1 ))"
                selected_8071=0
            else
                selected_8071=0
            fi
        elif [ "$(( $([ "_${key_8122}" != "_RIGHT" ]; echo $?) || $([ "_${key_8122}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "$(( current_page_8070 < $(( total_pages_8069 - 1 )) ))" != 0 ]; then
                current_page_8070="$(( current_page_8070 + 1 ))"
                selected_8071=0
            else
                local __length_219=("${page_options_8100[@]}")
                selected_8071="$(( ${#__length_219[@]} - 1 ))"
            fi
        elif [ "$(( $([ "_${key_8122}" != "_x" ]; echo $?) || $([ "_${key_8122}" != "_X" ]; echo $?) ))" != 0 ]; then
            count_checked__1097_v0 checked_8091[@]
            local ret_count_checked1097_v0__390_34="${ret_count_checked1097_v0}"
            if [ "${checked_8091[${global_selected_8125}]?"Index out of bounds (at src/./choose/./mod.ab:387:29)"}" != 0 ]; then
                checked_8091["${global_selected_8125}"]=0
            elif [ "$(( $(( limit_8018 < 0 )) || $(( ret_count_checked1097_v0__390_34 < limit_8018 )) ))" != 0 ]; then
                checked_8091["${global_selected_8125}"]=1
            else
                continue
            fi
            local __length_220="${cursor_8016}"
            local max_option_width_8130="$(( $(( $(( term_width_8032 - ${#__length_220} )) - 2 )) - 1 ))"
            # 2 for check mark
            go_up__1028_v0 "$(( display_count_8072 - selected_8071 ))"
            local array_221=("")
            eprintf__1020_v0 "\\x1b[G" array_221[@]
            local array_222=("")
            eprintf__1020_v0 "\\x1b[K" array_222[@]
            local check_mark_8131
            check_mark_8131="$(if [ "${checked_8091[${global_selected_8125}]?"Index out of bounds (at src/./choose/./mod.ab:399:44)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
            cutoff_text__1040_v0 "${page_options_8100[${selected_8071}]?"Index out of bounds (at src/./choose/./mod.ab:400:90)"}" "${max_option_width_8130}"
            local ret_cutoff_text1040_v0__400_65="${ret_cutoff_text1040_v0}"
            colored_secondary__1003_v0 "${cursor_8016}""${check_mark_8131}""${ret_cutoff_text1040_v0__400_65}"
            local ret_colored_secondary1003_v0__400_25="${ret_colored_secondary1003_v0}"
            local array_223=("")
            eprintf__1020_v0 "${ret_colored_secondary1003_v0__400_25}" array_223[@]
            go_down__1029_v0 "$(( display_count_8072 - selected_8071 ))"
            local array_224=("")
            eprintf__1020_v0 "\\x1b[G" array_224[@]
            continue
        elif [ "$(( $(( $([ "_${key_8122}" != "_a" ]; echo $?) || $([ "_${key_8122}" != "_A" ]; echo $?) )) && $(( limit_8018 < 0 )) ))" != 0 ]; then
            count_checked__1097_v0 checked_8091[@]
            local ret_count_checked1097_v0__406_37="${ret_count_checked1097_v0}"
            local __length_225=("${options_8015[@]}")
            local all_checked_8133="$(( ret_count_checked1097_v0__406_37 == ${#__length_225[@]} ))"
            local __range_start_8134=0
            local __length_226=("${checked_8091[@]}")
            local __range_end_8134="${#__length_226[@]}"
            local __dir_8134=$(( ${__range_start_8134} <= ${__range_end_8134} ? 1 : -1 ))
            for (( i_8134=${__range_start_8134}; i_8134 * ${__dir_8134} < ${__range_end_8134} * ${__dir_8134}; i_8134+=${__dir_8134} )); do
                checked_8091["${i_8134}"]="$(( ! all_checked_8133 ))"
done
            go_up__1028_v0 "${display_count_8072}"
            local array_227=("")
            eprintf__1020_v0 "\\x1b[G" array_227[@]
            render_multi_choose_page__1094_v0 page_options_8100[@] checked_8091[@] "${page_start_8103}" "${selected_8071}" "${cursor_8016}" "${display_count_8072}" "${term_width_8032}"
            continue
        elif [ "$([ "_${key_8122}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
        local __length_228="${cursor_8016}"
        local max_option_width_8135="$(( $(( $(( term_width_8032 - ${#__length_228} )) - 2 )) - 1 ))"
        # 2 for check mark
        if [ "$(( prev_page_8124 != current_page_8070 ))" != 0 ]; then
            get_page_options__1091_v0 options_8015[@] "${current_page_8070}" "${page_size_8019}"
            page_options_8100=("${ret_get_page_options1091_v0[@]}")
            get_page_start__1092_v0 "${current_page_8070}" "${page_size_8019}"
            page_start_8103="${ret_get_page_start1092_v0}"
            if [ "${up_paged_8126}" != 0 ]; then
                local __length_229=("${page_options_8100[@]}")
                selected_8071="$(( ${#__length_229[@]} - 1 ))"
            fi
            go_up__1028_v0 1
            remove_line__1024_v0 "$(( display_count_8072 - 1 ))"
            remove_current_line__1025_v0 
            local array_230=("")
            eprintf__1020_v0 "\\x1b[G" array_230[@]
            render_multi_choose_page__1094_v0 page_options_8100[@] checked_8091[@] "${page_start_8103}" "${selected_8071}" "${cursor_8016}" "${display_count_8072}" "${term_width_8032}"
            render_page_indicator__1095_v0 "${current_page_8070}" "${total_pages_8069}"
        elif [ "$(( prev_selected_8123 != selected_8071 ))" != 0 ]; then
            local prev_global_8141="$(( page_start_8103 + prev_selected_8123 ))"
            go_up__1028_v0 "$(( display_count_8072 - prev_selected_8123 ))"
            local array_231=("")
            eprintf__1020_v0 "\\x1b[K" array_231[@]
            local __length_232="${cursor_8016}"
            print_blank__1026_v0 "${#__length_232}"
            if [ "${checked_8091[${prev_global_8141}]?"Index out of bounds (at src/./choose/./mod.ab:441:28)"}" != 0 ]; then
                cutoff_text__1040_v0 "${page_options_8100[${prev_selected_8123}]?"Index out of bounds (at src/./choose/./mod.ab:442:79)"}" "${max_option_width_8135}"
                local ret_cutoff_text1040_v0__442_54="${ret_cutoff_text1040_v0}"
                colored_secondary__1003_v0 "✓ ""${ret_cutoff_text1040_v0__442_54}"
                local ret_colored_secondary1003_v0__442_29="${ret_colored_secondary1003_v0}"
                local array_233=("")
                eprintf__1020_v0 "${ret_colored_secondary1003_v0__442_29}" array_233[@]
            else
                cutoff_text__1040_v0 "${page_options_8100[${prev_selected_8123}]?"Index out of bounds (at src/./choose/./mod.ab:444:61)"}" "${max_option_width_8135}"
                local ret_cutoff_text1040_v0__444_36="${ret_cutoff_text1040_v0}"
                local array_234=("")
                eprintf__1020_v0 "• ""${ret_cutoff_text1040_v0__444_36}" array_234[@]
            fi
            local diff_8142="$(( selected_8071 - prev_selected_8123 ))"
            go_up_or_down__1030_v0 "${diff_8142}"
            local array_235=("")
            eprintf__1020_v0 "\\x1b[G" array_235[@]
            local array_236=("")
            eprintf__1020_v0 "\\x1b[K" array_236[@]
            local new_global_8144="$(( page_start_8103 + selected_8071 ))"
            local check_mark_8145
            check_mark_8145="$(if [ "${checked_8091[${new_global_8144}]?"Index out of bounds (at src/./choose/./mod.ab:452:44)"}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
            cutoff_text__1040_v0 "${page_options_8100[${selected_8071}]?"Index out of bounds (at src/./choose/./mod.ab:453:90)"}" "${max_option_width_8135}"
            local ret_cutoff_text1040_v0__453_65="${ret_cutoff_text1040_v0}"
            colored_secondary__1003_v0 "${cursor_8016}""${check_mark_8145}""${ret_cutoff_text1040_v0__453_65}"
            local ret_colored_secondary1003_v0__453_25="${ret_colored_secondary1003_v0}"
            local array_237=("")
            eprintf__1020_v0 "${ret_colored_secondary1003_v0__453_25}" array_237[@]
            go_down__1029_v0 "$(( display_count_8072 - selected_8071 ))"
            local array_238=("")
            eprintf__1020_v0 "\\x1b[G" array_238[@]
        fi
    done
    local total_lines_8146="$(( display_count_8072 + 2 ))"
    if [ "$([ "_${header_8017}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_8146="$(( total_lines_8146 + 1 ))"
    fi
    go_down__1029_v0 1
    remove_line__1024_v0 "$(( total_lines_8146 - 1 ))"
    remove_current_line__1025_v0 
    local result_8147=()
    local __range_start_8148=0
    local __length_240=("${options_8015[@]}")
    local __range_end_8148="${#__length_240[@]}"
    local __dir_8148=$(( ${__range_start_8148} <= ${__range_end_8148} ? 1 : -1 ))
    for (( i_8148=${__range_start_8148}; i_8148 * ${__dir_8148} < ${__range_end_8148} * ${__dir_8148}; i_8148+=${__dir_8148} )); do
        if [ "${checked_8091[${i_8148}]?"Index out of bounds (at src/./choose/./mod.ab:472:20)"}" != 0 ]; then
            local array_241=("${options_8015[${i_8148}]?"Index out of bounds (at src/./choose/./mod.ab:473:32)"}")
            result_8147+=("${array_241[@]}")
        fi
done
    stty_unlock__980_v0 
    show_cursor__1032_v0 
    ret_xyl_multi_choose1098_v0=("${result_8147[@]}")
    return 0
}

# print_choose_help()
print_choose_help__1192_v0() {
    echo "Usage: ./xylitol.sh choose [<options> ...] [flags]"
    printf '%s\n' ""
    colored_primary__1002_v0 "choose"
    local ret_colored_primary1002_v0__7_12="${ret_colored_primary1002_v0}"
    local array_242=()
    printf__128_v1 "${ret_colored_primary1002_v0__7_12}" array_242[@]
    local array_243=()
    printf__128_v1 " - Choose from a list of options." array_243[@]
    printf '%s\n' ""
    printf '%s\n' ""
    colored_secondary__1003_v0 "Arguments: "
    local ret_colored_secondary1003_v0__11_12="${ret_colored_secondary1003_v0}"
    local array_244=()
    printf__128_v1 "${ret_colored_secondary1003_v0__11_12}""
" array_244[@]
    echo "  [<options> ...]        List of options to choose from"
    printf '%s\n' ""
    colored_secondary__1003_v0 "Flags: "
    local ret_colored_secondary1003_v0__14_12="${ret_colored_secondary1003_v0}"
    local array_245=()
    printf__128_v1 "${ret_colored_secondary1003_v0__14_12}""
" array_245[@]
    echo "  -h, --help             Show this help message"
    echo "  --limit=<number>       Enable multi-selection mode with a limit of selections"
    echo "  --no-limit             Enable multi-selection mode with no limit"
    echo "  --cursor=\"<text>\"      Set the cursor text (default: '> ')"
    echo "  --header=\"<text>\"      Set a header text to display above the options (ANSI escape supported)"
    echo "  --page-size=<number>   Set the number of options per page (default: 10)"
    printf '%s\n' ""
}

# read_stdin_options()
read_stdin_options__1243_v0() {
    local options_7995=()
    local command_247
    command_247="$([ -t 0 ] && echo "true" || echo "false")"
    __status=$?
    local is_tty_7996="${command_247}"
    if [ "$([ "_${is_tty_7996}" != "_false" ]; echo $?)" != 0 ]; then
        while IFS= read -r line || [[ -n "$line" ]]; do options_7995+=("$line"); done
        __status=$?
    fi
    ret_read_stdin_options1243_v0=("${options_7995[@]}")
    return 0
}

# execute_choose(parameters: [Text])
execute_choose__1244_v0() {
    local parameters_7978=("${!1}")
    local cursor_7979="> "
    colored_primary__1002_v0 "Choose: "
    local ret_colored_primary1002_v0__17_30="${ret_colored_primary1002_v0}"
    local header_7994="\\x1b[1m""${ret_colored_primary1002_v0__17_30}"
    read_stdin_options__1243_v0 
    local options_7997=("${ret_read_stdin_options1243_v0[@]}")
    local multi_7998=0
    local limit_7999=-1
    local page_size_8000=10
    local __length_251=("${parameters_7978[@]}")
    local slice_upper_250="${#__length_251[@]}"
    local slice_offset_252=2
    local slice_offset_252=$((${slice_offset_252} > 0 ? ${slice_offset_252} : 0))
    local slice_length_253="$(( slice_upper_250 - slice_offset_252 ))"
    local slice_length_253=$((${slice_length_253} > 0 ? ${slice_length_253} : 0))
    for param_8001 in "${parameters_7978[@]:${slice_offset_252}:${slice_length_253}}"; do
        match_regex__19_v0 "${param_8001}" "^-h\$" 0
        local ret_match_regex19_v0__25_13="${ret_match_regex19_v0}"
        match_regex__19_v0 "${param_8001}" "^--help\$" 0
        local ret_match_regex19_v0__25_43="${ret_match_regex19_v0}"
        match_regex__19_v0 "${param_8001}" "^--cursor=.*\$" 0
        local ret_match_regex19_v0__29_13="${ret_match_regex19_v0}"
        match_regex__19_v0 "${param_8001}" "^--header=.*\$" 0
        local ret_match_regex19_v0__33_13="${ret_match_regex19_v0}"
        match_regex__19_v0 "${param_8001}" "^--limit=.*\$" 0
        local ret_match_regex19_v0__37_13="${ret_match_regex19_v0}"
        match_regex__19_v0 "${param_8001}" "^--no-limit\$" 0
        local ret_match_regex19_v0__45_13="${ret_match_regex19_v0}"
        match_regex__19_v0 "${param_8001}" "^--page-size=.*\$" 0
        local ret_match_regex19_v0__48_13="${ret_match_regex19_v0}"
        if [ "$(( ret_match_regex19_v0__25_13 || ret_match_regex19_v0__25_43 ))" != 0 ]; then
            print_choose_help__1192_v0 
            exit 0
        elif [ "${ret_match_regex19_v0__29_13}" != 0 ]; then
            split__4_v0 "${param_8001}" "="
            local result_8003=("${ret_split4_v0[@]}")
            cursor_7979="${result_8003[1]?"Index out of bounds (at src/./choose/exec.ab:31:33)"}"
        elif [ "${ret_match_regex19_v0__33_13}" != 0 ]; then
            split__4_v0 "${param_8001}" "="
            local result_8004=("${ret_split4_v0[@]}")
            header_7994="${result_8004[1]?"Index out of bounds (at src/./choose/exec.ab:35:33)"}"
        elif [ "${ret_match_regex19_v0__37_13}" != 0 ]; then
            split__4_v0 "${param_8001}" "="
            local result_8005=("${ret_split4_v0[@]}")
            parse_int__13_v0 "${result_8005[1]?"Index out of bounds (at src/./choose/exec.ab:39:42)"}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1021_v0 "ERROR: Invalid limit value: ""${result_8005[1]?"Index out of bounds (at src/./choose/exec.ab:40:77)"}""
" 31
                exit 1
            fi
            limit_7999="${ret_parse_int13_v0}"
            multi_7998=1
        elif [ "${ret_match_regex19_v0__45_13}" != 0 ]; then
            multi_7998=1
        elif [ "${ret_match_regex19_v0__48_13}" != 0 ]; then
            split__4_v0 "${param_8001}" "="
            local result_8010=("${ret_split4_v0[@]}")
            parse_int__13_v0 "${result_8010[1]?"Index out of bounds (at src/./choose/exec.ab:50:46)"}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1021_v0 "ERROR: Invalid page-size value: ""${result_8010[1]?"Index out of bounds (at src/./choose/exec.ab:51:81)"}""
" 31
                exit 1
            fi
            page_size_8000="${ret_parse_int13_v0}"
        else
            options_7997+=("${param_8001}")
        fi
    done
    has_ansi_escape__1033_v0 "${header_7994}"
    local ret_has_ansi_escape1033_v0__61_44="${ret_has_ansi_escape1033_v0}"
    escape_ansi__1034_v0 "${header_7994}"
    local ret_escape_ansi1034_v0__61_73="${ret_escape_ansi1034_v0}"
    colored_primary__1002_v0 "${header_7994}"
    local ret_colored_primary1002_v0__61_111="${ret_colored_primary1002_v0}"
    local display_header_8014
    display_header_8014="$(if [ "$(( $([ "_${header_7994}" != "_" ]; echo $?) || ret_has_ansi_escape1033_v0__61_44 ))" != 0 ]; then echo "${ret_escape_ansi1034_v0__61_73}"; else echo "\\x1b[1m""${ret_colored_primary1002_v0__61_111}"; fi)"
    if [ "${multi_7998}" != 0 ]; then
        xyl_multi_choose__1098_v0 options_7997[@] "${cursor_7979}" "${display_header_8014}" "${limit_7999}" "${page_size_8000}"
        local results_8151=("${ret_xyl_multi_choose1098_v0[@]}")
        join__7_v0 results_8151[@] "
"
        ret_execute_choose1244_v0="${ret_join7_v0}"
        return 0
    fi
    xyl_choose__1096_v0 options_7997[@] "${cursor_7979}" "${display_header_8014}" "${page_size_8000}"
    ret_execute_choose1244_v0="${ret_xyl_choose1096_v0}"
    return 0
}

# Perl Extensions Utilities
command_255="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_30="$([ "_${command_255}" != "_No" ]; echo $?)"
command_256="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_31="$(( $(( ! _perl_disabled_30 )) && $([ "_${command_256}" != "_0" ]; echo $?) ))"
# perl_get_cjk_width(text: Text)
perl_get_cjk_width__1420_v0() {
    local text_9794="${1}"
    if [ "$(( ! _perl_available_31 ))" != 0 ]; then
        ret_perl_get_cjk_width1420_v0=''
        return 1
    fi
    local command_257
    command_257="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_9794}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1420_v0=''
        return "${__status}"
    fi
    local width_str_9795="${command_257}"
    parse_int__13_v0 "${width_str_9795}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1420_v0=''
        return "${__status}"
    fi
    local width_9796="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width1420_v0="${width_9796}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__1421_v0() {
    local text_9803="${1}"
    local max_width_9804="${2}"
    if [ "$(( ! _perl_available_31 ))" != 0 ]; then
        ret_perl_truncate_cjk1421_v0=''
        return 1
    fi
    local command_258
    command_258="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_9803}" ${max_width_9804} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1421_v0=''
        return "${__status}"
    fi
    local result_9805="${command_258}"
    ret_perl_truncate_cjk1421_v0="${result_9805}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_32=0
_term_size_33=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_lock()
stty_lock__1429_v0() {
    local command_260
    command_260="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_9774="${command_260}"
    parse_int__13_v0 "${count_9774}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_9775="${ret_parse_int13_v0}"
    if [ "$(( count_num_9775 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_9775="$(( count_num_9775 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_9775}
    __status=$?
}

# stty_unlock()
stty_unlock__1430_v0() {
    local command_261
    command_261="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_9876="${command_261}"
    parse_int__13_v0 "${count_9876}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_9877="${ret_parse_int13_v0}"
    if [ "$(( count_num_9877 > 0 ))" != 0 ]; then
        count_num_9877="$(( count_num_9877 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_9877}
        __status=$?
        if [ "$(( count_num_9877 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# parse_size(text: Text)
parse_size__1431_v0() {
    local text_9778="${1}"
    # `match_regex` uses BRE by default, where `+` is a literal character
    match_regex__19_v0 "${text_9778}" "^[0-9][0-9]*\$" 0
    local ret_match_regex19_v0__38_12="${ret_match_regex19_v0}"
    if [ "$(( ! ret_match_regex19_v0__38_12 ))" != 0 ]; then
        ret_parse_size1431_v0=0
        return 0
    fi
    parse_int__13_v0 "${text_9778}"
    __status=$?
    ret_parse_size1431_v0="${ret_parse_int13_v0}"
    return 0
}

# query_term_size()
query_term_size__1432_v0() {
    local command_262
    command_262="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; echo "$height; $width")"
    __status=$?
    local result_9776="${command_262}"
    split__4_v0 "${result_9776}" ";"
    local parts_9777=("${ret_split4_v0[@]}")
    local __length_263=("${parts_9777[@]}")
    if [ "$(( ${#__length_263[@]} != 2 ))" != 0 ]; then
        ret_query_term_size1432_v0=0
        return 0
    fi
    parse_size__1431_v0 "${parts_9777[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:53:35)"}"
    local rows_9779="${ret_parse_size1431_v0}"
    parse_size__1431_v0 "${parts_9777[1]?"Index out of bounds (at src/./confirm/../utils/term.ab:54:35)"}"
    local cols_9780="${ret_parse_size1431_v0}"
    if [ "$(( $(( rows_9779 <= 0 )) || $(( cols_9780 <= 0 )) ))" != 0 ]; then
        ret_query_term_size1432_v0=0
        return 0
    fi
    _term_size_33=("${cols_9780}" "${rows_9779}")
    ret_query_term_size1432_v0=1
    return 0
}

# stty_term_size()
stty_term_size__1433_v0() {
    local command_265
    command_265="$(stty size < /dev/tty 2>/dev/null)"
    __status=$?
    local result_9782="${command_265}"
    split__4_v0 "${result_9782}" " "
    local parts_9783=("${ret_split4_v0[@]}")
    local __length_266=("${parts_9783[@]}")
    if [ "$(( ${#__length_266[@]} != 2 ))" != 0 ]; then
        ret_stty_term_size1433_v0=0
        return 0
    fi
    parse_size__1431_v0 "${parts_9783[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:70:35)"}"
    local rows_9784="${ret_parse_size1431_v0}"
    parse_size__1431_v0 "${parts_9783[1]?"Index out of bounds (at src/./confirm/../utils/term.ab:71:35)"}"
    local cols_9785="${ret_parse_size1431_v0}"
    if [ "$(( $(( rows_9784 <= 0 )) || $(( cols_9785 <= 0 )) ))" != 0 ]; then
        ret_stty_term_size1433_v0=0
        return 0
    fi
    _term_size_33=("${cols_9785}" "${rows_9784}")
    ret_stty_term_size1433_v0=1
    return 0
}

# get_term_size()
get_term_size__1434_v0() {
    query_term_size__1432_v0 
    local detected_9781="${ret_query_term_size1432_v0}"
    if [ "$(( ! detected_9781 ))" != 0 ]; then
        stty_term_size__1433_v0 
        detected_9781="${ret_stty_term_size1433_v0}"
    fi
    _got_term_size_32=1
}

# term_width()
term_width__1436_v0() {
    if [ "$(( ! _got_term_size_32 ))" != 0 ]; then
        get_term_size__1434_v0 
    fi
    ret_term_width1436_v0="${_term_size_33[0]?"Index out of bounds (at src/./confirm/../utils/term.ab:101:23)"}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_34="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_35=0
_primary_color_36=(3 207 159 92)
_secondary_color_37=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__1447_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local config_9756="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_9756}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_34="No"
        ret_get_supports_truecolor1447_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_34="No"
        ret_get_supports_truecolor1447_v0=0
        return 0
    fi
    local colorterm_9757="${ret_env_var_get120_v0}"
    _supports_truecolor_34="$(if [ "$(( $([ "_${colorterm_9757}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_9757}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1447_v0="$([ "_${_supports_truecolor_34}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1448_v0() {
    local message_9751="${1}"
    local r_9752="${2}"
    local g_9753="${3}"
    local b_9754="${4}"
    local fallback_9755="${5}"
    if [ "$([ "_${_supports_truecolor_34}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1448_v0="\\x1b[38;2;${r_9752};${g_9753};${b_9754}m""${message_9751}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_34}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1447_v0 
        local ret_get_supports_truecolor1447_v0__50_17="${ret_get_supports_truecolor1447_v0}"
        if [ "${ret_get_supports_truecolor1447_v0__50_17}" != 0 ]; then
            ret_colored_rgb1448_v0="\\x1b[38;2;${r_9752};${g_9753};${b_9754}m""${message_9751}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_9755 == 0 ))" != 0 ]; then
            ret_colored_rgb1448_v0="${message_9751}"
            return 0
        else
            ret_colored_rgb1448_v0="\\x1b[${fallback_9755}m""${message_9751}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_9755 == 0 ))" != 0 ]; then
            ret_colored_rgb1448_v0="${message_9751}"
            return 0
        fi
        ret_colored_rgb1448_v0="\\x1b[${fallback_9755}m""${message_9751}""\\x1b[0m"
        return 0
    fi
}

# background_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
background_rgb__1449_v0() {
    local message_9847="${1}"
    local r_9848="${2}"
    local g_9849="${3}"
    local b_9850="${4}"
    local fallback_9851="${5}"
    # Convert foreground color code to background color code
    # 30-37 -> 40-47, 90-97 -> 100-107
    local bg_fallback_9852="${fallback_9851}"
    if [ "$(( $(( fallback_9851 >= 30 )) && $(( fallback_9851 <= 37 )) ))" != 0 ]; then
        bg_fallback_9852="$(( fallback_9851 + 10 ))"
    fi
    if [ "$(( $(( fallback_9851 >= 90 )) && $(( fallback_9851 <= 97 )) ))" != 0 ]; then
        bg_fallback_9852="$(( fallback_9851 + 10 ))"
    fi
    if [ "$([ "_${_supports_truecolor_34}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_background_rgb1449_v0="\\x1b[48;2;${r_9848};${g_9849};${b_9850}m""${message_9847}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_34}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1447_v0 
        local ret_get_supports_truecolor1447_v0__92_17="${ret_get_supports_truecolor1447_v0}"
        if [ "${ret_get_supports_truecolor1447_v0__92_17}" != 0 ]; then
            ret_background_rgb1449_v0="\\x1b[48;2;${r_9848};${g_9849};${b_9850}m""${message_9847}""\\x1b[0m"
            return 0
        elif [ "$(( bg_fallback_9852 == 0 ))" != 0 ]; then
            ret_background_rgb1449_v0="${message_9847}"
            return 0
        else
            ret_background_rgb1449_v0="\\x1b[${bg_fallback_9852}m""${message_9847}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( bg_fallback_9852 == 0 ))" != 0 ]; then
            ret_background_rgb1449_v0="${message_9847}"
            return 0
        fi
        ret_background_rgb1449_v0="\\x1b[${bg_fallback_9852}m""${message_9847}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1450_v0() {
    if [ "$(( ! _got_xylitol_colors_35 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local primary_env_9745="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_9745}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_9745}" ";"
            local parts_9746=("${ret_split4_v0[@]}")
            local __length_271=("${parts_9746[@]}")
            if [ "$(( ${#__length_271[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_9746[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1450_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_9746[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1450_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_9746[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1450_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_9746[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1450_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
                _primary_color_36=("${ret_parse_int13_v0__115_21}" "${ret_parse_int13_v0__116_21}" "${ret_parse_int13_v0__117_21}" "${ret_parse_int13_v0__118_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local secondary_env_9747="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_9747}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_9747}" ";"
            local parts_9748=("${ret_split4_v0[@]}")
            local __length_273=("${parts_9748[@]}")
            if [ "$(( ${#__length_273[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_9748[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1450_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_9748[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1450_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_9748[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1450_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_9748[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1450_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_37=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local accent_env_9749="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_9749}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_9749}" ";"
            local parts_9750=("${ret_split4_v0[@]}")
            local __length_275=("${parts_9750[@]}")
            if [ "$(( ${#__length_275[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_9750[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1450_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_9750[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1450_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_9750[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1450_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_9750[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1450_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_35=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__1451_v0() {
    inner_get_xylitol_colors__1450_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_35=1
}

# colored_primary(message: Text)
colored_primary__1452_v0() {
    local message_9744="${1}"
    if [ "$(( ! _got_xylitol_colors_35 ))" != 0 ]; then
        get_xylitol_colors__1451_v0 
    fi
    colored_rgb__1448_v0 "${message_9744}" "${_primary_color_36[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:164:48)"}" "${_primary_color_36[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:164:67)"}" "${_primary_color_36[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:164:86)"}" "${_primary_color_36[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:164:105)"}"
    ret_colored_primary1452_v0="${ret_colored_rgb1448_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1453_v0() {
    local message_9761="${1}"
    if [ "$(( ! _got_xylitol_colors_35 ))" != 0 ]; then
        get_xylitol_colors__1451_v0 
    fi
    colored_rgb__1448_v0 "${message_9761}" "${_secondary_color_37[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:171:50)"}" "${_secondary_color_37[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:171:71)"}" "${_secondary_color_37[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:171:92)"}" "${_secondary_color_37[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary1453_v0="${ret_colored_rgb1448_v0}"
    return 0
}

# background_secondary(message: Text)
background_secondary__1456_v0() {
    local message_9846="${1}"
    if [ "$(( ! _got_xylitol_colors_35 ))" != 0 ]; then
        get_xylitol_colors__1451_v0 
    fi
    background_rgb__1449_v0 "${message_9846}" "${_secondary_color_37[0]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:192:53)"}" "${_secondary_color_37[1]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:192:74)"}" "${_secondary_color_37[2]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:192:95)"}" "${_secondary_color_37[3]?"Index out of bounds (at src/./confirm/../utils/truecolor.ab:192:116)"}"
    ret_background_secondary1456_v0="${ret_background_rgb1449_v0}"
    return 0
}

# // IO Functions /////
# get_key()
get_key__1468_v0() {
    local command_277
    command_277="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_9869="${command_277}"
    if [ "$([ "_${var_9869}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1468_v0="UP"
        return 0
    elif [ "$([ "_${var_9869}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1468_v0="DOWN"
        return 0
    elif [ "$([ "_${var_9869}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1468_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_9869}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1468_v0="LEFT"
        return 0
    elif [ "$([ "_${var_9869}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1468_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_9869}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1468_v0="INPUT"
        return 0
    else
        ret_get_key1468_v0="${var_9869}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__1470_v0() {
    local format_9766="${1}"
    local args_9767=("${!2}")
    args_9767=("${format_9766}" "${args_9767[@]}")
    __status=$?
    printf "${args_9767[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1471_v0() {
    local message_9764="${1}"
    local color_9765="${2}"
    # Prints an error message with a specified color.
    local array_278=("${message_9764}")
    eprintf__1470_v0 "\\x1b[${color_9765}m%s\\x1b[0m" array_278[@]
}

# colored(message: Text, color: Int)
colored__1472_v0() {
    local message_9859="${1}"
    local color_9860="${2}"
    # Returns a text wrapped in color codes.
    ret_colored1472_v0="\\x1b[${color_9860}m""${message_9859}""\\x1b[0m"
    return 0
}

# remove_line(cnt: Int)
remove_line__1474_v0() {
    local cnt_9873="${1}"
    if [ "$(( cnt_9873 > 0 ))" != 0 ]; then
        local sequence_9874=""
        local __range_start_9875=0
        local __range_end_9875="${cnt_9873}"
        local __dir_9875=$(( ${__range_start_9875} <= ${__range_end_9875} ? 1 : -1 ))
        for (( ____9875=${__range_start_9875}; ____9875 * ${__dir_9875} < ${__range_end_9875} * ${__dir_9875}; ____9875+=${__dir_9875} )); do
            sequence_9874+="\\x1b[2K\\x1b[1A"
done
        local array_279=("")
        eprintf__1470_v0 "${sequence_9874}" array_279[@]
    fi
    local array_280=("")
    eprintf__1470_v0 "\\x1b[G" array_280[@]
}

# remove_current_line()
remove_current_line__1475_v0() {
    local array_281=("")
    eprintf__1470_v0 "\\x1b[2K\\x1b[G" array_281[@]
}

# go_up(cnt: Int)
go_up__1478_v0() {
    local cnt_9868="${1}"
    local array_282=("")
    eprintf__1470_v0 "\\x1b[${cnt_9868}A" array_282[@]
}

# go_down(cnt: Int)
go_down__1479_v0() {
    local cnt_9872="${1}"
    local array_283=("")
    eprintf__1470_v0 "\\x1b[${cnt_9872}B" array_283[@]
}

# move the cursor up or down `cnt` lines.
# hide_cursor()
hide_cursor__1481_v0() {
    local array_284=("")
    eprintf__1470_v0 "\\x1b[?25l" array_284[@]
}

# show_cursor()
show_cursor__1482_v0() {
    local array_285=("")
    eprintf__1470_v0 "\\x1b[?25h" array_285[@]
}

# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__1483_v0() {
    local text_9768="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_286
    command_286="$([[ "${text_9768}" == *$'\x1b'* || "${text_9768}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_9769="${command_286}"
    ret_has_ansi_escape1483_v0="$([ "_${has_escape_9769}" != "_1" ]; echo $?)"
    return 0
}

# escape_ansi(text: Text)
escape_ansi__1484_v0() {
    local text_9770="${1}"
    local command_287
    command_287="$(printf '%s' "${text_9770}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1484_v0="${command_287}"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__1485_v0() {
    local text_9790="${1}"
    local command_288
    command_288="$(printf "%s" "${text_9790}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1485_v0="${command_288}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__1486_v0() {
    local text_9792="${1}"
    local command_289
    command_289="$(printf "%s" "${text_9792}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_9793="${command_289}"
    ret_is_all_ascii1486_v0="$([ "_${result_9793}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__1487_v0() {
    local text_9789="${1}"
    strip_ansi__1485_v0 "${text_9789}"
    local stripped_9791="${ret_strip_ansi1485_v0}"
    # Check if text is all ASCII
    is_all_ascii__1486_v0 "${stripped_9791}"
    local ret_is_all_ascii1486_v0__150_12="${ret_is_all_ascii1486_v0}"
    if [ "$(( ! ret_is_all_ascii1486_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1420_v0 "${stripped_9791}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_290="${stripped_9791}"
            ret_get_visible_len1487_v0="${#__length_290}"
            return 0
        fi
        ret_get_visible_len1487_v0="${ret_perl_get_cjk_width1420_v0}"
        return 0
    else
        local __length_291="${stripped_9791}"
        ret_get_visible_len1487_v0="${#__length_291}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__1488_v0() {
    local text_9800="${1}"
    local max_width_9801="${2}"
    get_visible_len__1487_v0 "${text_9800}"
    local visible_len_9802="${ret_get_visible_len1487_v0}"
    if [ "$(( visible_len_9802 <= max_width_9801 ))" != 0 ]; then
        ret_truncate_text1488_v0="${text_9800}"
        return 0
    fi
    is_all_ascii__1486_v0 "${text_9800}"
    local ret_is_all_ascii1486_v0__167_12="${ret_is_all_ascii1486_v0}"
    if [ "$(( ! ret_is_all_ascii1486_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__1421_v0 "${text_9800}" "${max_width_9801}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_9800}" | cut -c1-${max_width_9801}
            __status=$?
        fi
        ret_truncate_text1488_v0="${ret_perl_truncate_cjk1421_v0}"
        return 0
    fi
    local command_292
    command_292="$(printf "%s" "${text_9800}" | cut -c1-${max_width_9801})"
    __status=$?
    ret_truncate_text1488_v0="${command_292}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__1489_v0() {
    local text_9798="${1}"
    local max_width_9799="${2}"
    has_ansi_escape__1483_v0 "${text_9798}"
    local ret_has_ansi_escape1483_v0__179_12="${ret_has_ansi_escape1483_v0}"
    if [ "$(( ! ret_has_ansi_escape1483_v0__179_12 ))" != 0 ]; then
        truncate_text__1488_v0 "${text_9798}" "${max_width_9799}"
        ret_truncate_ansi1489_v0="${ret_truncate_text1488_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_293
    command_293="$([[ "${text_9798}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_9806="${command_293}"
    # Replace \x1b[ with newline, then split
    local command_294
    command_294="$(t="${text_9798}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_9807="${command_294}"
    split__4_v0 "${replaced_9807}" "
"
    local parts_9808=("${ret_split4_v0[@]}")
    local result_9809=""
    local remaining_width_9810="${max_width_9799}"
    local __range_start_9811=0
    local __length_295=("${parts_9808[@]}")
    local __range_end_9811="${#__length_295[@]}"
    local __dir_9811=$(( ${__range_start_9811} <= ${__range_end_9811} ? 1 : -1 ))
    for (( idx_9811=${__range_start_9811}; idx_9811 * ${__dir_9811} < ${__range_end_9811} * ${__dir_9811}; idx_9811+=${__dir_9811} )); do
        local part_9812="${parts_9808[${idx_9811}]?"Index out of bounds (at src/./confirm/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_9811 == 0 )) && $([ "_${starts_with_ansi_9806}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_9812}" == "_" ]; echo $?) && $(( remaining_width_9810 > 0 )) ))" != 0 ]; then
                truncate_text__1488_v0 "${part_9812}" "${remaining_width_9810}"
                local ret_truncate_text1488_v0__201_35="${ret_truncate_text1488_v0}"
                local truncated_9813="${ret_truncate_text1488_v0__201_35}"
                result_9809+="${truncated_9813}"
                get_visible_len__1487_v0 "${truncated_9813}"
                local ret_get_visible_len1487_v0__203_36="${ret_get_visible_len1487_v0}"
                remaining_width_9810="$(( remaining_width_9810 - ret_get_visible_len1487_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_296
            command_296="$(__p="${part_9812}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_9814="${command_296}"
            if [ "$([ "_${m_idx_9814}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_297
                command_297="$(__p="${part_9812}"; printf "%s" "${__p:0:${m_idx_9814}}")"
                __status=$?
                local ansi_params_9815="${command_297}"
                result_9809+="\\x1b[""${ansi_params_9815}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_9814}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_9816="${ret_parse_int13_v0__214_41}"
                local text_start_9817="$(( m_idx_num_9816 + 1 ))"
                local command_298
                command_298="$(__p="${part_9812}"; printf "%s" "${__p:${text_start_9817}}")"
                __status=$?
                local text_part_9818="${command_298}"
                if [ "$(( $([ "_${text_part_9818}" == "_" ]; echo $?) && $(( remaining_width_9810 > 0 )) ))" != 0 ]; then
                    truncate_text__1488_v0 "${text_part_9818}" "${remaining_width_9810}"
                    local ret_truncate_text1488_v0__218_39="${ret_truncate_text1488_v0}"
                    local truncated_9819="${ret_truncate_text1488_v0__218_39}"
                    result_9809+="${truncated_9819}"
                    get_visible_len__1487_v0 "${truncated_9819}"
                    local ret_get_visible_len1487_v0__220_40="${ret_get_visible_len1487_v0}"
                    remaining_width_9810="$(( remaining_width_9810 - ret_get_visible_len1487_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_9812}" == "_" ]; echo $?) && $(( remaining_width_9810 > 0 )) ))" != 0 ]; then
                    truncate_text__1488_v0 "${part_9812}" "${remaining_width_9810}"
                    local ret_truncate_text1488_v0__225_39="${ret_truncate_text1488_v0}"
                    local truncated_9820="${ret_truncate_text1488_v0__225_39}"
                    result_9809+="${truncated_9820}"
                    get_visible_len__1487_v0 "${truncated_9820}"
                    local ret_get_visible_len1487_v0__227_40="${ret_get_visible_len1487_v0}"
                    remaining_width_9810="$(( remaining_width_9810 - ret_get_visible_len1487_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi1489_v0="${result_9809}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__1490_v0() {
    local text_9787="${1}"
    local max_width_9788="${2}"
    get_visible_len__1487_v0 "${text_9787}"
    local visible_len_9797="${ret_get_visible_len1487_v0}"
    if [ "$(( visible_len_9797 <= max_width_9788 ))" != 0 ]; then
        ret_cutoff_text1490_v0="${text_9787}"
        return 0
    fi
    truncate_ansi__1489_v0 "${text_9787}" "$(( max_width_9788 - 3 ))"
    local ret_truncate_ansi1489_v0__243_12="${ret_truncate_ansi1489_v0}"
    ret_cutoff_text1490_v0="${ret_truncate_ansi1489_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__1491_v0() {
    local items_9853=("${!1}")
    local total_len_9854="${2}"
    local term_width_9855="${3}"
    local separator_9856=" • "
    local separator_len_9857=3
    # Fast path: no truncation needed
    if [ "$(( total_len_9854 <= term_width_9855 ))" != 0 ]; then
        local iter_9858=0
        while :
        do
            local __length_299=("${items_9853[@]}")
            if [ "$(( iter_9858 >= ${#__length_299[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_9858 > 0 ))" != 0 ]; then
                eprintf_colored__1471_v0 "${separator_9856}" 90
            fi
            colored__1472_v0 "${items_9853[$(( iter_9858 + 1 ))]?"Index out of bounds (at src/./confirm/../utils.ab:268:55)"}" 2
            local ret_colored1472_v0__268_41="${ret_colored1472_v0}"
            local array_300=("")
            eprintf__1470_v0 "${items_9853[${iter_9858}]?"Index out of bounds (at src/./confirm/../utils.ab:268:27)"}"" ""${ret_colored1472_v0__268_41}" array_300[@]
            iter_9858="$(( iter_9858 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_9861=0
        local first_9862=1
        local iter_9863=0
        while :
        do
            local __length_301=("${items_9853[@]}")
            if [ "$(( iter_9863 >= ${#__length_301[@]} ))" != 0 ]; then
                break
            fi
            local key_9864="${items_9853[${iter_9863}]?"Index out of bounds (at src/./confirm/../utils.ab:280:31)"}"
            local action_9865="${items_9853[$(( iter_9863 + 1 ))]?"Index out of bounds (at src/./confirm/../utils.ab:281:34)"}"
            local __length_302="${key_9864}"
            local __length_303="${action_9865}"
            local part_len_9866="$(( $(( ${#__length_302} + 1 )) + ${#__length_303} ))"
            local needed_9867="${part_len_9866}"
            if [ "$(( ! first_9862 ))" != 0 ]; then
                needed_9867="$(( needed_9867 + separator_len_9857 ))"
            fi
            if [ "$(( $(( current_len_9861 + needed_9867 )) > term_width_9855 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_9862 ))" != 0 ]; then
                eprintf_colored__1471_v0 "${separator_9856}" 90
            fi
            colored__1472_v0 "${action_9865}" 2
            local ret_colored1472_v0__296_33="${ret_colored1472_v0}"
            local array_304=("")
            eprintf__1470_v0 "${key_9864}"" ""${ret_colored1472_v0__296_33}" array_304[@]
            current_len_9861="$(( current_len_9861 + needed_9867 ))"
            first_9862=0
            iter_9863="$(( iter_9863 + 2 ))"
        done
    fi
}

# render_confirm_options(selected: Bool, term_width: Int)
render_confirm_options__1541_v0() {
    local selected_9822="${1}"
    local term_width_9823="${2}"
    local small_9824="$(( term_width_9823 < 30 ))"
    cpad__29_v0 "Yes" " " "$(if [ "${small_9824}" != 0 ]; then echo 5; else echo 11; fi)"
    local yes_label_9843="${ret_cpad29_v0}"
    cpad__29_v0 "No" " " "$(if [ "${small_9824}" != 0 ]; then echo 4; else echo 10; fi)"
    local no_label_9844="${ret_cpad29_v0}"
    local gap_9845
    gap_9845="$(if [ "${small_9824}" != 0 ]; then echo " "; else echo "  "; fi)"
    local array_305=("")
    eprintf__1470_v0 " " array_305[@]
    if [ "${selected_9822}" != 0 ]; then
        # Yes selected
        background_secondary__1456_v0 "${yes_label_9843}"
        local ret_background_secondary1456_v0__16_30="${ret_background_secondary1456_v0}"
        local array_306=("")
        eprintf__1470_v0 "\\x1b[97m""${ret_background_secondary1456_v0__16_30}" array_306[@]
        local array_307=("")
        eprintf__1470_v0 "${gap_9845}" array_307[@]
        # No not selected (dim)
        local array_308=("")
        eprintf__1470_v0 "\\x1b[49;37m""${no_label_9844}""\\x1b[0m" array_308[@]
    else
        # No selected
        local array_309=("")
        eprintf__1470_v0 "\\x1b[49;37m""${yes_label_9843}""\\x1b[0m" array_309[@]
        local array_310=("")
        eprintf__1470_v0 "${gap_9845}" array_310[@]
        background_secondary__1456_v0 "${no_label_9844}"
        local ret_background_secondary1456_v0__24_30="${ret_background_secondary1456_v0}"
        local array_311=("")
        eprintf__1470_v0 "\\x1b[97m""${ret_background_secondary1456_v0__24_30}" array_311[@]
    fi
}

# xyl_confirm(header: Text, default_yes: Bool)
xyl_confirm__1542_v0() {
    local header_9772="${1}"
    local default_yes_9773="${2}"
    stty_lock__1429_v0 
    hide_cursor__1481_v0 
    term_width__1436_v0 
    local term_width_9786="${ret_term_width1436_v0}"
    if [ "$([ "_${header_9772}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__1490_v0 "${header_9772}" "${term_width_9786}"
        local ret_cutoff_text1490_v0__46_17="${ret_cutoff_text1490_v0}"
        local array_312=("")
        eprintf__1470_v0 "${ret_cutoff_text1490_v0__46_17}""

" array_312[@]
    fi
    local selected_9821="${default_yes_9773}"
    # Render initial options
    render_confirm_options__1541_v0 "${selected_9821}" "${term_width_9786}"
    local array_313=("")
    eprintf__1470_v0 "

" array_313[@]
    # "←→ select • enter confirm • y yes • n no" = 9 + 3 + 13 + 3 + 5 + 3 + 4 = 40
    local array_314=("←→" "select" "enter" "confirm" "y" "yes" "n" "no")
    render_tooltip__1491_v0 array_314[@] 40 "${term_width_9786}"
    go_up__1478_v0 2
    while :
    do
        get_key__1468_v0 
        local key_9870="${ret_get_key1468_v0}"
        if [ "$(( $(( $(( $([ "_${key_9870}" != "_LEFT" ]; echo $?) || $([ "_${key_9870}" != "_h" ]; echo $?) )) || $([ "_${key_9870}" != "_RIGHT" ]; echo $?) )) || $([ "_${key_9870}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "${selected_9821}" != 0 ]; then
                selected_9821=0
                local array_315=("")
                eprintf__1470_v0 "\\x1b[G\\x1b[K" array_315[@]
                render_confirm_options__1541_v0 "${selected_9821}" "${term_width_9786}"
            elif [ "$(( ! selected_9821 ))" != 0 ]; then
                selected_9821=1
                local array_316=("")
                eprintf__1470_v0 "\\x1b[G\\x1b[K" array_316[@]
                render_confirm_options__1541_v0 "${selected_9821}" "${term_width_9786}"
            fi
        elif [ "$(( $([ "_${key_9870}" != "_y" ]; echo $?) || $([ "_${key_9870}" != "_Y" ]; echo $?) ))" != 0 ]; then
            selected_9821=1
            break
        elif [ "$(( $([ "_${key_9870}" != "_n" ]; echo $?) || $([ "_${key_9870}" != "_N" ]; echo $?) ))" != 0 ]; then
            selected_9821=0
            break
        elif [ "$([ "_${key_9870}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
    done
    # Clean up: remove options line and hint line
    local total_lines_9871=4
    if [ "$([ "_${header_9772}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_9871="$(( total_lines_9871 + 1 ))"
    fi
    go_down__1479_v0 2
    remove_line__1474_v0 "$(( total_lines_9871 - 1 ))"
    remove_current_line__1475_v0 
    stty_unlock__1430_v0 
    show_cursor__1482_v0 
    ret_xyl_confirm1542_v0="${selected_9821}"
    return 0
}

# print_confirm_help()
print_confirm_help__1635_v0() {
    echo "Usage: ./xylitol.sh confirm [flags]"
    printf '%s\n' ""
    colored_primary__1452_v0 "confirm"
    local ret_colored_primary1452_v0__7_12="${ret_colored_primary1452_v0}"
    local array_317=()
    printf__128_v1 "${ret_colored_primary1452_v0__7_12}" array_317[@]
    local array_318=()
    printf__128_v1 " - Display a Yes/No confirmation dialog." array_318[@]
    printf '%s\n' ""
    printf '%s\n' ""
    colored_secondary__1453_v0 "Flags: "
    local ret_colored_secondary1453_v0__11_12="${ret_colored_secondary1453_v0}"
    local array_319=()
    printf__128_v1 "${ret_colored_secondary1453_v0__11_12}""
" array_319[@]
    echo "  -h, --help             Show this help message"
    echo "  --header=\"<text>\"      Set a header text to display above the options (ANSI escape supported)"
    echo "  --default=<yes|no>     Set the default selection (default: yes)"
    printf '%s\n' ""
}

# execute_confirm(parameters: [Text])
execute_confirm__1686_v0() {
    local parameters_9743=("${!1}")
    colored_primary__1452_v0 "Are you sure?"
    local ret_colored_primary1452_v0__9_30="${ret_colored_primary1452_v0}"
    local header_9758="\\x1b[1m""${ret_colored_primary1452_v0__9_30}"
    local default_yes_9759=1
    for param_9760 in "${parameters_9743[@]}"; do
        match_regex__19_v0 "${param_9760}" "^-h\$" 0
        local ret_match_regex19_v0__14_13="${ret_match_regex19_v0}"
        match_regex__19_v0 "${param_9760}" "^--help\$" 0
        local ret_match_regex19_v0__14_43="${ret_match_regex19_v0}"
        match_regex__19_v0 "${param_9760}" "^--header=.*\$" 0
        local ret_match_regex19_v0__18_13="${ret_match_regex19_v0}"
        match_regex__19_v0 "${param_9760}" "^--default=.*\$" 0
        local ret_match_regex19_v0__22_13="${ret_match_regex19_v0}"
        if [ "$(( ret_match_regex19_v0__14_13 || ret_match_regex19_v0__14_43 ))" != 0 ]; then
            print_confirm_help__1635_v0 
            exit 0
        elif [ "${ret_match_regex19_v0__18_13}" != 0 ]; then
            split__4_v0 "${param_9760}" "="
            local result_9762=("${ret_split4_v0[@]}")
            header_9758="${result_9762[1]?"Index out of bounds (at src/./confirm/exec.ab:20:33)"}"
        elif [ "${ret_match_regex19_v0__22_13}" != 0 ]; then
            split__4_v0 "${param_9760}" "="
            local result_9763=("${ret_split4_v0[@]}")
            if [ "$(( $([ "_${result_9763[1]?"Index out of bounds (at src/./confirm/exec.ab:25:28)"}" != "_yes" ]; echo $?) || $([ "_${result_9763[1]?"Index out of bounds (at src/./confirm/exec.ab:25:50)"}" != "_y" ]; echo $?) ))" != 0 ]; then
                default_yes_9759=1
            elif [ "$(( $([ "_${result_9763[1]?"Index out of bounds (at src/./confirm/exec.ab:26:28)"}" != "_no" ]; echo $?) || $([ "_${result_9763[1]?"Index out of bounds (at src/./confirm/exec.ab:26:49)"}" != "_n" ]; echo $?) ))" != 0 ]; then
                default_yes_9759=0
            else
                eprintf_colored__1471_v0 "ERROR: Invalid default value: ""${result_9763[1]?"Index out of bounds (at src/./confirm/exec.ab:28:83)"}"". Use 'yes' or 'no'.
" 31
                exit 1
            fi
        fi
    done
    has_ansi_escape__1483_v0 "${header_9758}"
    local ret_has_ansi_escape1483_v0__36_44="${ret_has_ansi_escape1483_v0}"
    escape_ansi__1484_v0 "${header_9758}"
    local ret_escape_ansi1484_v0__36_73="${ret_escape_ansi1484_v0}"
    colored_primary__1452_v0 "${header_9758}"
    local ret_colored_primary1452_v0__36_111="${ret_colored_primary1452_v0}"
    local display_header_9771
    display_header_9771="$(if [ "$(( $([ "_${header_9758}" != "_" ]; echo $?) || ret_has_ansi_escape1483_v0__36_44 ))" != 0 ]; then echo "${ret_escape_ansi1484_v0__36_73}"; else echo "\\x1b[1m""${ret_colored_primary1452_v0__36_111}"; fi)"
    xyl_confirm__1542_v0 "${display_header_9771}" "${default_yes_9759}"
    local result_9878="${ret_xyl_confirm1542_v0}"
    ret_execute_confirm1686_v0="$(if [ "${result_9878}" != 0 ]; then echo "yes"; else echo "no"; fi)"
    return 0
}

# get_directory_entries(path: Text)
get_directory_entries__1841_v0() {
    local path_13681="${1}"
    # `names` comes from the `ls` builtin, which sorts under `LC_ALL=C`.
    # The long listings below must use the same collation, otherwise the
    # three arrays fall out of alignment for non-ASCII file names.
    local command_322
    command_322="$(LC_ALL=C ls -lA "${path_13681}" 2>/dev/null | tail -n +2)"
    __status=$?
    local raw_output_13682="${command_322}"
    local command_323
    command_323="$(LC_ALL=C ls -lA "${path_13681}" | tail -n +2 | sed -E 's/^(.).*/\1/')"
    __status=$?
    local types_output_13683="${command_323}"
    local __ls_path_324="${path_13681}"
    __ls_path_324="${__ls_path_324//\\/\\\\}"
    (( 1 )) && __ls_all_324="-A" || __ls_all_324=""
    (( 0 )) && __ls_rec_324="-R" || __ls_rec_324=""
    local __ls_324=()
    LC_ALL=C IFS=$'\n' read -rd '' -a __ls_324 < <(IFS=$'\n'; LC_ALL=C ls -1 ${__ls_all_324} ${__ls_rec_324} ${__ls_path_324}
    __status=$?
    );
    local names_13684=("${__ls_324[@]}")
    split__4_v0 "${types_output_13683}" "
"
    local types_13685=("${ret_split4_v0[@]}")
    split__4_v0 "${raw_output_13682}" "
"
    local raw_13686=("${ret_split4_v0[@]}")
    local entries_13687=()
    local __range_start_13688=0
    local __length_326=("${raw_13686[@]}")
    local __range_end_13688="${#__length_326[@]}"
    local __dir_13688=$(( ${__range_start_13688} <= ${__range_end_13688} ? 1 : -1 ))
    for (( i_13688=${__range_start_13688}; i_13688 * ${__dir_13688} < ${__range_end_13688} * ${__dir_13688}; i_13688+=${__dir_13688} )); do
        local file_type_13689="f"
        local target_13690=""
        if [ "$([ "_${types_13685[${i_13688}]?"Index out of bounds (at src/./file/../utils/fs.ab:22:19)"}" != "_-" ]; echo $?)" != 0 ]; then
            file_type_13689="f"
        elif [ "$([ "_${types_13685[${i_13688}]?"Index out of bounds (at src/./file/../utils/fs.ab:25:19)"}" != "_d" ]; echo $?)" != 0 ]; then
            file_type_13689="d"
        elif [ "$([ "_${types_13685[${i_13688}]?"Index out of bounds (at src/./file/../utils/fs.ab:28:19)"}" != "_l" ]; echo $?)" != 0 ]; then
            local command_327
            command_327="$(echo ${raw_13686[${i_13688}]?"Index out of bounds (at src/./file/../utils/fs.ab:29:44)"} | sed 's/.*-> //')"
            __status=$?
            target_13690="${command_327}"
            file_type_13689="l"
        fi
        if [ "$([ "_${file_type_13689}" != "_l" ]; echo $?)" != 0 ]; then
            local array_328=("${names_13684[${i_13688}]?"Index out of bounds (at src/./file/../utils/fs.ab:35:33)"}	${types_13685[${i_13688}]?"Index out of bounds (at src/./file/../utils/fs.ab:35:45)"}	${target_13690}")
            entries_13687+=("${array_328[@]}")
        else
            local array_329=("${names_13684[${i_13688}]?"Index out of bounds (at src/./file/../utils/fs.ab:37:33)"}	${types_13685[${i_13688}]?"Index out of bounds (at src/./file/../utils/fs.ab:37:45)"}")
            entries_13687+=("${array_329[@]}")
        fi
done
    ret_get_directory_entries1841_v0=("${entries_13687[@]}")
    return 0
}

# parse_entry(entry: Text)
parse_entry__1842_v0() {
    local entry_13695="${1}"
    split__4_v0 "${entry_13695}" "	"
    ret_parse_entry1842_v0=("${ret_split4_v0[@]}")
    return 0
}

# get_cwd()
get_cwd__1843_v0() {
    local command_330
    command_330="$(pwd)"
    __status=$?
    ret_get_cwd1843_v0="${command_330}"
    return 0
}

# normalize_path(path: Text)
normalize_path__1844_v0() {
    local path_13679="${1}"
    local command_331
    command_331="$(cd "${path_13679}" 2>/dev/null && pwd)"
    __status=$?
    local normalized_13680="${command_331}"
    if [ "$([ "_${normalized_13680}" != "_" ]; echo $?)" != 0 ]; then
        ret_normalize_path1844_v0="${path_13679}"
        return 0
    fi
    ret_normalize_path1844_v0="${normalized_13680}"
    return 0
}

# path_join(base: Text, child: Text)
path_join__1845_v0() {
    local base_13851="${1}"
    local child_13852="${2}"
    if [ "$([ "_${base_13851}" != "_/" ]; echo $?)" != 0 ]; then
        ret_path_join1845_v0="/""${child_13852}"
        return 0
    fi
    ret_path_join1845_v0="${base_13851}""/""${child_13852}"
    return 0
}

# get_parent_dir(path: Text)
get_parent_dir__1846_v0() {
    local path_13849="${1}"
    local command_332
    command_332="$(dirname "${path_13849}")"
    __status=$?
    local parent_13850="${command_332}"
    ret_get_parent_dir1846_v0="${parent_13850}"
    return 0
}

# Perl Extensions Utilities
command_333="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_39="$([ "_${command_333}" != "_No" ]; echo $?)"
command_334="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_40="$(( $(( ! _perl_disabled_39 )) && $([ "_${command_334}" != "_0" ]; echo $?) ))"
# global variables to store terminal size
# (prevent multiple queries in one session)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_lock()
stty_lock__1864_v0() {
    local command_336
    command_336="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_13676="${command_336}"
    parse_int__13_v0 "${count_13676}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_13677="${ret_parse_int13_v0}"
    if [ "$(( count_num_13677 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_13677="$(( count_num_13677 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_13677}
    __status=$?
}

# stty_unlock()
stty_unlock__1865_v0() {
    local command_337
    command_337="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_13704="${command_337}"
    parse_int__13_v0 "${count_13704}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_13705="${ret_parse_int13_v0}"
    if [ "$(( count_num_13705 > 0 ))" != 0 ]; then
        count_num_13705="$(( count_num_13705 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_13705}
        __status=$?
        if [ "$(( count_num_13705 == 0 ))" != 0 ]; then
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
_supports_truecolor_43="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_44=0
_primary_color_45=(3 207 159 92)
_secondary_color_46=(3 118 206 94)
_accent_color_47=(234 72 121 95)
# get_supports_truecolor()
get_supports_truecolor__1882_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local config_13662="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_13662}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_43="No"
        ret_get_supports_truecolor1882_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_43="No"
        ret_get_supports_truecolor1882_v0=0
        return 0
    fi
    local colorterm_13663="${ret_env_var_get120_v0}"
    _supports_truecolor_43="$(if [ "$(( $([ "_${colorterm_13663}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_13663}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1882_v0="$([ "_${_supports_truecolor_43}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__1883_v0() {
    local message_13657="${1}"
    local r_13658="${2}"
    local g_13659="${3}"
    local b_13660="${4}"
    local fallback_13661="${5}"
    if [ "$([ "_${_supports_truecolor_43}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1883_v0="\\x1b[38;2;${r_13658};${g_13659};${b_13660}m""${message_13657}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_43}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1882_v0 
        local ret_get_supports_truecolor1882_v0__50_17="${ret_get_supports_truecolor1882_v0}"
        if [ "${ret_get_supports_truecolor1882_v0__50_17}" != 0 ]; then
            ret_colored_rgb1883_v0="\\x1b[38;2;${r_13658};${g_13659};${b_13660}m""${message_13657}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_13661 == 0 ))" != 0 ]; then
            ret_colored_rgb1883_v0="${message_13657}"
            return 0
        else
            ret_colored_rgb1883_v0="\\x1b[${fallback_13661}m""${message_13657}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_13661 == 0 ))" != 0 ]; then
            ret_colored_rgb1883_v0="${message_13657}"
            return 0
        fi
        ret_colored_rgb1883_v0="\\x1b[${fallback_13661}m""${message_13657}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__1885_v0() {
    if [ "$(( ! _got_xylitol_colors_44 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local primary_env_13651="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_13651}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_13651}" ";"
            local parts_13652=("${ret_split4_v0[@]}")
            local __length_341=("${parts_13652[@]}")
            if [ "$(( ${#__length_341[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_13652[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1885_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13652[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1885_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13652[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1885_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13652[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1885_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
                _primary_color_45=("${ret_parse_int13_v0__115_21}" "${ret_parse_int13_v0__116_21}" "${ret_parse_int13_v0__117_21}" "${ret_parse_int13_v0__118_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local secondary_env_13653="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_13653}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_13653}" ";"
            local parts_13654=("${ret_split4_v0[@]}")
            local __length_343=("${parts_13654[@]}")
            if [ "$(( ${#__length_343[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_13654[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1885_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13654[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1885_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13654[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1885_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13654[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1885_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_46=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local accent_env_13655="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_13655}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_13655}" ";"
            local parts_13656=("${ret_split4_v0[@]}")
            local __length_345=("${parts_13656[@]}")
            if [ "$(( ${#__length_345[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_13656[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1885_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13656[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1885_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13656[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1885_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13656[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1885_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
                _accent_color_47=("${ret_parse_int13_v0__141_21}" "${ret_parse_int13_v0__142_21}" "${ret_parse_int13_v0__143_21}" "${ret_parse_int13_v0__144_21}")
            fi
        fi
        _got_xylitol_colors_44=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__1886_v0() {
    inner_get_xylitol_colors__1885_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_44=1
}

# colored_primary(message: Text)
colored_primary__1887_v0() {
    local message_13650="${1}"
    if [ "$(( ! _got_xylitol_colors_44 ))" != 0 ]; then
        get_xylitol_colors__1886_v0 
    fi
    colored_rgb__1883_v0 "${message_13650}" "${_primary_color_45[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:164:48)"}" "${_primary_color_45[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:164:67)"}" "${_primary_color_45[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:164:86)"}" "${_primary_color_45[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:164:105)"}"
    ret_colored_primary1887_v0="${ret_colored_rgb1883_v0}"
    return 0
}

# colored_secondary(message: Text)
colored_secondary__1888_v0() {
    local message_13664="${1}"
    if [ "$(( ! _got_xylitol_colors_44 ))" != 0 ]; then
        get_xylitol_colors__1886_v0 
    fi
    colored_rgb__1883_v0 "${message_13664}" "${_secondary_color_46[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:171:50)"}" "${_secondary_color_46[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:171:71)"}" "${_secondary_color_46[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:171:92)"}" "${_secondary_color_46[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary1888_v0="${ret_colored_rgb1883_v0}"
    return 0
}

# colored_accent(message: Text)
colored_accent__1889_v0() {
    local message_13703="${1}"
    if [ "$(( ! _got_xylitol_colors_44 ))" != 0 ]; then
        get_xylitol_colors__1886_v0 
    fi
    colored_rgb__1883_v0 "${message_13703}" "${_accent_color_47[0]?"Index out of bounds (at src/./file/../utils/truecolor.ab:178:47)"}" "${_accent_color_47[1]?"Index out of bounds (at src/./file/../utils/truecolor.ab:178:65)"}" "${_accent_color_47[2]?"Index out of bounds (at src/./file/../utils/truecolor.ab:178:83)"}" "${_accent_color_47[3]?"Index out of bounds (at src/./file/../utils/truecolor.ab:178:101)"}"
    ret_colored_accent1889_v0="${ret_colored_rgb1883_v0}"
    return 0
}

# // IO Functions /////
# eprintf(format: Text, args: [Text])
eprintf__1905_v0() {
    local format_13670="${1}"
    local args_13671=("${!2}")
    args_13671=("${format_13670}" "${args_13671[@]}")
    __status=$?
    printf "${args_13671[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__1906_v0() {
    local message_13668="${1}"
    local color_13669="${2}"
    # Prints an error message with a specified color.
    local array_347=("${message_13668}")
    eprintf__1905_v0 "\\x1b[${color_13669}m%s\\x1b[0m" array_347[@]
}

# remove_current_line()
remove_current_line__1910_v0() {
    local array_348=("")
    eprintf__1905_v0 "\\x1b[2K\\x1b[G" array_348[@]
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# // Application Utilities /////
# Perl Extensions Utilities
command_349="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_48="$([ "_${command_349}" != "_No" ]; echo $?)"
command_350="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_49="$(( $(( ! _perl_disabled_48 )) && $([ "_${command_350}" != "_0" ]; echo $?) ))"
# perl_get_cjk_width(text: Text)
perl_get_cjk_width__2077_v0() {
    local text_13737="${1}"
    if [ "$(( ! _perl_available_49 ))" != 0 ]; then
        ret_perl_get_cjk_width2077_v0=''
        return 1
    fi
    local command_351
    command_351="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text_13737}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2077_v0=''
        return "${__status}"
    fi
    local width_str_13738="${command_351}"
    parse_int__13_v0 "${width_str_13738}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width2077_v0=''
        return "${__status}"
    fi
    local width_13739="${ret_parse_int13_v0}"
    ret_perl_get_cjk_width2077_v0="${width_13739}"
    return 0
}

# perl_truncate_cjk(text: Text, max_width: Int)
perl_truncate_cjk__2078_v0() {
    local text_13748="${1}"
    local max_width_13749="${2}"
    if [ "$(( ! _perl_available_49 ))" != 0 ]; then
        ret_perl_truncate_cjk2078_v0=''
        return 1
    fi
    local command_352
    command_352="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text_13748}" ${max_width_13749} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk2078_v0=''
        return "${__status}"
    fi
    local result_13750="${command_352}"
    ret_perl_truncate_cjk2078_v0="${result_13750}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_50=0
_term_size_51=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
# stty_lock()
stty_lock__2086_v0() {
    local command_354
    command_354="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_13715="${command_354}"
    parse_int__13_v0 "${count_13715}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_13716="${ret_parse_int13_v0}"
    if [ "$(( count_num_13716 == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_13716="$(( count_num_13716 + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_13716}
    __status=$?
}

# stty_unlock()
stty_unlock__2087_v0() {
    local command_355
    command_355="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    local count_13837="${command_355}"
    parse_int__13_v0 "${count_13837}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local count_num_13838="${ret_parse_int13_v0}"
    if [ "$(( count_num_13838 > 0 ))" != 0 ]; then
        count_num_13838="$(( count_num_13838 - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_13838}
        __status=$?
        if [ "$(( count_num_13838 == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

# parse_size(text: Text)
parse_size__2088_v0() {
    local text_13719="${1}"
    # `match_regex` uses BRE by default, where `+` is a literal character
    match_regex__19_v0 "${text_13719}" "^[0-9][0-9]*\$" 0
    local ret_match_regex19_v0__38_12="${ret_match_regex19_v0}"
    if [ "$(( ! ret_match_regex19_v0__38_12 ))" != 0 ]; then
        ret_parse_size2088_v0=0
        return 0
    fi
    parse_int__13_v0 "${text_13719}"
    __status=$?
    ret_parse_size2088_v0="${ret_parse_int13_v0}"
    return 0
}

# query_term_size()
query_term_size__2089_v0() {
    local command_356
    command_356="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; echo "$height; $width")"
    __status=$?
    local result_13717="${command_356}"
    split__4_v0 "${result_13717}" ";"
    local parts_13718=("${ret_split4_v0[@]}")
    local __length_357=("${parts_13718[@]}")
    if [ "$(( ${#__length_357[@]} != 2 ))" != 0 ]; then
        ret_query_term_size2089_v0=0
        return 0
    fi
    parse_size__2088_v0 "${parts_13718[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:53:35)"}"
    local rows_13720="${ret_parse_size2088_v0}"
    parse_size__2088_v0 "${parts_13718[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:54:35)"}"
    local cols_13721="${ret_parse_size2088_v0}"
    if [ "$(( $(( rows_13720 <= 0 )) || $(( cols_13721 <= 0 )) ))" != 0 ]; then
        ret_query_term_size2089_v0=0
        return 0
    fi
    _term_size_51=("${cols_13721}" "${rows_13720}")
    ret_query_term_size2089_v0=1
    return 0
}

# stty_term_size()
stty_term_size__2090_v0() {
    local command_359
    command_359="$(stty size < /dev/tty 2>/dev/null)"
    __status=$?
    local result_13723="${command_359}"
    split__4_v0 "${result_13723}" " "
    local parts_13724=("${ret_split4_v0[@]}")
    local __length_360=("${parts_13724[@]}")
    if [ "$(( ${#__length_360[@]} != 2 ))" != 0 ]; then
        ret_stty_term_size2090_v0=0
        return 0
    fi
    parse_size__2088_v0 "${parts_13724[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:70:35)"}"
    local rows_13725="${ret_parse_size2088_v0}"
    parse_size__2088_v0 "${parts_13724[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:71:35)"}"
    local cols_13726="${ret_parse_size2088_v0}"
    if [ "$(( $(( rows_13725 <= 0 )) || $(( cols_13726 <= 0 )) ))" != 0 ]; then
        ret_stty_term_size2090_v0=0
        return 0
    fi
    _term_size_51=("${cols_13726}" "${rows_13725}")
    ret_stty_term_size2090_v0=1
    return 0
}

# get_term_size()
get_term_size__2091_v0() {
    query_term_size__2089_v0 
    local detected_13722="${ret_query_term_size2089_v0}"
    if [ "$(( ! detected_13722 ))" != 0 ]; then
        stty_term_size__2090_v0 
        detected_13722="${ret_stty_term_size2090_v0}"
    fi
    _got_term_size_50=1
}

# term_width()
term_width__2093_v0() {
    if [ "$(( ! _got_term_size_50 ))" != 0 ]; then
        get_term_size__2091_v0 
    fi
    ret_term_width2093_v0="${_term_size_51[0]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:101:23)"}"
    return 0
}

# term_height()
term_height__2094_v0() {
    if [ "$(( ! _got_term_size_50 ))" != 0 ]; then
        get_term_size__2091_v0 
    fi
    ret_term_height2094_v0="${_term_size_51[1]?"Index out of bounds (at src/./file/../choose/../utils/term.ab:109:23)"}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_52="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_53=0
_secondary_color_55=(3 118 206 94)
# get_supports_truecolor()
get_supports_truecolor__2104_v0() {
    env_var_get__120_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    local config_13817="${ret_env_var_get120_v0}"
    if [ "$([ "_${config_13817}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_52="No"
        ret_get_supports_truecolor2104_v0=0
        return 0
    fi
    env_var_get__120_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_52="No"
        ret_get_supports_truecolor2104_v0=0
        return 0
    fi
    local colorterm_13818="${ret_env_var_get120_v0}"
    _supports_truecolor_52="$(if [ "$(( $([ "_${colorterm_13818}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_13818}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor2104_v0="$([ "_${_supports_truecolor_52}" != "_Yes" ]; echo $?)"
    return 0
}

# colored_rgb(message: Text, r: Int, g: Int, b: Int, fallback: Int)
colored_rgb__2105_v0() {
    local message_13812="${1}"
    local r_13813="${2}"
    local g_13814="${3}"
    local b_13815="${4}"
    local fallback_13816="${5}"
    if [ "$([ "_${_supports_truecolor_52}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb2105_v0="\\x1b[38;2;${r_13813};${g_13814};${b_13815}m""${message_13812}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_52}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__2104_v0 
        local ret_get_supports_truecolor2104_v0__50_17="${ret_get_supports_truecolor2104_v0}"
        if [ "${ret_get_supports_truecolor2104_v0__50_17}" != 0 ]; then
            ret_colored_rgb2105_v0="\\x1b[38;2;${r_13813};${g_13814};${b_13815}m""${message_13812}""\\x1b[0m"
            return 0
        elif [ "$(( fallback_13816 == 0 ))" != 0 ]; then
            ret_colored_rgb2105_v0="${message_13812}"
            return 0
        else
            ret_colored_rgb2105_v0="\\x1b[${fallback_13816}m""${message_13812}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( fallback_13816 == 0 ))" != 0 ]; then
            ret_colored_rgb2105_v0="${message_13812}"
            return 0
        fi
        ret_colored_rgb2105_v0="\\x1b[${fallback_13816}m""${message_13812}""\\x1b[0m"
        return 0
    fi
}

# inner_get_xylitol_colors()
inner_get_xylitol_colors__2107_v0() {
    if [ "$(( ! _got_xylitol_colors_53 ))" != 0 ]; then
        env_var_get__120_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local primary_env_13806="${ret_env_var_get120_v0}"
        if [ "$([ "_${primary_env_13806}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${primary_env_13806}" ";"
            local parts_13807=("${ret_split4_v0[@]}")
            local __length_365=("${parts_13807[@]}")
            if [ "$(( ${#__length_365[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_13807[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:115:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2107_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__115_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13807[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:116:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2107_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__116_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13807[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:117:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2107_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__117_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13807[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:118:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2107_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__118_21="${ret_parse_int13_v0}"
            fi
        fi
        env_var_get__120_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local secondary_env_13808="${ret_env_var_get120_v0}"
        if [ "$([ "_${secondary_env_13808}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${secondary_env_13808}" ";"
            local parts_13809=("${ret_split4_v0[@]}")
            local __length_367=("${parts_13809[@]}")
            if [ "$(( ${#__length_367[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_13809[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:128:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2107_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__128_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13809[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:129:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2107_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__129_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13809[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:130:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2107_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__130_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13809[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:131:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2107_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__131_21="${ret_parse_int13_v0}"
                _secondary_color_55=("${ret_parse_int13_v0__128_21}" "${ret_parse_int13_v0__129_21}" "${ret_parse_int13_v0__130_21}" "${ret_parse_int13_v0__131_21}")
            fi
        fi
        env_var_get__120_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        local accent_env_13810="${ret_env_var_get120_v0}"
        if [ "$([ "_${accent_env_13810}" == "_" ]; echo $?)" != 0 ]; then
            split__4_v0 "${accent_env_13810}" ";"
            local parts_13811=("${ret_split4_v0[@]}")
            local __length_369=("${parts_13811[@]}")
            if [ "$(( ${#__length_369[@]} == 4 ))" != 0 ]; then
                parse_int__13_v0 "${parts_13811[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:141:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2107_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__141_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13811[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:142:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2107_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__142_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13811[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:143:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2107_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__143_21="${ret_parse_int13_v0}"
                parse_int__13_v0 "${parts_13811[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:144:37)"}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors2107_v0=''
                    return "${__status}"
                fi
                local ret_parse_int13_v0__144_21="${ret_parse_int13_v0}"
            fi
        fi
        _got_xylitol_colors_53=1
    fi
}

# get_xylitol_colors()
get_xylitol_colors__2108_v0() {
    inner_get_xylitol_colors__2107_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__134_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_53=1
}

# colored_secondary(message: Text)
colored_secondary__2110_v0() {
    local message_13805="${1}"
    if [ "$(( ! _got_xylitol_colors_53 ))" != 0 ]; then
        get_xylitol_colors__2108_v0 
    fi
    colored_rgb__2105_v0 "${message_13805}" "${_secondary_color_55[0]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:171:50)"}" "${_secondary_color_55[1]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:171:71)"}" "${_secondary_color_55[2]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:171:92)"}" "${_secondary_color_55[3]?"Index out of bounds (at src/./file/../choose/../utils/truecolor.ab:171:113)"}"
    ret_colored_secondary2110_v0="${ret_colored_rgb2105_v0}"
    return 0
}

# // IO Functions /////
# get_key()
get_key__2125_v0() {
    local command_371
    command_371="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    local var_13822="${command_371}"
    if [ "$([ "_${var_13822}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key2125_v0="UP"
        return 0
    elif [ "$([ "_${var_13822}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key2125_v0="DOWN"
        return 0
    elif [ "$([ "_${var_13822}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key2125_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_13822}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key2125_v0="LEFT"
        return 0
    elif [ "$([ "_${var_13822}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key2125_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_13822}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key2125_v0="INPUT"
        return 0
    else
        ret_get_key2125_v0="${var_13822}"
        return 0
    fi
}

# eprintf(format: Text, args: [Text])
eprintf__2127_v0() {
    local format_13713="${1}"
    local args_13714=("${!2}")
    args_13714=("${format_13713}" "${args_13714[@]}")
    __status=$?
    printf "${args_13714[@]}" >&2
    __status=$?
}

# eprintf_colored(message: Text, color: Int)
eprintf_colored__2128_v0() {
    local message_13711="${1}"
    local color_13712="${2}"
    # Prints an error message with a specified color.
    local array_372=("${message_13711}")
    eprintf__2127_v0 "\\x1b[${color_13712}m%s\\x1b[0m" array_372[@]
}

# colored(message: Text, color: Int)
colored__2129_v0() {
    local message_13778="${1}"
    local color_13779="${2}"
    # Returns a text wrapped in color codes.
    ret_colored2129_v0="\\x1b[${color_13779}m""${message_13778}""\\x1b[0m"
    return 0
}

# remove_line(cnt: Int)
remove_line__2131_v0() {
    local cnt_13828="${1}"
    if [ "$(( cnt_13828 > 0 ))" != 0 ]; then
        local sequence_13829=""
        local __range_start_13830=0
        local __range_end_13830="${cnt_13828}"
        local __dir_13830=$(( ${__range_start_13830} <= ${__range_end_13830} ? 1 : -1 ))
        for (( ____13830=${__range_start_13830}; ____13830 * ${__dir_13830} < ${__range_end_13830} * ${__dir_13830}; ____13830+=${__dir_13830} )); do
            sequence_13829+="\\x1b[2K\\x1b[1A"
done
        local array_373=("")
        eprintf__2127_v0 "${sequence_13829}" array_373[@]
    fi
    local array_374=("")
    eprintf__2127_v0 "\\x1b[G" array_374[@]
}

# remove_current_line()
remove_current_line__2132_v0() {
    local array_375=("")
    eprintf__2127_v0 "\\x1b[2K\\x1b[G" array_375[@]
}

# print_blank(cnt: Int)
print_blank__2133_v0() {
    local cnt_13819="${1}"
    printf '%*s' "${cnt_13819}" ' ' >&2
    __status=$?
}

# new_line(cnt: Int)
new_line__2134_v0() {
    local cnt_13770="${1}"
    local __range_start_13771=0
    local __range_end_13771="${cnt_13770}"
    local __dir_13771=$(( ${__range_start_13771} <= ${__range_end_13771} ? 1 : -1 ))
    for (( ____13771=${__range_start_13771}; ____13771 * ${__dir_13771} < ${__range_end_13771} * ${__dir_13771}; ____13771+=${__dir_13771} )); do
        local array_376=("")
        eprintf__2127_v0 "
" array_376[@]
done
}

# go_up(cnt: Int)
go_up__2135_v0() {
    local cnt_13787="${1}"
    local array_377=("")
    eprintf__2127_v0 "\\x1b[${cnt_13787}A" array_377[@]
}

# go_down(cnt: Int)
go_down__2136_v0() {
    local cnt_13835="${1}"
    local array_378=("")
    eprintf__2127_v0 "\\x1b[${cnt_13835}B" array_378[@]
}

# move the cursor up or down `cnt` lines.
# go_up_or_down(cnt: Int)
go_up_or_down__2137_v0() {
    local cnt_13834="${1}"
    if [ "$(( cnt_13834 > 0 ))" != 0 ]; then
        go_down__2136_v0 "${cnt_13834}"
    else
        go_up__2135_v0 "$(( - cnt_13834 ))"
    fi
}

# hide_cursor()
hide_cursor__2138_v0() {
    local array_379=("")
    eprintf__2127_v0 "\\x1b[?25l" array_379[@]
}

# show_cursor()
show_cursor__2139_v0() {
    local array_380=("")
    eprintf__2127_v0 "\\x1b[?25h" array_380[@]
}

# / Text Utilities /////
# has_ansi_escape(text: Text)
has_ansi_escape__2140_v0() {
    local text_13743="${1}"
    # Check for ESC character (0x1B = 27) or literal \x1b[
    local command_381
    command_381="$([[ "${text_13743}" == *$'\x1b'* || "${text_13743}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local has_escape_13744="${command_381}"
    ret_has_ansi_escape2140_v0="$([ "_${has_escape_13744}" != "_1" ]; echo $?)"
    return 0
}

# strip_ansi(text: Text)
strip_ansi__2142_v0() {
    local text_13733="${1}"
    local command_382
    command_382="$(printf "%s" "${text_13733}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi2142_v0="${command_382}"
    return 0
}

# is_all_ascii(text: Text)
is_all_ascii__2143_v0() {
    local text_13735="${1}"
    local command_383
    command_383="$(printf "%s" "${text_13735}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    local result_13736="${command_383}"
    ret_is_all_ascii2143_v0="$([ "_${result_13736}" != "_0" ]; echo $?)"
    return 0
}

# get_visible_len(text: Text)
get_visible_len__2144_v0() {
    local text_13732="${1}"
    strip_ansi__2142_v0 "${text_13732}"
    local stripped_13734="${ret_strip_ansi2142_v0}"
    # Check if text is all ASCII
    is_all_ascii__2143_v0 "${stripped_13734}"
    local ret_is_all_ascii2143_v0__150_12="${ret_is_all_ascii2143_v0}"
    if [ "$(( ! ret_is_all_ascii2143_v0__150_12 ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__2077_v0 "${stripped_13734}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            local __length_384="${stripped_13734}"
            ret_get_visible_len2144_v0="${#__length_384}"
            return 0
        fi
        ret_get_visible_len2144_v0="${ret_perl_get_cjk_width2077_v0}"
        return 0
    else
        local __length_385="${stripped_13734}"
        ret_get_visible_len2144_v0="${#__length_385}"
        return 0
    fi
}

# truncate_text(text: Text, max_width: Int)
truncate_text__2145_v0() {
    local text_13745="${1}"
    local max_width_13746="${2}"
    get_visible_len__2144_v0 "${text_13745}"
    local visible_len_13747="${ret_get_visible_len2144_v0}"
    if [ "$(( visible_len_13747 <= max_width_13746 ))" != 0 ]; then
        ret_truncate_text2145_v0="${text_13745}"
        return 0
    fi
    is_all_ascii__2143_v0 "${text_13745}"
    local ret_is_all_ascii2143_v0__167_12="${ret_is_all_ascii2143_v0}"
    if [ "$(( ! ret_is_all_ascii2143_v0__167_12 ))" != 0 ]; then
        perl_truncate_cjk__2078_v0 "${text_13745}" "${max_width_13746}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text_13745}" | cut -c1-${max_width_13746}
            __status=$?
        fi
        ret_truncate_text2145_v0="${ret_perl_truncate_cjk2078_v0}"
        return 0
    fi
    local command_386
    command_386="$(printf "%s" "${text_13745}" | cut -c1-${max_width_13746})"
    __status=$?
    ret_truncate_text2145_v0="${command_386}"
    return 0
}

# truncate_ansi(text: Text, max_width: Int)
truncate_ansi__2146_v0() {
    local text_13741="${1}"
    local max_width_13742="${2}"
    has_ansi_escape__2140_v0 "${text_13741}"
    local ret_has_ansi_escape2140_v0__179_12="${ret_has_ansi_escape2140_v0}"
    if [ "$(( ! ret_has_ansi_escape2140_v0__179_12 ))" != 0 ]; then
        truncate_text__2145_v0 "${text_13741}" "${max_width_13742}"
        ret_truncate_ansi2146_v0="${ret_truncate_text2145_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    local command_387
    command_387="$([[ "${text_13741}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    local starts_with_ansi_13751="${command_387}"
    # Replace \x1b[ with newline, then split
    local command_388
    command_388="$(t="${text_13741}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    local replaced_13752="${command_388}"
    split__4_v0 "${replaced_13752}" "
"
    local parts_13753=("${ret_split4_v0[@]}")
    local result_13754=""
    local remaining_width_13755="${max_width_13742}"
    local __range_start_13756=0
    local __length_389=("${parts_13753[@]}")
    local __range_end_13756="${#__length_389[@]}"
    local __dir_13756=$(( ${__range_start_13756} <= ${__range_end_13756} ? 1 : -1 ))
    for (( idx_13756=${__range_start_13756}; idx_13756 * ${__dir_13756} < ${__range_end_13756} * ${__dir_13756}; idx_13756+=${__dir_13756} )); do
        local part_13757="${parts_13753[${idx_13756}]?"Index out of bounds (at src/./file/../choose/../utils.ab:194:28)"}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( idx_13756 == 0 )) && $([ "_${starts_with_ansi_13751}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_13757}" == "_" ]; echo $?) && $(( remaining_width_13755 > 0 )) ))" != 0 ]; then
                truncate_text__2145_v0 "${part_13757}" "${remaining_width_13755}"
                local ret_truncate_text2145_v0__201_35="${ret_truncate_text2145_v0}"
                local truncated_13758="${ret_truncate_text2145_v0__201_35}"
                result_13754+="${truncated_13758}"
                get_visible_len__2144_v0 "${truncated_13758}"
                local ret_get_visible_len2144_v0__203_36="${ret_get_visible_len2144_v0}"
                remaining_width_13755="$(( remaining_width_13755 - ret_get_visible_len2144_v0__203_36 ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            local command_390
            command_390="$(__p="${part_13757}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            local m_idx_13759="${command_390}"
            if [ "$([ "_${m_idx_13759}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                local command_391
                command_391="$(__p="${part_13757}"; printf "%s" "${__p:0:${m_idx_13759}}")"
                __status=$?
                local ansi_params_13760="${command_391}"
                result_13754+="\\x1b[""${ansi_params_13760}""m"
                # Rest is text content
                parse_int__13_v0 "${m_idx_13759}"
                __status=$?
                local ret_parse_int13_v0__214_41="${ret_parse_int13_v0}"
                local m_idx_num_13761="${ret_parse_int13_v0__214_41}"
                local text_start_13762="$(( m_idx_num_13761 + 1 ))"
                local command_392
                command_392="$(__p="${part_13757}"; printf "%s" "${__p:${text_start_13762}}")"
                __status=$?
                local text_part_13763="${command_392}"
                if [ "$(( $([ "_${text_part_13763}" == "_" ]; echo $?) && $(( remaining_width_13755 > 0 )) ))" != 0 ]; then
                    truncate_text__2145_v0 "${text_part_13763}" "${remaining_width_13755}"
                    local ret_truncate_text2145_v0__218_39="${ret_truncate_text2145_v0}"
                    local truncated_13764="${ret_truncate_text2145_v0__218_39}"
                    result_13754+="${truncated_13764}"
                    get_visible_len__2144_v0 "${truncated_13764}"
                    local ret_get_visible_len2144_v0__220_40="${ret_get_visible_len2144_v0}"
                    remaining_width_13755="$(( remaining_width_13755 - ret_get_visible_len2144_v0__220_40 ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_13757}" == "_" ]; echo $?) && $(( remaining_width_13755 > 0 )) ))" != 0 ]; then
                    truncate_text__2145_v0 "${part_13757}" "${remaining_width_13755}"
                    local ret_truncate_text2145_v0__225_39="${ret_truncate_text2145_v0}"
                    local truncated_13765="${ret_truncate_text2145_v0__225_39}"
                    result_13754+="${truncated_13765}"
                    get_visible_len__2144_v0 "${truncated_13765}"
                    local ret_get_visible_len2144_v0__227_40="${ret_get_visible_len2144_v0}"
                    remaining_width_13755="$(( remaining_width_13755 - ret_get_visible_len2144_v0__227_40 ))"
                fi
            fi
        fi
done
    ret_truncate_ansi2146_v0="${result_13754}"
    return 0
}

# cutoff_text(text: Text, max_width: Int)
cutoff_text__2147_v0() {
    local text_13730="${1}"
    local max_width_13731="${2}"
    get_visible_len__2144_v0 "${text_13730}"
    local visible_len_13740="${ret_get_visible_len2144_v0}"
    if [ "$(( visible_len_13740 <= max_width_13731 ))" != 0 ]; then
        ret_cutoff_text2147_v0="${text_13730}"
        return 0
    fi
    truncate_ansi__2146_v0 "${text_13730}" "$(( max_width_13731 - 3 ))"
    local ret_truncate_ansi2146_v0__243_12="${ret_truncate_ansi2146_v0}"
    ret_cutoff_text2147_v0="${ret_truncate_ansi2146_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
# render_tooltip(items: [Text], total_len: Int, term_width: Int)
render_tooltip__2148_v0() {
    local items_13772=("${!1}")
    local total_len_13773="${2}"
    local term_width_13774="${3}"
    local separator_13775=" • "
    local separator_len_13776=3
    # Fast path: no truncation needed
    if [ "$(( total_len_13773 <= term_width_13774 ))" != 0 ]; then
        local iter_13777=0
        while :
        do
            local __length_393=("${items_13772[@]}")
            if [ "$(( iter_13777 >= ${#__length_393[@]} ))" != 0 ]; then
                break
            elif [ "$(( iter_13777 > 0 ))" != 0 ]; then
                eprintf_colored__2128_v0 "${separator_13775}" 90
            fi
            colored__2129_v0 "${items_13772[$(( iter_13777 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils.ab:268:55)"}" 2
            local ret_colored2129_v0__268_41="${ret_colored2129_v0}"
            local array_394=("")
            eprintf__2127_v0 "${items_13772[${iter_13777}]?"Index out of bounds (at src/./file/../choose/../utils.ab:268:27)"}"" ""${ret_colored2129_v0__268_41}" array_394[@]
            iter_13777="$(( iter_13777 + 2 ))"
        done
    else
        # Slow path: truncate
        local current_len_13780=0
        local first_13781=1
        local iter_13782=0
        while :
        do
            local __length_395=("${items_13772[@]}")
            if [ "$(( iter_13782 >= ${#__length_395[@]} ))" != 0 ]; then
                break
            fi
            local key_13783="${items_13772[${iter_13782}]?"Index out of bounds (at src/./file/../choose/../utils.ab:280:31)"}"
            local action_13784="${items_13772[$(( iter_13782 + 1 ))]?"Index out of bounds (at src/./file/../choose/../utils.ab:281:34)"}"
            local __length_396="${key_13783}"
            local __length_397="${action_13784}"
            local part_len_13785="$(( $(( ${#__length_396} + 1 )) + ${#__length_397} ))"
            local needed_13786="${part_len_13785}"
            if [ "$(( ! first_13781 ))" != 0 ]; then
                needed_13786="$(( needed_13786 + separator_len_13776 ))"
            fi
            if [ "$(( $(( current_len_13780 + needed_13786 )) > term_width_13774 ))" != 0 ]; then
                break
            fi
            if [ "$(( ! first_13781 ))" != 0 ]; then
                eprintf_colored__2128_v0 "${separator_13775}" 90
            fi
            colored__2129_v0 "${action_13784}" 2
            local ret_colored2129_v0__296_33="${ret_colored2129_v0}"
            local array_398=("")
            eprintf__2127_v0 "${key_13783}"" ""${ret_colored2129_v0__296_33}" array_398[@]
            current_len_13780="$(( current_len_13780 + needed_13786 ))"
            first_13781=0
            iter_13782="$(( iter_13782 + 2 ))"
        done
    fi
}

# get_page_options(options: [Text], page: Int, page_size: Int)
get_page_options__2198_v0() {
    local options_13788=("${!1}")
    local page_13789="${2}"
    local page_size_13790="${3}"
    local start_13791="$(( page_13789 * page_size_13790 ))"
    local end_13792="$(( start_13791 + page_size_13790 ))"
    local __length_399=("${options_13788[@]}")
    if [ "$(( end_13792 > ${#__length_399[@]} ))" != 0 ]; then
        local __length_400=("${options_13788[@]}")
        end_13792="${#__length_400[@]}"
    fi
    local result_13793=()
    local __range_start_13794="${start_13791}"
    local __range_end_13794="${end_13792}"
    local __dir_13794=$(( ${__range_start_13794} <= ${__range_end_13794} ? 1 : -1 ))
    for (( i_13794=${__range_start_13794}; i_13794 * ${__dir_13794} < ${__range_end_13794} * ${__dir_13794}; i_13794+=${__dir_13794} )); do
        local array_402=("${options_13788[${i_13794}]?"Index out of bounds (at src/./file/../choose/mod.ab:13:28)"}")
        result_13793+=("${array_402[@]}")
done
    ret_get_page_options2198_v0=("${result_13793[@]}")
    return 0
}

# render_choose_page(page_options: [Text], sel: Int, cursor: Text, display_count: Int, term_width: Int)
render_choose_page__2200_v0() {
    local page_options_13796=("${!1}")
    local sel_13797="${2}"
    local cursor_13798="${3}"
    local display_count_13799="${4}"
    local term_width_13800="${5}"
    local __length_403="${cursor_13798}"
    local cursor_len_13801="${#__length_403}"
    local max_option_width_13802="$(( $(( term_width_13800 - cursor_len_13801 )) - 1 ))"
    local __range_start_13803=0
    local __length_404=("${page_options_13796[@]}")
    local __range_end_13803="${#__length_404[@]}"
    local __dir_13803=$(( ${__range_start_13803} <= ${__range_end_13803} ? 1 : -1 ))
    for (( i_13803=${__range_start_13803}; i_13803 * ${__dir_13803} < ${__range_end_13803} * ${__dir_13803}; i_13803+=${__dir_13803} )); do
        cutoff_text__2147_v0 "${page_options_13796[${i_13803}]?"Index out of bounds (at src/./file/../choose/mod.ab:26:59)"}" "${max_option_width_13802}"
        local ret_cutoff_text2147_v0__26_34="${ret_cutoff_text2147_v0}"
        local truncated_option_13804="${ret_cutoff_text2147_v0__26_34}"
        if [ "$(( i_13803 == sel_13797 ))" != 0 ]; then
            colored_secondary__2110_v0 "${cursor_13798}""${truncated_option_13804}""
"
            local ret_colored_secondary2110_v0__28_21="${ret_colored_secondary2110_v0}"
            local array_405=("")
            eprintf__2127_v0 "${ret_colored_secondary2110_v0__28_21}" array_405[@]
        else
            print_blank__2133_v0 "${cursor_len_13801}"
            local array_406=("")
            eprintf__2127_v0 "${truncated_option_13804}""
" array_406[@]
        fi
done
    local __length_407=("${page_options_13796[@]}")
    local remaining_slots_13820="$(( display_count_13799 - ${#__length_407[@]} ))"
    if [ "$(( remaining_slots_13820 > 0 ))" != 0 ]; then
        # Amber bug gaurd
        local __range_start_13821=0
        local __range_end_13821="${remaining_slots_13820}"
        local __dir_13821=$(( ${__range_start_13821} <= ${__range_end_13821} ? 1 : -1 ))
        for (( ____13821=${__range_start_13821}; ____13821 * ${__dir_13821} < ${__range_end_13821} * ${__dir_13821}; ____13821+=${__dir_13821} )); do
            local array_408=("")
            eprintf__2127_v0 "\\x1b[K
" array_408[@]
done
    fi
}

# render_page_indicator(page: Int, total_pages: Int)
render_page_indicator__2202_v0() {
    local page_13831="${1}"
    local total_pages_13832="${2}"
    if [ "$(( total_pages_13832 > 1 ))" != 0 ]; then
        local array_409=("")
        eprintf__2127_v0 "\\x1b[G\\x1b[K" array_409[@]
        eprintf_colored__2128_v0 "Page $(( page_13831 + 1 ))/${total_pages_13832}" 90
        local array_410=("")
        eprintf__2127_v0 "\\x1b[G" array_410[@]
    fi
}

# xyl_choose(options: [Text], cursor: Text, header: Text, page_size: Int)
xyl_choose__2203_v0() {
    local options_13707=("${!1}")
    local cursor_13708="${2}"
    local header_13709="${3}"
    local page_size_13710="${4}"
    local __length_411=("${options_13707[@]}")
    if [ "$(( ${#__length_411[@]} == 0 ))" != 0 ]; then
        eprintf_colored__2128_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    stty_lock__2086_v0 
    hide_cursor__2138_v0 
    term_width__2093_v0 
    local term_width_13727="${ret_term_width2093_v0}"
    term_height__2094_v0 
    local term_height_13728="${ret_term_height2094_v0}"
    local max_page_size_13729
    max_page_size_13729="$(( term_height_13728 - $(if [ "$([ "_${header_13709}" != "_" ]; echo $?)" != 0 ]; then echo 2; else echo 3; fi) ))"
    if [ "$(( page_size_13710 > max_page_size_13729 ))" != 0 ]; then
        page_size_13710="${max_page_size_13729}"
    fi
    if [ "$([ "_${header_13709}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__2147_v0 "${header_13709}" "${term_width_13727}"
        local ret_cutoff_text2147_v0__107_17="${ret_cutoff_text2147_v0}"
        local array_412=("")
        eprintf__2127_v0 "${ret_cutoff_text2147_v0__107_17}""
" array_412[@]
    fi
    local __length_413=("${options_13707[@]}")
    math_floor__505_v0 "$(( $(( $(( ${#__length_413[@]} + page_size_13710 )) - 1 )) / page_size_13710 ))"
    local total_pages_13766="${ret_math_floor505_v0}"
    local current_page_13767=0
    local selected_13768=0
    local display_count_13769="${page_size_13710}"
    local __length_414=("${options_13707[@]}")
    if [ "$(( ${#__length_414[@]} < page_size_13710 ))" != 0 ]; then
        local __length_415=("${options_13707[@]}")
        display_count_13769="${#__length_415[@]}"
    fi
    new_line__2134_v0 "${display_count_13769}"
    local array_416=("")
    eprintf__2127_v0 "\\x1b[G" array_416[@]
    if [ "$(( total_pages_13766 > 1 ))" != 0 ]; then
        eprintf_colored__2128_v0 "Page $(( current_page_13767 + 1 ))/${total_pages_13766}" 90
    fi
    new_line__2134_v0 1
    # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
    # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    if [ "$(( total_pages_13766 > 1 ))" != 0 ]; then
        local array_417=("↑↓" "select" "←→" "page" "enter" "confirm")
        render_tooltip__2148_v0 array_417[@] 36 "${term_width_13727}"
    else
        local array_418=("↑↓" "select" "enter" "confirm")
        render_tooltip__2148_v0 array_418[@] 25 "${term_width_13727}"
    fi
    go_up__2135_v0 "$(( display_count_13769 + 1 ))"
    local array_419=("")
    eprintf__2127_v0 "\\x1b[G" array_419[@]
    get_page_options__2198_v0 options_13707[@] "${current_page_13767}" "${page_size_13710}"
    local page_options_13795=("${ret_get_page_options2198_v0[@]}")
    render_choose_page__2200_v0 page_options_13795[@] "${selected_13768}" "${cursor_13708}" "${display_count_13769}" "${term_width_13727}"
    while :
    do
        get_key__2125_v0 
        local key_13823="${ret_get_key2125_v0}"
        local prev_selected_13824="${selected_13768}"
        local prev_page_13825="${current_page_13767}"
        local up_paged_13826=0
        if [ "$(( $([ "_${key_13823}" != "_UP" ]; echo $?) || $([ "_${key_13823}" != "_k" ]; echo $?) ))" != 0 ]; then
            if [ "$(( $(( selected_13768 == 0 )) && $(( total_pages_13766 > 1 )) ))" != 0 ]; then
                if [ "$(( current_page_13767 > 0 ))" != 0 ]; then
                    current_page_13767="$(( current_page_13767 - 1 ))"
                else
                    current_page_13767="$(( total_pages_13766 - 1 ))"
                fi
                up_paged_13826=1
            elif [ "$(( selected_13768 == 0 ))" != 0 ]; then
                local __length_420=("${page_options_13795[@]}")
                selected_13768="$(( ${#__length_420[@]} - 1 ))"
            else
                selected_13768="$(( selected_13768 - 1 ))"
            fi
        elif [ "$(( $([ "_${key_13823}" != "_DOWN" ]; echo $?) || $([ "_${key_13823}" != "_j" ]; echo $?) ))" != 0 ]; then
            local __length_421=("${page_options_13795[@]}")
            if [ "$(( selected_13768 == $(( ${#__length_421[@]} - 1 )) ))" != 0 ]; then
                if [ "$(( current_page_13767 < $(( total_pages_13766 - 1 )) ))" != 0 ]; then
                    current_page_13767="$(( current_page_13767 + 1 ))"
                    selected_13768=0
                else
                    current_page_13767=0
                    selected_13768=0
                fi
            else
                selected_13768="$(( selected_13768 + 1 ))"
            fi
        elif [ "$(( $([ "_${key_13823}" != "_LEFT" ]; echo $?) || $([ "_${key_13823}" != "_h" ]; echo $?) ))" != 0 ]; then
            if [ "$(( current_page_13767 > 0 ))" != 0 ]; then
                current_page_13767="$(( current_page_13767 - 1 ))"
                selected_13768=0
            else
                selected_13768=0
            fi
        elif [ "$(( $([ "_${key_13823}" != "_RIGHT" ]; echo $?) || $([ "_${key_13823}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "$(( current_page_13767 < $(( total_pages_13766 - 1 )) ))" != 0 ]; then
                current_page_13767="$(( current_page_13767 + 1 ))"
                selected_13768=0
            else
                local __length_422=("${page_options_13795[@]}")
                selected_13768="$(( ${#__length_422[@]} - 1 ))"
            fi
        elif [ "$([ "_${key_13823}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
        local __length_423="${cursor_13708}"
        local max_option_width_13827="$(( $(( term_width_13727 - ${#__length_423} )) - 1 ))"
        if [ "$(( prev_page_13825 != current_page_13767 ))" != 0 ]; then
            get_page_options__2198_v0 options_13707[@] "${current_page_13767}" "${page_size_13710}"
            page_options_13795=("${ret_get_page_options2198_v0[@]}")
            if [ "${up_paged_13826}" != 0 ]; then
                local __length_424=("${page_options_13795[@]}")
                selected_13768="$(( ${#__length_424[@]} - 1 ))"
            fi
            go_up__2135_v0 1
            remove_line__2131_v0 "$(( display_count_13769 - 1 ))"
            remove_current_line__2132_v0 
            local array_425=("")
            eprintf__2127_v0 "\\x1b[G" array_425[@]
            render_choose_page__2200_v0 page_options_13795[@] "${selected_13768}" "${cursor_13708}" "${display_count_13769}" "${term_width_13727}"
            render_page_indicator__2202_v0 "${current_page_13767}" "${total_pages_13766}"
        elif [ "$(( prev_selected_13824 != selected_13768 ))" != 0 ]; then
            go_up__2135_v0 "$(( display_count_13769 - prev_selected_13824 ))"
            local array_426=("")
            eprintf__2127_v0 "\\x1b[K" array_426[@]
            local __length_427="${cursor_13708}"
            print_blank__2133_v0 "${#__length_427}"
            cutoff_text__2147_v0 "${page_options_13795[${prev_selected_13824}]?"Index out of bounds (at src/./file/../choose/mod.ab:218:50)"}" "${max_option_width_13827}"
            local ret_cutoff_text2147_v0__218_25="${ret_cutoff_text2147_v0}"
            local array_428=("")
            eprintf__2127_v0 "${ret_cutoff_text2147_v0__218_25}" array_428[@]
            local diff_13833="$(( selected_13768 - prev_selected_13824 ))"
            go_up_or_down__2137_v0 "${diff_13833}"
            local array_429=("")
            eprintf__2127_v0 "\\x1b[G" array_429[@]
            local array_430=("")
            eprintf__2127_v0 "\\x1b[K" array_430[@]
            cutoff_text__2147_v0 "${page_options_13795[${selected_13768}]?"Index out of bounds (at src/./file/../choose/mod.ab:224:77)"}" "${max_option_width_13827}"
            local ret_cutoff_text2147_v0__224_52="${ret_cutoff_text2147_v0}"
            colored_secondary__2110_v0 "${cursor_13708}""${ret_cutoff_text2147_v0__224_52}"
            local ret_colored_secondary2110_v0__224_25="${ret_colored_secondary2110_v0}"
            local array_431=("")
            eprintf__2127_v0 "${ret_colored_secondary2110_v0__224_25}" array_431[@]
            go_down__2136_v0 "$(( display_count_13769 - selected_13768 ))"
            local array_432=("")
            eprintf__2127_v0 "\\x1b[G" array_432[@]
        fi
    done
    local total_lines_13836="$(( display_count_13769 + 2 ))"
    if [ "$([ "_${header_13709}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_13836="$(( total_lines_13836 + 1 ))"
    fi
    go_down__2136_v0 1
    remove_line__2131_v0 "$(( total_lines_13836 - 1 ))"
    remove_current_line__2132_v0 
    stty_unlock__2087_v0 
    show_cursor__2139_v0 
    local global_selected_13839="$(( $(( current_page_13767 * page_size_13710 )) + selected_13768 ))"
    ret_xyl_choose2203_v0="${options_13707[${global_selected_13839}]?"Index out of bounds (at src/./file/../choose/mod.ab:244:20)"}"
    return 0
}

# format_entry_display(entry: [Text])
format_entry_display__2207_v0() {
    local entry_13700=("${!1}")
    local name_13701="${entry_13700[0]?"Index out of bounds (at src/./file/./mod.ab:10:24)"}"
    local file_type_13702="${entry_13700[1]?"Index out of bounds (at src/./file/./mod.ab:11:29)"}"
    if [ "$([ "_${file_type_13702}" != "_d" ]; echo $?)" != 0 ]; then
        colored_primary__1887_v0 "/"
        local ret_colored_primary1887_v0__14_23="${ret_colored_primary1887_v0}"
        ret_format_entry_display2207_v0="${name_13701}""${ret_colored_primary1887_v0__14_23}"
        return 0
    fi
    if [ "$([ "_${file_type_13702}" != "_l" ]; echo $?)" != 0 ]; then
        colored_accent__1889_v0 " > "
        local ret_colored_accent1889_v0__17_23="${ret_colored_accent1889_v0}"
        colored_primary__1887_v0 "${entry_13700[2]?"Index out of bounds (at src/./file/./mod.ab:17:69)"}"
        local ret_colored_primary1887_v0__17_47="${ret_colored_primary1887_v0}"
        ret_format_entry_display2207_v0="${name_13701}""${ret_colored_accent1889_v0__17_23}""${ret_colored_primary1887_v0__17_47}"
        return 0
    fi
    ret_format_entry_display2207_v0="${name_13701}"
    return 0
}

# xyl_file(start_path: Text, cursor: Text, show_hidden: Bool, page_size: Int)
xyl_file__2208_v0() {
    local start_path_13672="${1}"
    local cursor_13673="${2}"
    local show_hidden_13674="${3}"
    local page_size_13675="${4}"
    stty_lock__1864_v0 
    # Initialize current path
    local current_path_13678="${start_path_13672}"
    if [ "$([ "_${current_path_13678}" != "_" ]; echo $?)" != 0 ]; then
        get_cwd__1843_v0 
        current_path_13678="${ret_get_cwd1843_v0}"
    fi
    normalize_path__1844_v0 "${current_path_13678}"
    current_path_13678="${ret_normalize_path1844_v0}"
    while :
    do
        colored_primary__1887_v0 "Loading files..."
        local ret_colored_primary1887_v0__45_17="${ret_colored_primary1887_v0}"
        local array_433=("")
        eprintf__1905_v0 "${ret_colored_primary1887_v0__45_17}" array_433[@]
        # Get directory entries
        get_directory_entries__1841_v0 "${current_path_13678}"
        local raw_entries_13691=("${ret_get_directory_entries1841_v0[@]}")
        # Build options list and parallel entries list
        local options_13692=()
        local entries_13693=()
        # Add parent directory entry (..)
        if [ "$([ "_${current_path_13678}" == "_/" ]; echo $?)" != 0 ]; then
            options_13692+=("..")
            entries_13693+=("..	d")
        fi
        for raw_entry_13694 in "${raw_entries_13691[@]}"; do
            parse_entry__1842_v0 "${raw_entry_13694}"
            local entry_13696=("${ret_parse_entry1842_v0[@]}")
            local name_13697="${entry_13696[0]?"Index out of bounds (at src/./file/./mod.ab:62:32)"}"
            # Skip hidden files if not showing them
            starts_with__22_v0 "${name_13697}" "."
            local ret_starts_with22_v0__64_36="${ret_starts_with22_v0}"
            if [ "$(( $(( ! show_hidden_13674 )) && ret_starts_with22_v0__64_36 ))" != 0 ]; then
                continue
            fi
            format_entry_display__2207_v0 entry_13696[@]
            local ret_format_entry_display2207_v0__67_25="${ret_format_entry_display2207_v0}"
            options_13692+=("${ret_format_entry_display2207_v0__67_25}")
            entries_13693+=("${raw_entry_13694}")
        done
        local __length_442=("${entries_13693[@]}")
        if [ "$(( ${#__length_442[@]} == 0 ))" != 0 ]; then
            eprintf_colored__1906_v0 "ERROR: Directory is empty or inaccessible.
" 31
            stty_unlock__1865_v0 
            ret_xyl_file2208_v0=""
            return 0
        fi
        # Use xyl_choose with current path as header
        colored_primary__1887_v0 "${current_path_13678}"
        local header_13706="${ret_colored_primary1887_v0}"
        remove_current_line__1910_v0 
        xyl_choose__2203_v0 options_13692[@] "${cursor_13673}" "${header_13706}" "${page_size_13675}"
        local selected_option_13840="${ret_xyl_choose2203_v0}"
        # Find selected entry index
        array_find__67_v0 options_13692[@] "${selected_option_13840}"
        local selected_idx_13845="${ret_array_find67_v0}"
        if [ "$(( selected_idx_13845 < 0 ))" != 0 ]; then
            ret_xyl_file2208_v0=""
            return 0
        fi
        parse_entry__1842_v0 "${entries_13693[${selected_idx_13845}]?"Index out of bounds (at src/./file/./mod.ab:90:43)"}"
        local entry_13846=("${ret_parse_entry1842_v0[@]}")
        local name_13847="${entry_13846[0]?"Index out of bounds (at src/./file/./mod.ab:91:28)"}"
        local file_type_13848="${entry_13846[1]?"Index out of bounds (at src/./file/./mod.ab:92:33)"}"
        if [ "$([ "_${name_13847}" != "_.." ]; echo $?)" != 0 ]; then
            get_parent_dir__1846_v0 "${current_path_13678}"
            current_path_13678="${ret_get_parent_dir1846_v0}"
        elif [ "$([ "_${file_type_13848}" != "_d" ]; echo $?)" != 0 ]; then
            path_join__1845_v0 "${current_path_13678}" "${name_13847}"
            current_path_13678="${ret_path_join1845_v0}"
            normalize_path__1844_v0 "${current_path_13678}"
            current_path_13678="${ret_normalize_path1844_v0}"
        elif [ "$([ "_${file_type_13848}" != "_l" ]; echo $?)" != 0 ]; then
            # Resolve symlink target path
            local target_13853="${entry_13846[2]?"Index out of bounds (at src/./file/./mod.ab:104:38)"}"
            local target_path_13854="${target_13853}"
            starts_with__22_v0 "${target_13853}" "/"
            local ret_starts_with22_v0__106_24="${ret_starts_with22_v0}"
            if [ "$(( ! ret_starts_with22_v0__106_24 ))" != 0 ]; then
                path_join__1845_v0 "${current_path_13678}" "${target_13853}"
                target_path_13854="${ret_path_join1845_v0}"
            fi
            # Follow symlink if it points to a directory, otherwise return path
            dir_exists__38_v0 "${target_path_13854}"
            local ret_dir_exists38_v0__110_20="${ret_dir_exists38_v0}"
            if [ "${ret_dir_exists38_v0__110_20}" != 0 ]; then
                current_path_13678="${target_path_13854}"
                normalize_path__1844_v0 "${current_path_13678}"
                current_path_13678="${ret_normalize_path1844_v0}"
            else
                stty_unlock__1865_v0 
                path_join__1845_v0 "${current_path_13678}" "${name_13847}"
                ret_xyl_file2208_v0="${ret_path_join1845_v0}"
                return 0
            fi
        else
            stty_unlock__1865_v0 
            path_join__1845_v0 "${current_path_13678}" "${name_13847}"
            ret_xyl_file2208_v0="${ret_path_join1845_v0}"
            return 0
        fi
    done
    stty_unlock__1865_v0 
    ret_xyl_file2208_v0=""
    return 0
}

# print_file_help()
print_file_help__2301_v0() {
    echo "Usage: ./xylitol.sh file [<path>] [flags]"
    printf '%s\n' ""
    colored_primary__1887_v0 "file"
    local ret_colored_primary1887_v0__7_12="${ret_colored_primary1887_v0}"
    local array_443=()
    printf__128_v1 "${ret_colored_primary1887_v0__7_12}" array_443[@]
    local array_444=()
    printf__128_v1 " - Browse filesystem and select a file." array_444[@]
    printf '%s\n' ""
    printf '%s\n' ""
    colored_secondary__1888_v0 "Arguments: "
    local ret_colored_secondary1888_v0__11_12="${ret_colored_secondary1888_v0}"
    local array_445=()
    printf__128_v1 "${ret_colored_secondary1888_v0__11_12}""
" array_445[@]
    echo "  [<path>]               Starting directory path (default: current directory)"
    printf '%s\n' ""
    colored_secondary__1888_v0 "Flags: "
    local ret_colored_secondary1888_v0__14_12="${ret_colored_secondary1888_v0}"
    local array_446=()
    printf__128_v1 "${ret_colored_secondary1888_v0__14_12}""
" array_446[@]
    echo "  -h, --help             Show this help message"
    echo "  -a, --all              Show hidden files"
    echo "  --cursor=\"<text>\"      Set the cursor text (default: '> ')"
    echo "  --path=\"<path>\"        Set the starting directory path"
    echo "  --page-size=<number>   Set the number of entries per page (default: 10)"
    printf '%s\n' ""
}

# execute_file(parameters: [Text])
execute_file__2352_v0() {
    local parameters_13644=("${!1}")
    local cursor_13645="> "
    local start_path_13646=""
    local show_hidden_13647=0
    local page_size_13648=10
    local __length_450=("${parameters_13644[@]}")
    local slice_upper_449="${#__length_450[@]}"
    local slice_offset_451=2
    local slice_offset_451=$((${slice_offset_451} > 0 ? ${slice_offset_451} : 0))
    local slice_length_452="$(( slice_upper_449 - slice_offset_451 ))"
    local slice_length_452=$((${slice_length_452} > 0 ? ${slice_length_452} : 0))
    for param_13649 in "${parameters_13644[@]:${slice_offset_451}:${slice_length_452}}"; do
        match_regex__19_v0 "${param_13649}" "^-h\$" 0
        local ret_match_regex19_v0__14_13="${ret_match_regex19_v0}"
        match_regex__19_v0 "${param_13649}" "^--help\$" 0
        local ret_match_regex19_v0__14_43="${ret_match_regex19_v0}"
        match_regex__19_v0 "${param_13649}" "^--cursor=.*\$" 0
        local ret_match_regex19_v0__18_13="${ret_match_regex19_v0}"
        match_regex__19_v0 "${param_13649}" "^--path=.*\$" 0
        local ret_match_regex19_v0__22_13="${ret_match_regex19_v0}"
        match_regex__19_v0 "${param_13649}" "^-a\$" 0
        local ret_match_regex19_v0__26_13="${ret_match_regex19_v0}"
        match_regex__19_v0 "${param_13649}" "^--all\$" 0
        local ret_match_regex19_v0__26_43="${ret_match_regex19_v0}"
        match_regex__19_v0 "${param_13649}" "^--page-size=.*\$" 0
        local ret_match_regex19_v0__29_13="${ret_match_regex19_v0}"
        if [ "$(( ret_match_regex19_v0__14_13 || ret_match_regex19_v0__14_43 ))" != 0 ]; then
            print_file_help__2301_v0 
            exit 0
        elif [ "${ret_match_regex19_v0__18_13}" != 0 ]; then
            split__4_v0 "${param_13649}" "="
            local result_13665=("${ret_split4_v0[@]}")
            cursor_13645="${result_13665[1]?"Index out of bounds (at src/./file/exec.ab:20:33)"}"
        elif [ "${ret_match_regex19_v0__22_13}" != 0 ]; then
            split__4_v0 "${param_13649}" "="
            local result_13666=("${ret_split4_v0[@]}")
            start_path_13646="${result_13666[1]?"Index out of bounds (at src/./file/exec.ab:24:37)"}"
        elif [ "$(( ret_match_regex19_v0__26_13 || ret_match_regex19_v0__26_43 ))" != 0 ]; then
            show_hidden_13647=1
        elif [ "${ret_match_regex19_v0__29_13}" != 0 ]; then
            split__4_v0 "${param_13649}" "="
            local result_13667=("${ret_split4_v0[@]}")
            parse_int__13_v0 "${result_13667[1]?"Index out of bounds (at src/./file/exec.ab:31:46)"}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1906_v0 "ERROR: Invalid page-size value: ""${result_13667[1]?"Index out of bounds (at src/./file/exec.ab:32:81)"}""
" 31
                exit 1
            fi
            page_size_13648="${ret_parse_int13_v0}"
        else
            # Treat as start path if not a flag
            start_path_13646="${param_13649}"
        fi
    done
    xyl_file__2208_v0 "${start_path_13646}" "${cursor_13645}" "${show_hidden_13647}" "${page_size_13648}"
    ret_execute_file2352_v0="${ret_xyl_file2208_v0}"
    return 0
}

# #!/usr/bin/env amber
__VERSION_57="0.1.0"
__AMBER_VERSION_58="0.6.0-alpha"
# check_prerequirements()
check_prerequirements__2354_v0() {
    echo "0" | bc -l > /dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        eprintf_colored__262_v0 "Error: " 91
        local array_453=("")
        eprintf__261_v0 "bc is not installed. Please install bc to use xylitol.
" array_453[@]
        local array_454=("")
        eprintf__261_v0 "  For Debian/Ubuntu: sudo apt install bc
" array_454[@]
        local array_455=("")
        eprintf__261_v0 "  For Fedora: sudo dnf install bc
" array_455[@]
        local array_456=("")
        eprintf__261_v0 "  For Arch Linux: sudo pacman -S bc
" array_456[@]
        ret_check_prerequirements2354_v0=0
        return 0
    fi
    ret_check_prerequirements2354_v0=1
    return 0
}

# trap_cleanup()
trap_cleanup__2355_v0() {
    trap 'printf "\x1b[?25h\x1b[0m" >&2; 
            stty echo < /dev/tty' EXIT
    __status=$?
}

typeset -r args_59=("$0" "$@")
trap_cleanup__2355_v0 
check_prerequirements__2354_v0 
ret_check_prerequirements2354_v0__32_12="${ret_check_prerequirements2354_v0}"
if [ "$(( ! ret_check_prerequirements2354_v0__32_12 ))" != 0 ]; then
    exit 1
fi
# `args[1]` must not be read before the length is checked,
# because `or` evaluates both of its operands.
__length_458=("${args_59[@]}")
if [ "$(( ${#__length_458[@]} < 2 ))" != 0 ]; then
    print_help__424_v0 
    exit 0
fi
command_664="${args_59[1]?"Index out of bounds (at src/main.ab:41:26)"}"
if [ "$(( $(( $([ "_${command_664}" != "_help" ]; echo $?) || $([ "_${command_664}" != "_--help" ]; echo $?) )) || $([ "_${command_664}" != "_-h" ]; echo $?) ))" != 0 ]; then
    print_help__424_v0 
elif [ "$([ "_${command_664}" != "_input" ]; echo $?)" != 0 ]; then
    execute_input__832_v0 args_59[@]
    ret_execute_input832_v0__48_18="${ret_execute_input832_v0}"
    printf '%s\n' "${ret_execute_input832_v0__48_18}"
elif [ "$([ "_${command_664}" != "_choose" ]; echo $?)" != 0 ]; then
    execute_choose__1244_v0 args_59[@]
    ret_execute_choose1244_v0__51_18="${ret_execute_choose1244_v0}"
    printf '%s\n' "${ret_execute_choose1244_v0__51_18}"
elif [ "$([ "_${command_664}" != "_confirm" ]; echo $?)" != 0 ]; then
    execute_confirm__1686_v0 args_59[@]
    result_9879="${ret_execute_confirm1686_v0}"
    if [ "$([ "_${result_9879}" != "_yes" ]; echo $?)" != 0 ]; then
        exit 0
    else
        exit 1
    fi
elif [ "$([ "_${command_664}" != "_file" ]; echo $?)" != 0 ]; then
    execute_file__2352_v0 args_59[@]
    ret_execute_file2352_v0__61_18="${ret_execute_file2352_v0}"
    printf '%s\n' "${ret_execute_file2352_v0__61_18}"
elif [ "$(( $(( $([ "_${command_664}" != "_version" ]; echo $?) || $([ "_${command_664}" != "_--version" ]; echo $?) )) || $([ "_${command_664}" != "_-v" ]; echo $?) ))" != 0 ]; then
    colored_primary__243_v0 "xylitol.sh"
    ret_colored_primary243_v0__64_20="${ret_colored_primary243_v0}"
    array_459=()
    printf__128_v1 "${ret_colored_primary243_v0__64_20}" array_459[@]
    array_460=()
    printf__128_v1 " version: " array_460[@]
    colored_accent__245_v0 "${__VERSION_57}"
    ret_colored_accent245_v0__66_20="${ret_colored_accent245_v0}"
    array_461=()
    printf__128_v1 "${ret_colored_accent245_v0__66_20}" array_461[@]
    printf '%s\n' ""
    printf_colored__260_v0 "written in Amber: " 90
    printf_colored__260_v0 "  ""${__AMBER_VERSION_58}" 90
else
    print_help__424_v0 
    printf_colored__260_v0 "ERROR: Unknown command '""${command_664}""'" 91
fi
