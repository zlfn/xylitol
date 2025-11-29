#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: 0.5.0-alpha
# We cannot import `bash_version` from `env.ab` because it imports `text.ab` making a circular dependency.
# This is a workaround to avoid that issue and the import system should be improved in the future.
bash_version__0_v0() {
    major_77="$(echo "${BASH_VERSINFO[0]}")"
    minor_78="$(echo "${BASH_VERSINFO[1]}")"
    patch_79="$(echo "${BASH_VERSINFO[2]}")"
    ret_bash_version0_v0=("${major_77}" "${minor_78}" "${patch_79}")
    return 0
}

replace__1_v0() {
    local source=$1
    local search=$2
    local replace=$3
    # Here we use a command to avoid #646
    result_76=""
    bash_version__0_v0 
    left_comp=("${ret_bash_version0_v0[@]}")
    right_comp=(4 3)
    comp="$(
        # Compare if left array >= right array
        len_comp="$( (( "${#left_comp[@]}" < "${#right_comp[@]}" )) && echo "${#left_comp[@]}"|| echo "${#right_comp[@]}")"
        for (( i=0; i<len_comp; i++ )); do
            left="${left_comp[i]:-0}"
            right="${right_comp[i]:-0}"
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
    if [ "${comp}" != 0 ]; then
        result_76="${source//"${search}"/"${replace}"}"
    else
        result_76="${source//"${search}"/${replace}}"
    fi
    ret_replace1_v0="${result_76}"
    return 0
}

__SED_VERSION_UNKNOWN_1=0
__SED_VERSION_GNU_2=1
__SED_VERSION_BUSYBOX_3=2
sed_version__3_v0() {
    # We can't match against a word "GNU" because
    # alpine's busybox sed returns "This is not GNU sed version"
    re='\bCopyright\b.+\bFree Software Foundation\b'; [[ $(sed --version 2>/dev/null) =~ $re ]]
    __status=$?
    if [ "$(( ${__status} == 0 ))" != 0 ]; then
        ret_sed_version3_v0="${__SED_VERSION_GNU_2}"
        return 0
    fi
    # On BSD single `sed` waits for stdin. We must use `sed --help` to avoid this.
    re='\bBusyBox\b'; [[ $(sed --help 2>&1) =~ $re ]]
    __status=$?
    if [ "$(( ${__status} == 0 ))" != 0 ]; then
        ret_sed_version3_v0="${__SED_VERSION_BUSYBOX_3}"
        return 0
    fi
    ret_sed_version3_v0="${__SED_VERSION_UNKNOWN_1}"
    return 0
}

split__5_v0() {
    local text=$1
    local delimiter=$2
    result_62=()
    IFS="${delimiter}" read -rd '' -a result_62 < <(printf %s "$text")
    __status=$?
    ret_split5_v0=("${result_62[@]}")
    return 0
}

join__8_v0() {
    local list=("${!1}")
    local delimiter=$2
    command_6="$(IFS="${delimiter}" ; echo "${list[*]}")"
    __status=$?
    ret_join8_v0="${command_6}"
    return 0
}

parse_int__14_v0() {
    local text=$1
    [ -n "${text}" ] && [ "${text}" -eq "${text}" ] 2>/dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_parse_int14_v0=''
        return "${__status}"
    fi
    ret_parse_int14_v0="${text}"
    return 0
}

match_regex__20_v0() {
    local source=$1
    local search=$2
    local extended=$3
    sed_version__3_v0 
    sed_version_75="${ret_sed_version3_v0}"
    replace__1_v0 "${search}" "/" "\\/"
    search="${ret_replace1_v0}"
    output_80=""
    if [ "$(( $(( ${sed_version_75} == ${__SED_VERSION_GNU_2} )) || $(( ${sed_version_75} == ${__SED_VERSION_BUSYBOX_3} )) ))" != 0 ]; then
        # '\b' is supported but not in POSIX standards. Disable it
        replace__1_v0 "${search}" "\\b" "\\\\b"
        search="${ret_replace1_v0}"
    fi
    if [ "${extended}" != 0 ]; then
        # GNU sed versions 4.0 through 4.2 support extended regex syntax,
        # but only via the "-r" option
        if [ "$(( ${sed_version_75} == ${__SED_VERSION_GNU_2} ))" != 0 ]; then
            # '\b' is not in POSIX standards. Disable it
            replace__1_v0 "${search}" "\\b" "\\b"
            search="${ret_replace1_v0}"
            command_7="$(echo "${source}" | sed -r -ne "/${search}/p")"
            __status=$?
            output_80="${command_7}"
        else
            command_8="$(echo "${source}" | sed -E -ne "/${search}/p")"
            __status=$?
            output_80="${command_8}"
        fi
    else
        if [ "$(( $(( ${sed_version_75} == ${__SED_VERSION_GNU_2} )) || $(( ${sed_version_75} == ${__SED_VERSION_BUSYBOX_3} )) ))" != 0 ]; then
            # GNU Sed BRE handle \| as a metacharacter, but it is not POSIX standands. Disable it
            replace__1_v0 "${search}" "\\|" "|"
            search="${ret_replace1_v0}"
        fi
        command_9="$(echo "${source}" | sed -ne "/${search}/p")"
        __status=$?
        output_80="${command_9}"
    fi
    if [ "$([ "_${output_80}" == "_" ]; echo $?)" != 0 ]; then
        ret_match_regex20_v0=1
        return 0
    fi
    ret_match_regex20_v0=0
    return 0
}

starts_with__23_v0() {
    local text=$1
    local prefix=$2
    command_10="$(if [[ "${text}" == "${prefix}"* ]]; then
    echo 1
  fi)"
    __status=$?
    result_471="${command_10}"
    ret_starts_with23_v0="$([ "_${result_471}" != "_1" ]; echo $?)"
    return 0
}

env_var_get__98_v0() {
    local name=$1
    command_11="$(echo ${!name})"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_env_var_get98_v0=''
        return "${__status}"
    fi
    ret_env_var_get98_v0="${command_11}"
    return 0
}

printf__106_v0() {
    local format=$1
    local args=("${!2}")
    args=("${format}" "${args[@]}")
    __status=$?
    printf "${args[@]}"
    __status=$?
}

echo_colored__112_v0() {
    local message=$1
    local color=$2
    array_12=("${message}")
    printf__106_v0 "\\x1b[${color}m%s\\x1b[0m
" array_12[@]
}

# Perl Extensions Utilities
command_13="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_4="$([ "_${command_13}" != "_No" ]; echo $?)"
command_14="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_5="$(( $(( ! ${_perl_disabled_4} )) && $([ "_${command_14}" != "_0" ]; echo $?) ))"
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
_supports_truecolor_8="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_9=0
_primary_color_10=(3 207 159 92)
_secondary_color_11=(3 118 206 94)
_accent_color_12=(234 72 121 95)
get_supports_truecolor__189_v0() {
    env_var_get__98_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    config_68="${ret_env_var_get98_v0}"
    if [ "$([ "_${config_68}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_8="No"
        ret_get_supports_truecolor189_v0=0
        return 0
    fi
    env_var_get__98_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_8="No"
        ret_get_supports_truecolor189_v0=0
        return 0
    fi
    colorterm_69="${ret_env_var_get98_v0}"
    _supports_truecolor_8="$(if [ "$(( $([ "_${colorterm_69}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_69}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor189_v0="$([ "_${_supports_truecolor_8}" != "_Yes" ]; echo $?)"
    return 0
}

colored_rgb__190_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    if [ "$([ "_${_supports_truecolor_8}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb190_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_8}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__189_v0 
        ret_get_supports_truecolor189_v0__50_17="${ret_get_supports_truecolor189_v0}"
        if [ "${ret_get_supports_truecolor189_v0__50_17}" != 0 ]; then
            ret_colored_rgb190_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
            return 0
        elif [ "$(( ${fallback} == 0 ))" != 0 ]; then
            ret_colored_rgb190_v0="${message}"
            return 0
        else
            ret_colored_rgb190_v0="\\x1b[${fallback}m""${message}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( ${fallback} == 0 ))" != 0 ]; then
            ret_colored_rgb190_v0="${message}"
            return 0
        fi
        ret_colored_rgb190_v0="\\x1b[${fallback}m""${message}""\\x1b[0m"
        return 0
    fi
}

inner_get_xylitol_colors__192_v0() {
    if [ "$(( ! ${_got_xylitol_colors_9} ))" != 0 ]; then
        env_var_get__98_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        primary_env_61="${ret_env_var_get98_v0}"
        if [ "$([ "_${primary_env_61}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${primary_env_61}" ";"
            parts_63=("${ret_split5_v0[@]}")
            __length_19=("${parts_63[@]}")
            if [ "$(( ${#__length_19[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_63[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors192_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__115_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_63[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors192_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__116_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_63[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors192_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__117_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_63[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors192_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__118_21="${ret_parse_int14_v0}"
                _primary_color_10=("${ret_parse_int14_v0__115_21}" "${ret_parse_int14_v0__116_21}" "${ret_parse_int14_v0__117_21}" "${ret_parse_int14_v0__118_21}")
            fi
        fi
        env_var_get__98_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        secondary_env_64="${ret_env_var_get98_v0}"
        if [ "$([ "_${secondary_env_64}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${secondary_env_64}" ";"
            parts_65=("${ret_split5_v0[@]}")
            __length_21=("${parts_65[@]}")
            if [ "$(( ${#__length_21[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_65[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors192_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__128_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_65[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors192_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__129_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_65[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors192_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__130_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_65[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors192_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__131_21="${ret_parse_int14_v0}"
                _secondary_color_11=("${ret_parse_int14_v0__128_21}" "${ret_parse_int14_v0__129_21}" "${ret_parse_int14_v0__130_21}" "${ret_parse_int14_v0__131_21}")
            fi
        fi
        env_var_get__98_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        accent_env_66="${ret_env_var_get98_v0}"
        if [ "$([ "_${accent_env_66}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${accent_env_66}" ";"
            parts_67=("${ret_split5_v0[@]}")
            __length_23=("${parts_67[@]}")
            if [ "$(( ${#__length_23[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_67[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors192_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__141_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_67[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors192_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__142_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_67[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors192_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__143_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_67[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors192_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__144_21="${ret_parse_int14_v0}"
                _accent_color_12=("${ret_parse_int14_v0__141_21}" "${ret_parse_int14_v0__142_21}" "${ret_parse_int14_v0__143_21}" "${ret_parse_int14_v0__144_21}")
            fi
        fi
        _got_xylitol_colors_9=1
    fi
}

get_xylitol_colors__193_v0() {
    inner_get_xylitol_colors__192_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__112_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_9=1
}

colored_primary__194_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_9} ))" != 0 ]; then
        get_xylitol_colors__193_v0 
    fi
    colored_rgb__190_v0 "${message}" "${_primary_color_10[0]}" "${_primary_color_10[1]}" "${_primary_color_10[2]}" "${_primary_color_10[3]}"
    ret_colored_primary194_v0="${ret_colored_rgb190_v0}"
    return 0
}

colored_secondary__195_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_9} ))" != 0 ]; then
        get_xylitol_colors__193_v0 
    fi
    colored_rgb__190_v0 "${message}" "${_secondary_color_11[0]}" "${_secondary_color_11[1]}" "${_secondary_color_11[2]}" "${_secondary_color_11[3]}"
    ret_colored_secondary195_v0="${ret_colored_rgb190_v0}"
    return 0
}

colored_accent__196_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_9} ))" != 0 ]; then
        get_xylitol_colors__193_v0 
    fi
    colored_rgb__190_v0 "${message}" "${_accent_color_12[0]}" "${_accent_color_12[1]}" "${_accent_color_12[2]}" "${_accent_color_12[3]}"
    ret_colored_accent196_v0="${ret_colored_rgb190_v0}"
    return 0
}

# // IO Functions /////
printf_colored__211_v0() {
    local message=$1
    local color=$2
    # Prints a text with a specified color.
    array_25=("${message}")
    printf__106_v0 "\\x1b[${color}m%s\\x1b[0m" array_25[@]
}

eprintf__212_v0() {
    local format=$1
    local args=("${!2}")
    args=("${format}" "${args[@]}")
    __status=$?
    printf "${args[@]}" >&2
    __status=$?
}

eprintf_colored__213_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    array_26=("${message}")
    eprintf__212_v0 "\\x1b[${color}m%s\\x1b[0m" array_26[@]
}

colored__214_v0() {
    local message=$1
    local color=$2
    # Returns a text wrapped in color codes.
    ret_colored214_v0="\\x1b[${color}m""${message}""\\x1b[0m"
    return 0
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# // Application Utilities /////
print_help__358_v0() {
    echo "Usage: ./xylitol.sh <command> [flags]"
    echo ""
    colored_primary__194_v0 "Xylitol"
    ret_colored_primary194_v0__7_24="${ret_colored_primary194_v0}"
    array_27=("")
    printf__106_v0 "\\x1b[1m""${ret_colored_primary194_v0__7_24}" array_27[@]
    array_28=("")
    printf__106_v0 " - A tool for " array_28[@]
    colored_primary__194_v0 "fresh"
    ret_colored_primary194_v0__9_12="${ret_colored_primary194_v0}"
    array_29=("")
    printf__106_v0 "${ret_colored_primary194_v0__9_12}" array_29[@]
    array_30=("")
    printf__106_v0 " shell scripts." array_30[@]
    echo ""
    echo ""
    colored_secondary__195_v0 "Flags: "
    ret_colored_secondary195_v0__13_12="${ret_colored_secondary195_v0}"
    array_31=("")
    printf__106_v0 "${ret_colored_secondary195_v0__13_12}""
" array_31[@]
    echo "  -h, --help        Show this help message"
    echo "  -v, --version     Show version information"
    echo ""
    colored_secondary__195_v0 "Commands: "
    ret_colored_secondary195_v0__17_12="${ret_colored_secondary195_v0}"
    array_32=("")
    printf__106_v0 "${ret_colored_secondary195_v0__17_12}""
" array_32[@]
    echo "  input             Prompt for some input"
    echo "  choose            Choose from a list of options"
    echo "  confirm           Prompt for a yes/no confirmation"
    echo "  file              Browse filesystem and select a file"
    echo ""
    colored_secondary__195_v0 "Envs: "
    ret_colored_secondary195_v0__23_12="${ret_colored_secondary195_v0}"
    array_33=("")
    printf__106_v0 "${ret_colored_secondary195_v0__23_12}""
" array_33[@]
    colored__214_v0 "(\"Yes\" or \"No\", default: Yes)" 90
    ret_colored214_v0__24_78="${ret_colored214_v0}"
    array_34=("")
    printf__106_v0 "  \$XYLITOL_USE_PERL          Use Perl for CJK / Optimization ""${ret_colored214_v0__24_78}""
" array_34[@]
    colored__214_v0 "(\"Yes\" or \"No\", default: Yes)" 90
    ret_colored214_v0__25_78="${ret_colored214_v0}"
    array_35=("")
    printf__106_v0 "  \$XYLITOL_TRUECOLOR         Enable 24-bit truecolor support ""${ret_colored214_v0__25_78}""
" array_35[@]
    colored__214_v0 "(default: 3;207;159;92)" 90
    ret_colored214_v0__26_68="${ret_colored214_v0}"
    array_36=("")
    printf__106_v0 "  \$XYLITOL_PRIMARY_COLOR     Set the primary color ""${ret_colored214_v0__26_68}""
" array_36[@]
    colored__214_v0 "(default: 3;118;206;94)" 90
    ret_colored214_v0__27_70="${ret_colored214_v0}"
    array_37=("")
    printf__106_v0 "  \$XYLITOL_SECONDARY_COLOR   Set the secondary color ""${ret_colored214_v0__27_70}""
" array_37[@]
    colored__214_v0 "(default: 234;72;121;95)" 90
    ret_colored214_v0__28_67="${ret_colored214_v0}"
    array_38=("")
    printf__106_v0 "  \$XYLITOL_ACCENT_COLOR      Set the accent color ""${ret_colored214_v0__28_67}""
" array_38[@]
    echo ""
    colored_accent__196_v0 "./xylitol.sh <command> --help"
    ret_colored_accent196_v0__30_21="${ret_colored_accent196_v0}"
    array_39=("")
    printf__106_v0 "Run ""${ret_colored_accent196_v0__30_21}"" for more information on a command.
" array_39[@]
}

math_floor__416_v0() {
    local number=$1
    command_40="$(echo "${number}" | awk '{printf "%d", ($1 < 0 ? int($1) - 1 : int($1))}')"
    __status=$?
    ret_math_floor416_v0="${command_40}"
    return 0
}

math_ceil__417_v0() {
    local number=$1
    math_floor__416_v0 "${number}"
    ret_math_floor416_v0__52_12="${ret_math_floor416_v0}"
    ret_math_ceil417_v0="$(( ${ret_math_floor416_v0__52_12} + 1 ))"
    return 0
}

# Perl Extensions Utilities
command_41="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_13="$([ "_${command_41}" != "_No" ]; echo $?)"
command_42="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_14="$(( $(( ! ${_perl_disabled_13} )) && $([ "_${command_42}" != "_0" ]; echo $?) ))"
perl_get_cjk_width__472_v0() {
    local text=$1
    if [ "$(( ! ${_perl_available_14} ))" != 0 ]; then
        ret_perl_get_cjk_width472_v0=''
        return 1
    fi
    command_43="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width472_v0=''
        return "${__status}"
    fi
    width_str_103="${command_43}"
    parse_int__14_v0 "${width_str_103}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width472_v0=''
        return "${__status}"
    fi
    width_104="${ret_parse_int14_v0}"
    ret_perl_get_cjk_width472_v0="${width_104}"
    return 0
}

perl_truncate_cjk__473_v0() {
    local text=$1
    local max_width=$2
    if [ "$(( ! ${_perl_available_14} ))" != 0 ]; then
        ret_perl_truncate_cjk473_v0=''
        return 1
    fi
    command_44="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text}" ${max_width} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk473_v0=''
        return "${__status}"
    fi
    result_107="${command_44}"
    ret_perl_truncate_cjk473_v0="${result_107}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
stty_lock__480_v0() {
    command_46="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_94="${command_46}"
    parse_int__14_v0 "${count_94}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_95="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_95} == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_95="$(( ${count_num_95} + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_95}
    __status=$?
}

stty_unlock__481_v0() {
    command_47="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_137="${command_47}"
    parse_int__14_v0 "${count_137}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_138="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_138} > 0 ))" != 0 ]; then
        count_num_138="$(( ${count_num_138} - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_138}
        __status=$?
        if [ "$(( ${count_num_138} == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

get_term_size__482_v0() {
    # Query terminal size with \x1b[18t, response format: \x1b[8;rows;colst
    command_48="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -rsd t _ignore height width < /dev/tty; echo "$height; $width")"
    __status=$?
    result_96="${command_48}"
    split__5_v0 "${result_96}" ";"
    parts_97=("${ret_split5_v0[@]}")
    __length_49=("${parts_97[@]}")
    if [ "$(( ${#__length_49[@]} != 2 ))" != 0 ]; then
        ret_get_term_size482_v0=''
        return 1
    fi
    parse_int__14_v0 "${parts_97[0]}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_term_size482_v0=''
        return "${__status}"
    fi
    rows_98="${ret_parse_int14_v0}"
    parse_int__14_v0 "${parts_97[1]}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_term_size482_v0=''
        return "${__status}"
    fi
    cols_99="${ret_parse_int14_v0}"
    _term_size_16=("${cols_99}" "${rows_98}")
    _got_term_size_15=1
}

term_width__484_v0() {
    if [ "$([ "_$(( ! ${_got_term_size_15} ))" != "_0" ]; echo $?)" != 0 ]; then
        get_term_size__482_v0 
        __status=$?
    fi
    ret_term_width484_v0="${_term_size_16[0]}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_17="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_18=0
_primary_color_19=(3 207 159 92)
_secondary_color_20=(3 118 206 94)
get_supports_truecolor__495_v0() {
    env_var_get__98_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    config_87="${ret_env_var_get98_v0}"
    if [ "$([ "_${config_87}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_17="No"
        ret_get_supports_truecolor495_v0=0
        return 0
    fi
    env_var_get__98_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_17="No"
        ret_get_supports_truecolor495_v0=0
        return 0
    fi
    colorterm_88="${ret_env_var_get98_v0}"
    _supports_truecolor_17="$(if [ "$(( $([ "_${colorterm_88}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_88}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor495_v0="$([ "_${_supports_truecolor_17}" != "_Yes" ]; echo $?)"
    return 0
}

colored_rgb__496_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    if [ "$([ "_${_supports_truecolor_17}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb496_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_17}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__495_v0 
        ret_get_supports_truecolor495_v0__50_17="${ret_get_supports_truecolor495_v0}"
        if [ "${ret_get_supports_truecolor495_v0__50_17}" != 0 ]; then
            ret_colored_rgb496_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
            return 0
        elif [ "$(( ${fallback} == 0 ))" != 0 ]; then
            ret_colored_rgb496_v0="${message}"
            return 0
        else
            ret_colored_rgb496_v0="\\x1b[${fallback}m""${message}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( ${fallback} == 0 ))" != 0 ]; then
            ret_colored_rgb496_v0="${message}"
            return 0
        fi
        ret_colored_rgb496_v0="\\x1b[${fallback}m""${message}""\\x1b[0m"
        return 0
    fi
}

inner_get_xylitol_colors__498_v0() {
    if [ "$(( ! ${_got_xylitol_colors_18} ))" != 0 ]; then
        env_var_get__98_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        primary_env_81="${ret_env_var_get98_v0}"
        if [ "$([ "_${primary_env_81}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${primary_env_81}" ";"
            parts_82=("${ret_split5_v0[@]}")
            __length_54=("${parts_82[@]}")
            if [ "$(( ${#__length_54[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_82[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors498_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__115_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_82[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors498_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__116_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_82[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors498_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__117_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_82[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors498_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__118_21="${ret_parse_int14_v0}"
                _primary_color_19=("${ret_parse_int14_v0__115_21}" "${ret_parse_int14_v0__116_21}" "${ret_parse_int14_v0__117_21}" "${ret_parse_int14_v0__118_21}")
            fi
        fi
        env_var_get__98_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        secondary_env_83="${ret_env_var_get98_v0}"
        if [ "$([ "_${secondary_env_83}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${secondary_env_83}" ";"
            parts_84=("${ret_split5_v0[@]}")
            __length_56=("${parts_84[@]}")
            if [ "$(( ${#__length_56[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_84[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors498_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__128_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_84[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors498_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__129_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_84[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors498_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__130_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_84[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors498_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__131_21="${ret_parse_int14_v0}"
                _secondary_color_20=("${ret_parse_int14_v0__128_21}" "${ret_parse_int14_v0__129_21}" "${ret_parse_int14_v0__130_21}" "${ret_parse_int14_v0__131_21}")
            fi
        fi
        env_var_get__98_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        accent_env_85="${ret_env_var_get98_v0}"
        if [ "$([ "_${accent_env_85}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${accent_env_85}" ";"
            parts_86=("${ret_split5_v0[@]}")
            __length_58=("${parts_86[@]}")
            if [ "$(( ${#__length_58[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_86[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors498_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__141_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_86[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors498_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__142_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_86[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors498_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__143_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_86[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors498_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__144_21="${ret_parse_int14_v0}"
            fi
        fi
        _got_xylitol_colors_18=1
    fi
}

get_xylitol_colors__499_v0() {
    inner_get_xylitol_colors__498_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__112_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_18=1
}

colored_primary__500_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_18} ))" != 0 ]; then
        get_xylitol_colors__499_v0 
    fi
    colored_rgb__496_v0 "${message}" "${_primary_color_19[0]}" "${_primary_color_19[1]}" "${_primary_color_19[2]}" "${_primary_color_19[3]}"
    ret_colored_primary500_v0="${ret_colored_rgb496_v0}"
    return 0
}

colored_secondary__501_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_18} ))" != 0 ]; then
        get_xylitol_colors__499_v0 
    fi
    colored_rgb__496_v0 "${message}" "${_secondary_color_20[0]}" "${_secondary_color_20[1]}" "${_secondary_color_20[2]}" "${_secondary_color_20[3]}"
    ret_colored_secondary501_v0="${ret_colored_rgb496_v0}"
    return 0
}

# // IO Functions /////
get_char__515_v0() {
    command_60="$(read -n 1 key < /dev/tty; printf "%s" "$key")"
    __status=$?
    char_134="${command_60}"
    ret_get_char515_v0="${char_134}"
    return 0
}

eprintf__518_v0() {
    local format=$1
    local args=("${!2}")
    args=("${format}" "${args[@]}")
    __status=$?
    printf "${args[@]}" >&2
    __status=$?
}

eprintf_colored__519_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    array_61=("${message}")
    eprintf__518_v0 "\\x1b[${color}m%s\\x1b[0m" array_61[@]
}

colored__520_v0() {
    local message=$1
    local color=$2
    # Returns a text wrapped in color codes.
    ret_colored520_v0="\\x1b[${color}m""${message}""\\x1b[0m"
    return 0
}

remove__521_v0() {
    local cnt=$1
    printf '%0.s\b \b' $(seq 1 ${cnt}) >&2
    __status=$?
}

remove_line__522_v0() {
    local cnt=$1
    printf '\x1b[2K\x1b[1A%.0s' $(seq ${cnt}) >&2
    __status=$?
    array_62=("")
    eprintf__518_v0 "\\x1b[9999D" array_62[@]
}

remove_current_line__523_v0() {
    array_63=("")
    eprintf__518_v0 "\\x1b[2K\\x1b[9999D" array_63[@]
}

new_line__525_v0() {
    local cnt=$1
    from=0
    to="${cnt}"
    for i_123 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        array_64=("")
        eprintf__518_v0 "
" array_64[@]
    done
}

go_up__526_v0() {
    local cnt=$1
    array_65=("")
    eprintf__518_v0 "\\x1b[${cnt}A" array_65[@]
}

go_down__527_v0() {
    local cnt=$1
    array_66=("")
    eprintf__518_v0 "\\x1b[${cnt}B" array_66[@]
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
has_ansi_escape__531_v0() {
    local text=$1
    # Check for ESC character (0x1B = 27) or literal \x1b[
    command_67="$([[ "${text}" == *$'\x1b'* || "${text}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    has_escape_92="${command_67}"
    ret_has_ansi_escape531_v0="$([ "_${has_escape_92}" != "_1" ]; echo $?)"
    return 0
}

escape_ansi__532_v0() {
    local text=$1
    command_68="$(printf '%s' "${text}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi532_v0="${command_68}"
    return 0
}

strip_ansi__533_v0() {
    local text=$1
    command_69="$(printf "%s" "${text}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi533_v0="${command_69}"
    return 0
}

is_all_ascii__534_v0() {
    local text=$1
    command_70="$(printf "%s" "${text}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    result_102="${command_70}"
    ret_is_all_ascii534_v0="$([ "_${result_102}" != "_0" ]; echo $?)"
    return 0
}

get_visible_len__535_v0() {
    local text=$1
    strip_ansi__533_v0 "${text}"
    stripped_101="${ret_strip_ansi533_v0}"
    # Check if text is all ASCII
    is_all_ascii__534_v0 "${stripped_101}"
    ret_is_all_ascii534_v0__140_12="${ret_is_all_ascii534_v0}"
    if [ "$(( ! ${ret_is_all_ascii534_v0__140_12} ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__472_v0 "${stripped_101}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            __length_71="${stripped_101}"
            ret_get_visible_len535_v0="${#__length_71}"
            return 0
        fi
        ret_get_visible_len535_v0="${ret_perl_get_cjk_width472_v0}"
        return 0
    else
        __length_72="${stripped_101}"
        ret_get_visible_len535_v0="${#__length_72}"
        return 0
    fi
}

truncate_text__536_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__535_v0 "${text}"
    visible_len_106="${ret_get_visible_len535_v0}"
    if [ "$(( ${visible_len_106} <= ${max_width} ))" != 0 ]; then
        ret_truncate_text536_v0="${text}"
        return 0
    fi
    is_all_ascii__534_v0 "${text}"
    ret_is_all_ascii534_v0__157_12="${ret_is_all_ascii534_v0}"
    if [ "$(( ! ${ret_is_all_ascii534_v0__157_12} ))" != 0 ]; then
        perl_truncate_cjk__473_v0 "${text}" "${max_width}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text}" | cut -c1-${max_width}
            __status=$?
        fi
        ret_truncate_text536_v0="${ret_perl_truncate_cjk473_v0}"
        return 0
    fi
    command_73="$(printf "%s" "${text}" | cut -c1-${max_width})"
    __status=$?
    ret_truncate_text536_v0="${command_73}"
    return 0
}

truncate_ansi__537_v0() {
    local text=$1
    local max_width=$2
    has_ansi_escape__531_v0 "${text}"
    ret_has_ansi_escape531_v0__169_12="${ret_has_ansi_escape531_v0}"
    if [ "$(( ! ${ret_has_ansi_escape531_v0__169_12} ))" != 0 ]; then
        truncate_text__536_v0 "${text}" "${max_width}"
        ret_truncate_ansi537_v0="${ret_truncate_text536_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    command_74="$([[ "${text}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    starts_with_ansi_108="${command_74}"
    # Replace \x1b[ with newline, then split
    command_75="$(t="${text}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    replaced_109="${command_75}"
    split__5_v0 "${replaced_109}" "
"
    parts_110=("${ret_split5_v0[@]}")
    result_111=""
    remaining_width_112="${max_width}"
    from=0
    __length_76=("${parts_110[@]}")
    to="${#__length_76[@]}"
    for idx_113 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        part_114="${parts_110[${idx_113}]}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( ${idx_113} == 0 )) && $([ "_${starts_with_ansi_108}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_114}" == "_" ]; echo $?) && $(( ${remaining_width_112} > 0 )) ))" != 0 ]; then
                truncate_text__536_v0 "${part_114}" "${remaining_width_112}"
                truncated_115="${ret_truncate_text536_v0}"
                result_111+="${truncated_115}"
                get_visible_len__535_v0 "${truncated_115}"
                ret_get_visible_len535_v0__193_36="${ret_get_visible_len535_v0}"
                remaining_width_112="$(( ${remaining_width_112} - ${ret_get_visible_len535_v0__193_36} ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            command_77="$(__p="${part_114}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            m_idx_116="${command_77}"
            if [ "$([ "_${m_idx_116}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                command_78="$(__p="${part_114}"; printf "%s" "${__p:0:${m_idx_116}}")"
                __status=$?
                ansi_params_117="${command_78}"
                result_111+="\\x1b[""${ansi_params_117}""m"
                # Rest is text content
                parse_int__14_v0 "${m_idx_116}"
                __status=$?
                m_idx_num_118="${ret_parse_int14_v0}"
                text_start_119="$(( ${m_idx_num_118} + 1 ))"
                command_79="$(__p="${part_114}"; printf "%s" "${__p:${text_start_119}}")"
                __status=$?
                text_part_120="${command_79}"
                if [ "$(( $([ "_${text_part_120}" == "_" ]; echo $?) && $(( ${remaining_width_112} > 0 )) ))" != 0 ]; then
                    truncate_text__536_v0 "${text_part_120}" "${remaining_width_112}"
                    truncated_121="${ret_truncate_text536_v0}"
                    result_111+="${truncated_121}"
                    get_visible_len__535_v0 "${truncated_121}"
                    ret_get_visible_len535_v0__210_40="${ret_get_visible_len535_v0}"
                    remaining_width_112="$(( ${remaining_width_112} - ${ret_get_visible_len535_v0__210_40} ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_114}" == "_" ]; echo $?) && $(( ${remaining_width_112} > 0 )) ))" != 0 ]; then
                    truncate_text__536_v0 "${part_114}" "${remaining_width_112}"
                    truncated_122="${ret_truncate_text536_v0}"
                    result_111+="${truncated_122}"
                    get_visible_len__535_v0 "${truncated_122}"
                    remaining_width_112="$(( ${remaining_width_112} - ${ret_get_visible_len535_v0__217_40} ))"
                fi
            fi
        fi
    done
    ret_truncate_ansi537_v0="${result_111}"
    return 0
}

cutoff_text__538_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__535_v0 "${text}"
    visible_len_105="${ret_get_visible_len535_v0}"
    if [ "$(( ${visible_len_105} <= ${max_width} ))" != 0 ]; then
        ret_cutoff_text538_v0="${text}"
        return 0
    fi
    truncate_ansi__537_v0 "${text}" "$(( ${max_width} - 3 ))"
    ret_truncate_ansi537_v0__233_12="${ret_truncate_ansi537_v0}"
    ret_cutoff_text538_v0="${ret_truncate_ansi537_v0__233_12}""..."
    return 0
}

# // Application Utilities /////
render_tooltip__539_v0() {
    local items=("${!1}")
    local total_len=$2
    local term_width=$3
    separator_124=" • "
    separator_len_125=3
    # Fast path: no truncation needed
    if [ "$(( ${total_len} <= ${term_width} ))" != 0 ]; then
        iter_126=0
        while :
        do
            __length_80=("${items[@]}")
            if [ "$(( ${iter_126} >= ${#__length_80[@]} ))" != 0 ]; then
                break
            elif [ "$(( ${iter_126} > 0 ))" != 0 ]; then
                eprintf_colored__519_v0 "${separator_124}" 90
            fi
            colored__520_v0 "${items[$(( ${iter_126} + 1 ))]}" 2
            ret_colored520_v0__258_41="${ret_colored520_v0}"
            array_81=("")
            eprintf__518_v0 "${items[${iter_126}]}"" ""${ret_colored520_v0__258_41}" array_81[@]
            iter_126="$(( ${iter_126} + 2 ))"
        done
    else
        # Slow path: truncate
        current_len_127=0
        first_128=1
        iter_129=0
        while :
        do
            __length_82=("${items[@]}")
            if [ "$(( ${iter_129} >= ${#__length_82[@]} ))" != 0 ]; then
                break
            fi
            key_130="${items[${iter_129}]}"
            action_131="${items[$(( ${iter_129} + 1 ))]}"
            __length_83="${key_130}"
            __length_84="${action_131}"
            part_len_132="$(( $(( ${#__length_83} + 1 )) + ${#__length_84} ))"
            needed_133="${part_len_132}"
            if [ "$(( ! ${first_128} ))" != 0 ]; then
                needed_133="$(( ${needed_133} + ${separator_len_125} ))"
            fi
            if [ "$(( $(( ${current_len_127} + ${needed_133} )) > ${term_width} ))" != 0 ]; then
                break
            fi
            if [ "$(( ! ${first_128} ))" != 0 ]; then
                eprintf_colored__519_v0 "${separator_124}" 90
            fi
            colored__520_v0 "${action_131}" 2
            ret_colored520_v0__286_33="${ret_colored520_v0}"
            array_85=("")
            eprintf__518_v0 "${key_130}"" ""${ret_colored520_v0__286_33}" array_85[@]
            current_len_127="$(( ${current_len_127} + ${needed_133} ))"
            first_128=0
            iter_129="$(( ${iter_129} + 2 ))"
        done
    fi
}

xyl_input__589_v0() {
    local prompt=$1
    local placeholder=$2
    local header=$3
    local password=$4
    stty_lock__480_v0 
    term_width__484_v0 
    term_width_100="${ret_term_width484_v0}"
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__538_v0 "${header}" "${term_width_100}"
        ret_cutoff_text538_v0__23_17="${ret_cutoff_text538_v0}"
        array_86=("")
        eprintf__518_v0 "${ret_cutoff_text538_v0__23_17}""
" array_86[@]
    fi
    new_line__525_v0 2
    # "enter submit" = 12
    array_87=("enter" "submit")
    render_tooltip__539_v0 array_87[@] 12 "${term_width_100}"
    go_up__526_v0 2
    array_88=("")
    eprintf__518_v0 "\\x1b[99999D" array_88[@]
    array_89=("")
    eprintf__518_v0 "${prompt}" array_89[@]
    eprintf_colored__519_v0 "${placeholder}" 90
    get_char__515_v0 
    char_135="${ret_get_char515_v0}"
    __length_90="${prompt}"
    remove__521_v0 "${#__length_90}"
    __length_91="${placeholder}"
    remove__521_v0 "$(( ${#__length_91} + 1 ))"
    text_136=""
    if [ "$(( ! ${password} ))" != 0 ]; then
        stty_unlock__481_v0 
        command_92="$(read -e -i ${char_135} -p "${prompt}" text < /dev/tty; printf "%s" "$text")"
        __status=$?
        text_136="${command_92}"
    else
        stty_unlock__481_v0 
        command_93="$(read -es -i ${char_135} -p "${prompt}" text < /dev/tty; printf "%s" "$text")"
        __status=$?
        text_136="${command_93}"
    fi
    stty_lock__480_v0 
    # Calculate how many lines the input takes up (prompt + text may wrap)
    get_visible_len__535_v0 "${prompt}""${text_136}"
    input_display_len_139="${ret_get_visible_len535_v0}"
    math_ceil__417_v0 "$(( ${input_display_len_139} / ${term_width_100} ))"
    input_lines_140="${ret_math_ceil417_v0}"
    if [ "$(( ${input_lines_140} < 3 ))" != 0 ]; then
        go_down__527_v0 "$(( 2 - ${input_lines_140} ))"
        remove_line__522_v0 2
        remove_current_line__523_v0 
    fi
    if [ "$(( ${input_lines_140} >= 3 ))" != 0 ]; then
        remove_line__522_v0 "${input_lines_140}"
    fi
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        remove_line__522_v0 1
        remove_current_line__523_v0 
    fi
    stty_unlock__481_v0 
    ret_xyl_input589_v0="${text_136}"
    return 0
}

print_input_help__665_v0() {
    echo "Usage: ./xylitol.sh input [flags]"
    echo ""
    colored_primary__500_v0 "input"
    ret_colored_primary500_v0__7_12="${ret_colored_primary500_v0}"
    array_94=("")
    printf__106_v0 "${ret_colored_primary500_v0__7_12}" array_94[@]
    array_95=("")
    printf__106_v0 " - Prompt for some input from the user." array_95[@]
    echo ""
    echo ""
    colored_secondary__501_v0 "Flags: "
    ret_colored_secondary501_v0__11_12="${ret_colored_secondary501_v0}"
    array_96=("")
    printf__106_v0 "${ret_colored_secondary501_v0__11_12}""
" array_96[@]
    echo "  -h, --help                 Show this help message"
    echo "  --placeholder=\"<text>\"     Set the placeholder text (default: 'Type here...')"
    echo "  --prompt=\"<text>\"          Set the prompt text (default: '> ')"
    echo "  --header=\"<text>\"          Set a header text to display above the prompt (ANSI escape supported)"
    echo "  --password                 Hide input (for password entry)"
    echo ""
}

execute_input__716_v0() {
    local parameters=("${!1}")
    prompt_70="> "
    placeholder_71="Type here..."
    header_72=""
    password_73=0
    for param_74 in "${parameters[@]}"; do
        match_regex__20_v0 "${param_74}" "^-h\$" 0
        ret_match_regex20_v0__13_12="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_74}" "^--help\$" 0
        ret_match_regex20_v0__13_42="${ret_match_regex20_v0}"
        if [ "$(( ${ret_match_regex20_v0__13_12} || ${ret_match_regex20_v0__13_42} ))" != 0 ]; then
            print_input_help__665_v0 
            exit 0
        fi
        match_regex__20_v0 "${param_74}" "^--prompt=.*\$" 0
        ret_match_regex20_v0__17_12="${ret_match_regex20_v0}"
        if [ "${ret_match_regex20_v0__17_12}" != 0 ]; then
            split__5_v0 "${param_74}" "="
            result_89=("${ret_split5_v0[@]}")
            prompt_70="${result_89[1]}"
        fi
        match_regex__20_v0 "${param_74}" "^--placeholder=.*\$" 0
        ret_match_regex20_v0__21_12="${ret_match_regex20_v0}"
        if [ "${ret_match_regex20_v0__21_12}" != 0 ]; then
            split__5_v0 "${param_74}" "="
            result_90=("${ret_split5_v0[@]}")
            placeholder_71="${result_90[1]}"
        fi
        match_regex__20_v0 "${param_74}" "^--header=.*\$" 0
        ret_match_regex20_v0__25_12="${ret_match_regex20_v0}"
        if [ "${ret_match_regex20_v0__25_12}" != 0 ]; then
            split__5_v0 "${param_74}" "="
            result_91=("${ret_split5_v0[@]}")
            header_72="${result_91[1]}"
        fi
        match_regex__20_v0 "${param_74}" "^--password\$" 0
        ret_match_regex20_v0__29_12="${ret_match_regex20_v0}"
        if [ "${ret_match_regex20_v0__29_12}" != 0 ]; then
            password_73=1
        fi
    done
    has_ansi_escape__531_v0 "${header_72}"
    ret_has_ansi_escape531_v0__34_42="${ret_has_ansi_escape531_v0}"
    escape_ansi__532_v0 "${header_72}"
    ret_escape_ansi532_v0__34_71="${ret_escape_ansi532_v0}"
    colored_primary__500_v0 "${header_72}"
    ret_colored_primary500_v0__34_109="${ret_colored_primary500_v0}"
    display_header_93="$(if [ "$(( $([ "_${header_72}" != "_" ]; echo $?) || ${ret_has_ansi_escape531_v0__34_42} ))" != 0 ]; then echo "${ret_escape_ansi532_v0__34_71}"; else echo "\\x1b[1m""${ret_colored_primary500_v0__34_109}"; fi)"
    xyl_input__589_v0 "${prompt_70}" "${placeholder_71}" "${display_header_93}" "${password_73}"
    ret_execute_input716_v0="${ret_xyl_input589_v0}"
    return 0
}

# Perl Extensions Utilities
command_97="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_22="$([ "_${command_97}" != "_No" ]; echo $?)"
command_98="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_23="$(( $(( ! ${_perl_disabled_22} )) && $([ "_${command_98}" != "_0" ]; echo $?) ))"
perl_get_cjk_width__825_v0() {
    local text=$1
    if [ "$(( ! ${_perl_available_23} ))" != 0 ]; then
        ret_perl_get_cjk_width825_v0=''
        return 1
    fi
    command_99="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width825_v0=''
        return "${__status}"
    fi
    width_str_175="${command_99}"
    parse_int__14_v0 "${width_str_175}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width825_v0=''
        return "${__status}"
    fi
    width_176="${ret_parse_int14_v0}"
    ret_perl_get_cjk_width825_v0="${width_176}"
    return 0
}

perl_truncate_cjk__826_v0() {
    local text=$1
    local max_width=$2
    if [ "$(( ! ${_perl_available_23} ))" != 0 ]; then
        ret_perl_truncate_cjk826_v0=''
        return 1
    fi
    command_100="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text}" ${max_width} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk826_v0=''
        return "${__status}"
    fi
    result_179="${command_100}"
    ret_perl_truncate_cjk826_v0="${result_179}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
stty_lock__833_v0() {
    command_102="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_164="${command_102}"
    parse_int__14_v0 "${count_164}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_165="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_165} == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_165="$(( ${count_num_165} + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_165}
    __status=$?
}

stty_unlock__834_v0() {
    command_103="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_247="${command_103}"
    parse_int__14_v0 "${count_247}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_248="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_248} > 0 ))" != 0 ]; then
        count_num_248="$(( ${count_num_248} - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_248}
        __status=$?
        if [ "$(( ${count_num_248} == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

get_term_size__835_v0() {
    # Query terminal size with \x1b[18t, response format: \x1b[8;rows;colst
    command_104="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -rsd t _ignore height width < /dev/tty; echo "$height; $width")"
    __status=$?
    result_166="${command_104}"
    split__5_v0 "${result_166}" ";"
    parts_167=("${ret_split5_v0[@]}")
    __length_105=("${parts_167[@]}")
    if [ "$(( ${#__length_105[@]} != 2 ))" != 0 ]; then
        ret_get_term_size835_v0=''
        return 1
    fi
    parse_int__14_v0 "${parts_167[0]}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_term_size835_v0=''
        return "${__status}"
    fi
    rows_168="${ret_parse_int14_v0}"
    parse_int__14_v0 "${parts_167[1]}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_term_size835_v0=''
        return "${__status}"
    fi
    cols_169="${ret_parse_int14_v0}"
    _term_size_25=("${cols_169}" "${rows_168}")
    _got_term_size_24=1
}

term_width__837_v0() {
    if [ "$([ "_$(( ! ${_got_term_size_24} ))" != "_0" ]; echo $?)" != 0 ]; then
        get_term_size__835_v0 
        __status=$?
    fi
    ret_term_width837_v0="${_term_size_25[0]}"
    return 0
}

term_height__838_v0() {
    if [ "$([ "_$(( ! ${_got_term_size_24} ))" != "_0" ]; echo $?)" != 0 ]; then
        get_term_size__835_v0 
        __status=$?
    fi
    ret_term_height838_v0="${_term_size_25[1]}"
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
get_supports_truecolor__848_v0() {
    env_var_get__98_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    config_148="${ret_env_var_get98_v0}"
    if [ "$([ "_${config_148}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_26="No"
        ret_get_supports_truecolor848_v0=0
        return 0
    fi
    env_var_get__98_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_26="No"
        ret_get_supports_truecolor848_v0=0
        return 0
    fi
    colorterm_149="${ret_env_var_get98_v0}"
    _supports_truecolor_26="$(if [ "$(( $([ "_${colorterm_149}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_149}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor848_v0="$([ "_${_supports_truecolor_26}" != "_Yes" ]; echo $?)"
    return 0
}

colored_rgb__849_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    if [ "$([ "_${_supports_truecolor_26}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb849_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_26}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__848_v0 
        ret_get_supports_truecolor848_v0__50_17="${ret_get_supports_truecolor848_v0}"
        if [ "${ret_get_supports_truecolor848_v0__50_17}" != 0 ]; then
            ret_colored_rgb849_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
            return 0
        elif [ "$(( ${fallback} == 0 ))" != 0 ]; then
            ret_colored_rgb849_v0="${message}"
            return 0
        else
            ret_colored_rgb849_v0="\\x1b[${fallback}m""${message}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( ${fallback} == 0 ))" != 0 ]; then
            ret_colored_rgb849_v0="${message}"
            return 0
        fi
        ret_colored_rgb849_v0="\\x1b[${fallback}m""${message}""\\x1b[0m"
        return 0
    fi
}

inner_get_xylitol_colors__851_v0() {
    if [ "$(( ! ${_got_xylitol_colors_27} ))" != 0 ]; then
        env_var_get__98_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        primary_env_142="${ret_env_var_get98_v0}"
        if [ "$([ "_${primary_env_142}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${primary_env_142}" ";"
            parts_143=("${ret_split5_v0[@]}")
            __length_110=("${parts_143[@]}")
            if [ "$(( ${#__length_110[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_143[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__115_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_143[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__116_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_143[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__117_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_143[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__118_21="${ret_parse_int14_v0}"
                _primary_color_28=("${ret_parse_int14_v0__115_21}" "${ret_parse_int14_v0__116_21}" "${ret_parse_int14_v0__117_21}" "${ret_parse_int14_v0__118_21}")
            fi
        fi
        env_var_get__98_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        secondary_env_144="${ret_env_var_get98_v0}"
        if [ "$([ "_${secondary_env_144}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${secondary_env_144}" ";"
            parts_145=("${ret_split5_v0[@]}")
            __length_112=("${parts_145[@]}")
            if [ "$(( ${#__length_112[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_145[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__128_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_145[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__129_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_145[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__130_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_145[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__131_21="${ret_parse_int14_v0}"
                _secondary_color_29=("${ret_parse_int14_v0__128_21}" "${ret_parse_int14_v0__129_21}" "${ret_parse_int14_v0__130_21}" "${ret_parse_int14_v0__131_21}")
            fi
        fi
        env_var_get__98_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        accent_env_146="${ret_env_var_get98_v0}"
        if [ "$([ "_${accent_env_146}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${accent_env_146}" ";"
            parts_147=("${ret_split5_v0[@]}")
            __length_114=("${parts_147[@]}")
            if [ "$(( ${#__length_114[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_147[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__141_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_147[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__142_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_147[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__143_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_147[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__144_21="${ret_parse_int14_v0}"
            fi
        fi
        _got_xylitol_colors_27=1
    fi
}

get_xylitol_colors__852_v0() {
    inner_get_xylitol_colors__851_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__112_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_27=1
}

colored_primary__853_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_27} ))" != 0 ]; then
        get_xylitol_colors__852_v0 
    fi
    colored_rgb__849_v0 "${message}" "${_primary_color_28[0]}" "${_primary_color_28[1]}" "${_primary_color_28[2]}" "${_primary_color_28[3]}"
    ret_colored_primary853_v0="${ret_colored_rgb849_v0}"
    return 0
}

colored_secondary__854_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_27} ))" != 0 ]; then
        get_xylitol_colors__852_v0 
    fi
    colored_rgb__849_v0 "${message}" "${_secondary_color_29[0]}" "${_secondary_color_29[1]}" "${_secondary_color_29[2]}" "${_secondary_color_29[3]}"
    ret_colored_secondary854_v0="${ret_colored_rgb849_v0}"
    return 0
}

# // IO Functions /////
get_key__869_v0() {
    command_116="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    var_227="${command_116}"
    if [ "$([ "_${var_227}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key869_v0="UP"
        return 0
    elif [ "$([ "_${var_227}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key869_v0="DOWN"
        return 0
    elif [ "$([ "_${var_227}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key869_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_227}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key869_v0="LEFT"
        return 0
    elif [ "$([ "_${var_227}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key869_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_227}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key869_v0="INPUT"
        return 0
    else
        ret_get_key869_v0="${var_227}"
        return 0
    fi
}

eprintf__871_v0() {
    local format=$1
    local args=("${!2}")
    args=("${format}" "${args[@]}")
    __status=$?
    printf "${args[@]}" >&2
    __status=$?
}

eprintf_colored__872_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    array_117=("${message}")
    eprintf__871_v0 "\\x1b[${color}m%s\\x1b[0m" array_117[@]
}

colored__873_v0() {
    local message=$1
    local color=$2
    # Returns a text wrapped in color codes.
    ret_colored873_v0="\\x1b[${color}m""${message}""\\x1b[0m"
    return 0
}

remove_line__875_v0() {
    local cnt=$1
    printf '\x1b[2K\x1b[1A%.0s' $(seq ${cnt}) >&2
    __status=$?
    array_118=("")
    eprintf__871_v0 "\\x1b[9999D" array_118[@]
}

remove_current_line__876_v0() {
    array_119=("")
    eprintf__871_v0 "\\x1b[2K\\x1b[9999D" array_119[@]
}

print_blank__877_v0() {
    local cnt=$1
    printf '%*s' "${cnt}" ' ' >&2
    __status=$?
}

new_line__878_v0() {
    local cnt=$1
    from=0
    to="${cnt}"
    for i_199 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        array_120=("")
        eprintf__871_v0 "
" array_120[@]
    done
}

go_up__879_v0() {
    local cnt=$1
    array_121=("")
    eprintf__871_v0 "\\x1b[${cnt}A" array_121[@]
}

go_down__880_v0() {
    local cnt=$1
    array_122=("")
    eprintf__871_v0 "\\x1b[${cnt}B" array_122[@]
}

# move the cursor up or down `cnt` lines.
go_up_or_down__881_v0() {
    local cnt=$1
    if [ "$(( ${cnt} > 0 ))" != 0 ]; then
        go_down__880_v0 "${cnt}"
    else
        go_up__879_v0 "$(( - ${cnt} ))"
    fi
}

hide_cursor__882_v0() {
    array_123=("")
    eprintf__871_v0 "\\x1b[?25l" array_123[@]
}

show_cursor__883_v0() {
    array_124=("")
    eprintf__871_v0 "\\x1b[?25h" array_124[@]
}

# / Text Utilities /////
has_ansi_escape__884_v0() {
    local text=$1
    # Check for ESC character (0x1B = 27) or literal \x1b[
    command_125="$([[ "${text}" == *$'\x1b'* || "${text}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    has_escape_162="${command_125}"
    ret_has_ansi_escape884_v0="$([ "_${has_escape_162}" != "_1" ]; echo $?)"
    return 0
}

escape_ansi__885_v0() {
    local text=$1
    command_126="$(printf '%s' "${text}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi885_v0="${command_126}"
    return 0
}

strip_ansi__886_v0() {
    local text=$1
    command_127="$(printf "%s" "${text}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi886_v0="${command_127}"
    return 0
}

is_all_ascii__887_v0() {
    local text=$1
    command_128="$(printf "%s" "${text}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    result_174="${command_128}"
    ret_is_all_ascii887_v0="$([ "_${result_174}" != "_0" ]; echo $?)"
    return 0
}

get_visible_len__888_v0() {
    local text=$1
    strip_ansi__886_v0 "${text}"
    stripped_173="${ret_strip_ansi886_v0}"
    # Check if text is all ASCII
    is_all_ascii__887_v0 "${stripped_173}"
    ret_is_all_ascii887_v0__140_12="${ret_is_all_ascii887_v0}"
    if [ "$(( ! ${ret_is_all_ascii887_v0__140_12} ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__825_v0 "${stripped_173}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            __length_129="${stripped_173}"
            ret_get_visible_len888_v0="${#__length_129}"
            return 0
        fi
        ret_get_visible_len888_v0="${ret_perl_get_cjk_width825_v0}"
        return 0
    else
        __length_130="${stripped_173}"
        ret_get_visible_len888_v0="${#__length_130}"
        return 0
    fi
}

truncate_text__889_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__888_v0 "${text}"
    visible_len_178="${ret_get_visible_len888_v0}"
    if [ "$(( ${visible_len_178} <= ${max_width} ))" != 0 ]; then
        ret_truncate_text889_v0="${text}"
        return 0
    fi
    is_all_ascii__887_v0 "${text}"
    ret_is_all_ascii887_v0__157_12="${ret_is_all_ascii887_v0}"
    if [ "$(( ! ${ret_is_all_ascii887_v0__157_12} ))" != 0 ]; then
        perl_truncate_cjk__826_v0 "${text}" "${max_width}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text}" | cut -c1-${max_width}
            __status=$?
        fi
        ret_truncate_text889_v0="${ret_perl_truncate_cjk826_v0}"
        return 0
    fi
    command_131="$(printf "%s" "${text}" | cut -c1-${max_width})"
    __status=$?
    ret_truncate_text889_v0="${command_131}"
    return 0
}

truncate_ansi__890_v0() {
    local text=$1
    local max_width=$2
    has_ansi_escape__884_v0 "${text}"
    ret_has_ansi_escape884_v0__169_12="${ret_has_ansi_escape884_v0}"
    if [ "$(( ! ${ret_has_ansi_escape884_v0__169_12} ))" != 0 ]; then
        truncate_text__889_v0 "${text}" "${max_width}"
        ret_truncate_ansi890_v0="${ret_truncate_text889_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    command_132="$([[ "${text}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    starts_with_ansi_180="${command_132}"
    # Replace \x1b[ with newline, then split
    command_133="$(t="${text}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    replaced_181="${command_133}"
    split__5_v0 "${replaced_181}" "
"
    parts_182=("${ret_split5_v0[@]}")
    result_183=""
    remaining_width_184="${max_width}"
    from=0
    __length_134=("${parts_182[@]}")
    to="${#__length_134[@]}"
    for idx_185 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        part_186="${parts_182[${idx_185}]}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( ${idx_185} == 0 )) && $([ "_${starts_with_ansi_180}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_186}" == "_" ]; echo $?) && $(( ${remaining_width_184} > 0 )) ))" != 0 ]; then
                truncate_text__889_v0 "${part_186}" "${remaining_width_184}"
                truncated_187="${ret_truncate_text889_v0}"
                result_183+="${truncated_187}"
                get_visible_len__888_v0 "${truncated_187}"
                ret_get_visible_len888_v0__193_36="${ret_get_visible_len888_v0}"
                remaining_width_184="$(( ${remaining_width_184} - ${ret_get_visible_len888_v0__193_36} ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            command_135="$(__p="${part_186}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            m_idx_188="${command_135}"
            if [ "$([ "_${m_idx_188}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                command_136="$(__p="${part_186}"; printf "%s" "${__p:0:${m_idx_188}}")"
                __status=$?
                ansi_params_189="${command_136}"
                result_183+="\\x1b[""${ansi_params_189}""m"
                # Rest is text content
                parse_int__14_v0 "${m_idx_188}"
                __status=$?
                m_idx_num_190="${ret_parse_int14_v0}"
                text_start_191="$(( ${m_idx_num_190} + 1 ))"
                command_137="$(__p="${part_186}"; printf "%s" "${__p:${text_start_191}}")"
                __status=$?
                text_part_192="${command_137}"
                if [ "$(( $([ "_${text_part_192}" == "_" ]; echo $?) && $(( ${remaining_width_184} > 0 )) ))" != 0 ]; then
                    truncate_text__889_v0 "${text_part_192}" "${remaining_width_184}"
                    truncated_193="${ret_truncate_text889_v0}"
                    result_183+="${truncated_193}"
                    get_visible_len__888_v0 "${truncated_193}"
                    ret_get_visible_len888_v0__210_40="${ret_get_visible_len888_v0}"
                    remaining_width_184="$(( ${remaining_width_184} - ${ret_get_visible_len888_v0__210_40} ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_186}" == "_" ]; echo $?) && $(( ${remaining_width_184} > 0 )) ))" != 0 ]; then
                    truncate_text__889_v0 "${part_186}" "${remaining_width_184}"
                    truncated_194="${ret_truncate_text889_v0}"
                    result_183+="${truncated_194}"
                    get_visible_len__888_v0 "${truncated_194}"
                    remaining_width_184="$(( ${remaining_width_184} - ${ret_get_visible_len888_v0__217_40} ))"
                fi
            fi
        fi
    done
    ret_truncate_ansi890_v0="${result_183}"
    return 0
}

cutoff_text__891_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__888_v0 "${text}"
    visible_len_177="${ret_get_visible_len888_v0}"
    if [ "$(( ${visible_len_177} <= ${max_width} ))" != 0 ]; then
        ret_cutoff_text891_v0="${text}"
        return 0
    fi
    truncate_ansi__890_v0 "${text}" "$(( ${max_width} - 3 ))"
    ret_truncate_ansi890_v0__233_12="${ret_truncate_ansi890_v0}"
    ret_cutoff_text891_v0="${ret_truncate_ansi890_v0__233_12}""..."
    return 0
}

# // Application Utilities /////
render_tooltip__892_v0() {
    local items=("${!1}")
    local total_len=$2
    local term_width=$3
    separator_200=" • "
    separator_len_201=3
    # Fast path: no truncation needed
    if [ "$(( ${total_len} <= ${term_width} ))" != 0 ]; then
        iter_202=0
        while :
        do
            __length_138=("${items[@]}")
            if [ "$(( ${iter_202} >= ${#__length_138[@]} ))" != 0 ]; then
                break
            elif [ "$(( ${iter_202} > 0 ))" != 0 ]; then
                eprintf_colored__872_v0 "${separator_200}" 90
            fi
            colored__873_v0 "${items[$(( ${iter_202} + 1 ))]}" 2
            ret_colored873_v0__258_41="${ret_colored873_v0}"
            array_139=("")
            eprintf__871_v0 "${items[${iter_202}]}"" ""${ret_colored873_v0__258_41}" array_139[@]
            iter_202="$(( ${iter_202} + 2 ))"
        done
    else
        # Slow path: truncate
        current_len_203=0
        first_204=1
        iter_205=0
        while :
        do
            __length_140=("${items[@]}")
            if [ "$(( ${iter_205} >= ${#__length_140[@]} ))" != 0 ]; then
                break
            fi
            key_206="${items[${iter_205}]}"
            action_207="${items[$(( ${iter_205} + 1 ))]}"
            __length_141="${key_206}"
            __length_142="${action_207}"
            part_len_208="$(( $(( ${#__length_141} + 1 )) + ${#__length_142} ))"
            needed_209="${part_len_208}"
            if [ "$(( ! ${first_204} ))" != 0 ]; then
                needed_209="$(( ${needed_209} + ${separator_len_201} ))"
            fi
            if [ "$(( $(( ${current_len_203} + ${needed_209} )) > ${term_width} ))" != 0 ]; then
                break
            fi
            if [ "$(( ! ${first_204} ))" != 0 ]; then
                eprintf_colored__872_v0 "${separator_200}" 90
            fi
            colored__873_v0 "${action_207}" 2
            ret_colored873_v0__286_33="${ret_colored873_v0}"
            array_143=("")
            eprintf__871_v0 "${key_206}"" ""${ret_colored873_v0__286_33}" array_143[@]
            current_len_203="$(( ${current_len_203} + ${needed_209} ))"
            first_204=0
            iter_205="$(( ${iter_205} + 2 ))"
        done
    fi
}

get_page_options__942_v0() {
    local options=("${!1}")
    local page=$2
    local page_size=$3
    start_212="$(( ${page} * ${page_size} ))"
    end_213="$(( ${start_212} + ${page_size} ))"
    __length_144=("${options[@]}")
    if [ "$(( ${end_213} > ${#__length_144[@]} ))" != 0 ]; then
        __length_145=("${options[@]}")
        end_213="${#__length_145[@]}"
    fi
    result_214=()
    from="${start_212}"
    to="${end_213}"
    for i_215 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        result_214+=("${options[${i_215}]}")
    done
    ret_get_page_options942_v0=("${result_214[@]}")
    return 0
}

get_page_start__943_v0() {
    local page=$1
    local page_size=$2
    ret_get_page_start943_v0="$(( ${page} * ${page_size} ))"
    return 0
}

render_choose_page__944_v0() {
    local page_options=("${!1}")
    local sel=$2
    local cursor=$3
    local display_count=$4
    local term_width=$5
    __length_148="${cursor}"
    cursor_len_258="${#__length_148}"
    max_option_width_259="$(( $(( ${term_width} - ${cursor_len_258} )) - 1 ))"
    from=0
    __length_149=("${page_options[@]}")
    to="${#__length_149[@]}"
    for i_260 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        cutoff_text__891_v0 "${page_options[${i_260}]}" "${max_option_width_259}"
        truncated_option_261="${ret_cutoff_text891_v0}"
        if [ "$(( ${i_260} == ${sel} ))" != 0 ]; then
            colored_secondary__854_v0 "${cursor}""${truncated_option_261}""
"
            ret_colored_secondary854_v0__28_21="${ret_colored_secondary854_v0}"
            array_150=("")
            eprintf__871_v0 "${ret_colored_secondary854_v0__28_21}" array_150[@]
        else
            print_blank__877_v0 "${cursor_len_258}"
            array_151=("")
            eprintf__871_v0 "${truncated_option_261}""
" array_151[@]
        fi
    done
    __length_152=("${page_options[@]}")
    remaining_slots_262="$(( ${display_count} - ${#__length_152[@]} ))"
    if [ "$(( ${remaining_slots_262} > 0 ))" != 0 ]; then
        # Amber bug gaurd
        from=0
        to="${remaining_slots_262}"
        for ____263 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
            array_153=("")
            eprintf__871_v0 "\\x1b[K
" array_153[@]
        done
    fi
}

render_multi_choose_page__945_v0() {
    local page_options=("${!1}")
    local checked=("${!2}")
    local page_start=$3
    local sel=$4
    local cursor=$5
    local display_count=$6
    local term_width=$7
    __length_154="${cursor}"
    cursor_len_218="${#__length_154}"
    check_mark_len_219=2
    # "✓ " or "• "
    max_option_width_220="$(( $(( $(( ${term_width} - ${cursor_len_218} )) - ${check_mark_len_219} )) - 1 ))"
    from=0
    __length_155=("${page_options[@]}")
    to="${#__length_155[@]}"
    for i_221 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        global_idx_222="$(( ${page_start} + ${i_221} ))"
        check_mark_223="$(if [ "${checked[${global_idx_222}]}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__891_v0 "${page_options[${i_221}]}" "${max_option_width_220}"
        truncated_option_224="${ret_cutoff_text891_v0}"
        if [ "$(( ${i_221} == ${sel} ))" != 0 ]; then
            colored_secondary__854_v0 "${cursor}""${check_mark_223}""${truncated_option_224}""
"
            ret_colored_secondary854_v0__51_31="${ret_colored_secondary854_v0}"
            array_156=("")
            eprintf__871_v0 "${ret_colored_secondary854_v0__51_31}" array_156[@]
        elif [ "${checked[${global_idx_222}]}" != 0 ]; then
            print_blank__877_v0 "${cursor_len_218}"
            colored_secondary__854_v0 "${check_mark_223}""${truncated_option_224}""
"
            ret_colored_secondary854_v0__54_25="${ret_colored_secondary854_v0}"
            array_157=("")
            eprintf__871_v0 "${ret_colored_secondary854_v0__54_25}" array_157[@]
        else
            print_blank__877_v0 "${cursor_len_218}"
            array_158=("")
            eprintf__871_v0 "${check_mark_223}""${truncated_option_224}""
" array_158[@]
        fi
    done
    __length_159=("${page_options[@]}")
    remaining_slots_225="$(( ${display_count} - ${#__length_159[@]} ))"
    if [ "$(( ${remaining_slots_225} > 0 ))" != 0 ]; then
        # Amber bug guard
        from=0
        to="${remaining_slots_225}"
        for ____226 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
            array_160=("")
            eprintf__871_v0 "\\x1b[K
" array_160[@]
        done
    fi
}

render_page_indicator__946_v0() {
    local page=$1
    local total_pages=$2
    if [ "$(( ${total_pages} > 1 ))" != 0 ]; then
        array_161=("")
        eprintf__871_v0 "\\x1b[9999D\\x1b[K" array_161[@]
        eprintf_colored__872_v0 "Page $(( ${page} + 1 ))/${total_pages}" 90
        array_162=("")
        eprintf__871_v0 "\\x1b[9999D" array_162[@]
    fi
}

xyl_choose__947_v0() {
    local options=("${!1}")
    local cursor=$2
    local header=$3
    local page_size=$4
    __length_163=("${options[@]}")
    if [ "$(( ${#__length_163[@]} == 0 ))" != 0 ]; then
        eprintf_colored__872_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    stty_lock__833_v0 
    hide_cursor__882_v0 
    term_width__837_v0 
    term_width_250="${ret_term_width837_v0}"
    term_height__838_v0 
    term_height_251="${ret_term_height838_v0}"
    max_page_size_252="$(( ${term_height_251} - $(if [ "$([ "_${header}" != "_" ]; echo $?)" != 0 ]; then echo 2; else echo 3; fi) ))"
    if [ "$(( ${page_size} > ${max_page_size_252} ))" != 0 ]; then
        page_size="${max_page_size_252}"
    fi
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__891_v0 "${header}" "${term_width_250}"
        ret_cutoff_text891_v0__107_17="${ret_cutoff_text891_v0}"
        array_164=("")
        eprintf__871_v0 "${ret_cutoff_text891_v0__107_17}""
" array_164[@]
    fi
    __length_165=("${options[@]}")
    math_floor__416_v0 "$(( $(( $(( ${#__length_165[@]} + ${page_size} )) - 1 )) / ${page_size} ))"
    total_pages_253="${ret_math_floor416_v0}"
    current_page_254=0
    selected_255=0
    display_count_256="${page_size}"
    __length_166=("${options[@]}")
    if [ "$(( ${#__length_166[@]} < ${page_size} ))" != 0 ]; then
        __length_167=("${options[@]}")
        display_count_256="${#__length_167[@]}"
    fi
    new_line__878_v0 "${display_count_256}"
    array_168=("")
    eprintf__871_v0 "\\x1b[9999D" array_168[@]
    if [ "$(( ${total_pages_253} > 1 ))" != 0 ]; then
        eprintf_colored__872_v0 "Page $(( ${current_page_254} + 1 ))/${total_pages_253}" 90
    fi
    new_line__878_v0 1
    # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
    # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    if [ "$(( ${total_pages_253} > 1 ))" != 0 ]; then
        array_169=("↑↓" "select" "←→" "page" "enter" "confirm")
        render_tooltip__892_v0 array_169[@] 36 "${term_width_250}"
    else
        array_170=("↑↓" "select" "enter" "confirm")
        render_tooltip__892_v0 array_170[@] 25 "${term_width_250}"
    fi
    go_up__879_v0 "$(( ${display_count_256} + 1 ))"
    array_171=("")
    eprintf__871_v0 "\\x1b[9999D" array_171[@]
    get_page_options__942_v0 options[@] "${current_page_254}" "${page_size}"
    page_options_257=("${ret_get_page_options942_v0[@]}")
    render_choose_page__944_v0 page_options_257[@] "${selected_255}" "${cursor}" "${display_count_256}" "${term_width_250}"
    while :
    do
        get_key__869_v0 
        key_264="${ret_get_key869_v0}"
        prev_selected_265="${selected_255}"
        prev_page_266="${current_page_254}"
        up_paged_267=0
        if [ "$(( $([ "_${key_264}" != "_UP" ]; echo $?) || $([ "_${key_264}" != "_k" ]; echo $?) ))" != 0 ]; then
            if [ "$(( $(( ${selected_255} == 0 )) && $(( ${total_pages_253} > 1 )) ))" != 0 ]; then
                if [ "$(( ${current_page_254} > 0 ))" != 0 ]; then
                    current_page_254="$(( ${current_page_254} - 1 ))"
                else
                    current_page_254="$(( ${total_pages_253} - 1 ))"
                fi
                up_paged_267=1
            elif [ "$(( ${selected_255} == 0 ))" != 0 ]; then
                __length_172=("${page_options_257[@]}")
                selected_255="$(( ${#__length_172[@]} - 1 ))"
            else
                selected_255="$(( ${selected_255} - 1 ))"
            fi
        elif [ "$(( $([ "_${key_264}" != "_DOWN" ]; echo $?) || $([ "_${key_264}" != "_j" ]; echo $?) ))" != 0 ]; then
            __length_173=("${page_options_257[@]}")
            if [ "$(( ${selected_255} == $(( ${#__length_173[@]} - 1 )) ))" != 0 ]; then
                if [ "$(( ${current_page_254} < $(( ${total_pages_253} - 1 )) ))" != 0 ]; then
                    current_page_254="$(( ${current_page_254} + 1 ))"
                    selected_255=0
                else
                    current_page_254=0
                    selected_255=0
                fi
            else
                selected_255="$(( ${selected_255} + 1 ))"
            fi
        elif [ "$(( $([ "_${key_264}" != "_LEFT" ]; echo $?) || $([ "_${key_264}" != "_h" ]; echo $?) ))" != 0 ]; then
            if [ "$(( ${current_page_254} > 0 ))" != 0 ]; then
                current_page_254="$(( ${current_page_254} - 1 ))"
                selected_255=0
            else
                selected_255=0
            fi
        elif [ "$(( $([ "_${key_264}" != "_RIGHT" ]; echo $?) || $([ "_${key_264}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "$(( ${current_page_254} < $(( ${total_pages_253} - 1 )) ))" != 0 ]; then
                current_page_254="$(( ${current_page_254} + 1 ))"
                selected_255=0
            else
                __length_174=("${page_options_257[@]}")
                selected_255="$(( ${#__length_174[@]} - 1 ))"
            fi
        elif [ "$([ "_${key_264}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
        __length_175="${cursor}"
        max_option_width_268="$(( $(( ${term_width_250} - ${#__length_175} )) - 1 ))"
        if [ "$(( ${prev_page_266} != ${current_page_254} ))" != 0 ]; then
            get_page_options__942_v0 options[@] "${current_page_254}" "${page_size}"
            page_options_257=("${ret_get_page_options942_v0[@]}")
            if [ "${up_paged_267}" != 0 ]; then
                __length_176=("${page_options_257[@]}")
                selected_255="$(( ${#__length_176[@]} - 1 ))"
            fi
            go_up__879_v0 1
            remove_line__875_v0 "$(( ${display_count_256} - 1 ))"
            remove_current_line__876_v0 
            array_177=("")
            eprintf__871_v0 "\\x1b[9999D" array_177[@]
            render_choose_page__944_v0 page_options_257[@] "${selected_255}" "${cursor}" "${display_count_256}" "${term_width_250}"
            render_page_indicator__946_v0 "${current_page_254}" "${total_pages_253}"
        elif [ "$(( ${prev_selected_265} != ${selected_255} ))" != 0 ]; then
            go_up__879_v0 "$(( ${display_count_256} - ${prev_selected_265} ))"
            array_178=("")
            eprintf__871_v0 "\\x1b[K" array_178[@]
            __length_179="${cursor}"
            print_blank__877_v0 "${#__length_179}"
            cutoff_text__891_v0 "${page_options_257[${prev_selected_265}]}" "${max_option_width_268}"
            ret_cutoff_text891_v0__218_25="${ret_cutoff_text891_v0}"
            array_180=("")
            eprintf__871_v0 "${ret_cutoff_text891_v0__218_25}" array_180[@]
            diff_269="$(( ${selected_255} - ${prev_selected_265} ))"
            go_up_or_down__881_v0 "${diff_269}"
            array_181=("")
            eprintf__871_v0 "\\x1b[9999D" array_181[@]
            array_182=("")
            eprintf__871_v0 "\\x1b[K" array_182[@]
            cutoff_text__891_v0 "${page_options_257[${selected_255}]}" "${max_option_width_268}"
            ret_cutoff_text891_v0__224_52="${ret_cutoff_text891_v0}"
            colored_secondary__854_v0 "${cursor}""${ret_cutoff_text891_v0__224_52}"
            ret_colored_secondary854_v0__224_25="${ret_colored_secondary854_v0}"
            array_183=("")
            eprintf__871_v0 "${ret_colored_secondary854_v0__224_25}" array_183[@]
            go_down__880_v0 "$(( ${display_count_256} - ${selected_255} ))"
            array_184=("")
            eprintf__871_v0 "\\x1b[9999D" array_184[@]
        fi
    done
    total_lines_270="$(( ${display_count_256} + 2 ))"
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_270="$(( ${total_lines_270} + 1 ))"
    fi
    go_down__880_v0 1
    remove_line__875_v0 "$(( ${total_lines_270} - 1 ))"
    remove_current_line__876_v0 
    stty_unlock__834_v0 
    show_cursor__883_v0 
    global_selected_271="$(( $(( ${current_page_254} * ${page_size} )) + ${selected_255} ))"
    ret_xyl_choose947_v0="${options[${global_selected_271}]}"
    return 0
}

count_checked__948_v0() {
    local checked=("${!1}")
    count_233=0
    for c_234 in "${checked[@]}"; do
        if [ "${c_234}" != 0 ]; then
            count_233="$(( ${count_233} + 1 ))"
        fi
    done
    ret_count_checked948_v0="${count_233}"
    return 0
}

xyl_multi_choose__949_v0() {
    local options=("${!1}")
    local cursor=$2
    local header=$3
    local limit=$4
    local page_size=$5
    __length_185=("${options[@]}")
    if [ "$(( ${#__length_185[@]} == 0 ))" != 0 ]; then
        eprintf_colored__872_v0 "ERROR: No options provided.
" 31
        ret_xyl_multi_choose949_v0=()
        return 0
    fi
    stty_lock__833_v0 
    hide_cursor__882_v0 
    term_width__837_v0 
    term_width_170="${ret_term_width837_v0}"
    term_height__838_v0 
    term_height_171="${ret_term_height838_v0}"
    max_page_size_172="$(( ${term_height_171} - $(if [ "$([ "_${header}" != "_" ]; echo $?)" != 0 ]; then echo 2; else echo 3; fi) ))"
    if [ "$(( ${page_size} > ${max_page_size_172} ))" != 0 ]; then
        page_size="${max_page_size_172}"
    fi
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__891_v0 "${header}" "${term_width_170}"
        ret_cutoff_text891_v0__288_17="${ret_cutoff_text891_v0}"
        array_187=("")
        eprintf__871_v0 "${ret_cutoff_text891_v0__288_17}""
" array_187[@]
    fi
    __length_188=("${options[@]}")
    math_floor__416_v0 "$(( $(( $(( ${#__length_188[@]} + ${page_size} )) - 1 )) / ${page_size} ))"
    total_pages_195="${ret_math_floor416_v0}"
    current_page_196=0
    selected_197=0
    display_count_198="${page_size}"
    __length_189=("${options[@]}")
    if [ "$(( ${#__length_189[@]} < ${page_size} ))" != 0 ]; then
        __length_190=("${options[@]}")
        display_count_198="${#__length_190[@]}"
    fi
    new_line__878_v0 "${display_count_198}"
    array_191=("")
    eprintf__871_v0 "\\x1b[9999D" array_191[@]
    if [ "$(( ${total_pages_195} > 1 ))" != 0 ]; then
        eprintf_colored__872_v0 "Page $(( ${current_page_196} + 1 ))/${total_pages_195}" 90
    fi
    new_line__878_v0 1
    # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
    # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
    # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
    if [ "$(( $(( ${total_pages_195} > 1 )) && $(( ${limit} < 0 )) ))" != 0 ]; then
        array_192=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
        render_tooltip__892_v0 array_192[@] 55 "${term_width_170}"
    elif [ "$(( ${total_pages_195} > 1 ))" != 0 ]; then
        array_193=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
        render_tooltip__892_v0 array_193[@] 47 "${term_width_170}"
    elif [ "$(( ${limit} < 0 ))" != 0 ]; then
        array_194=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
        render_tooltip__892_v0 array_194[@] 44 "${term_width_170}"
    else
        array_195=("↑↓" "select" "x" "toggle" "enter" "confirm")
        render_tooltip__892_v0 array_195[@] 36 "${term_width_170}"
    fi
    go_up__879_v0 "$(( ${display_count_198} + 1 ))"
    array_196=("")
    eprintf__871_v0 "\\x1b[9999D" array_196[@]
    checked_210=()
    from=0
    __length_198=("${options[@]}")
    to="${#__length_198[@]}"
    for ____211 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        checked_210+=(0)
    done
    get_page_options__942_v0 options[@] "${current_page_196}" "${page_size}"
    page_options_216=("${ret_get_page_options942_v0[@]}")
    get_page_start__943_v0 "${current_page_196}" "${page_size}"
    page_start_217="${ret_get_page_start943_v0}"
    render_multi_choose_page__945_v0 page_options_216[@] checked_210[@] "${page_start_217}" "${selected_197}" "${cursor}" "${display_count_198}" "${term_width_170}"
    while :
    do
        get_key__869_v0 
        key_228="${ret_get_key869_v0}"
        prev_selected_229="${selected_197}"
        prev_page_230="${current_page_196}"
        global_selected_231="$(( ${page_start_217} + ${selected_197} ))"
        up_paged_232=0
        if [ "$(( $([ "_${key_228}" != "_UP" ]; echo $?) || $([ "_${key_228}" != "_k" ]; echo $?) ))" != 0 ]; then
            if [ "$(( $(( ${selected_197} == 0 )) && $(( ${total_pages_195} > 1 )) ))" != 0 ]; then
                if [ "$(( ${current_page_196} > 0 ))" != 0 ]; then
                    current_page_196="$(( ${current_page_196} - 1 ))"
                else
                    current_page_196="$(( ${total_pages_195} - 1 ))"
                fi
                up_paged_232=1
            elif [ "$(( ${selected_197} == 0 ))" != 0 ]; then
                __length_200=("${page_options_216[@]}")
                selected_197="$(( ${#__length_200[@]} - 1 ))"
            else
                selected_197="$(( ${selected_197} - 1 ))"
            fi
        elif [ "$(( $([ "_${key_228}" != "_DOWN" ]; echo $?) || $([ "_${key_228}" != "_j" ]; echo $?) ))" != 0 ]; then
            __length_201=("${page_options_216[@]}")
            if [ "$(( ${selected_197} == $(( ${#__length_201[@]} - 1 )) ))" != 0 ]; then
                if [ "$(( ${current_page_196} < $(( ${total_pages_195} - 1 )) ))" != 0 ]; then
                    current_page_196="$(( ${current_page_196} + 1 ))"
                    selected_197=0
                else
                    current_page_196=0
                    selected_197=0
                fi
            else
                selected_197="$(( ${selected_197} + 1 ))"
            fi
        elif [ "$(( $([ "_${key_228}" != "_LEFT" ]; echo $?) || $([ "_${key_228}" != "_h" ]; echo $?) ))" != 0 ]; then
            if [ "$(( ${current_page_196} > 0 ))" != 0 ]; then
                current_page_196="$(( ${current_page_196} - 1 ))"
                selected_197=0
            else
                selected_197=0
            fi
        elif [ "$(( $([ "_${key_228}" != "_RIGHT" ]; echo $?) || $([ "_${key_228}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "$(( ${current_page_196} < $(( ${total_pages_195} - 1 )) ))" != 0 ]; then
                current_page_196="$(( ${current_page_196} + 1 ))"
                selected_197=0
            else
                __length_202=("${page_options_216[@]}")
                selected_197="$(( ${#__length_202[@]} - 1 ))"
            fi
        elif [ "$(( $([ "_${key_228}" != "_x" ]; echo $?) || $([ "_${key_228}" != "_X" ]; echo $?) ))" != 0 ]; then
            count_checked__948_v0 checked_210[@]
            ret_count_checked948_v0__390_34="${ret_count_checked948_v0}"
            if [ "${checked_210[${global_selected_231}]}" != 0 ]; then
                checked_210["${global_selected_231}"]=0
            elif [ "$(( $(( ${limit} < 0 )) || $(( ${ret_count_checked948_v0__390_34} < ${limit} )) ))" != 0 ]; then
                checked_210["${global_selected_231}"]=1
            else
                continue
            fi
            __length_203="${cursor}"
            max_option_width_235="$(( $(( $(( ${term_width_170} - ${#__length_203} )) - 2 )) - 1 ))"
            # 2 for check mark
            go_up__879_v0 "$(( ${display_count_198} - ${selected_197} ))"
            array_204=("")
            eprintf__871_v0 "\\x1b[9999D" array_204[@]
            array_205=("")
            eprintf__871_v0 "\\x1b[K" array_205[@]
            check_mark_236="$(if [ "${checked_210[${global_selected_231}]}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
            cutoff_text__891_v0 "${page_options_216[${selected_197}]}" "${max_option_width_235}"
            ret_cutoff_text891_v0__400_65="${ret_cutoff_text891_v0}"
            colored_secondary__854_v0 "${cursor}""${check_mark_236}""${ret_cutoff_text891_v0__400_65}"
            ret_colored_secondary854_v0__400_25="${ret_colored_secondary854_v0}"
            array_206=("")
            eprintf__871_v0 "${ret_colored_secondary854_v0__400_25}" array_206[@]
            go_down__880_v0 "$(( ${display_count_198} - ${selected_197} ))"
            array_207=("")
            eprintf__871_v0 "\\x1b[9999D" array_207[@]
            continue
        elif [ "$(( $(( $([ "_${key_228}" != "_a" ]; echo $?) || $([ "_${key_228}" != "_A" ]; echo $?) )) && $(( ${limit} < 0 )) ))" != 0 ]; then
            count_checked__948_v0 checked_210[@]
            ret_count_checked948_v0__406_35="${ret_count_checked948_v0}"
            __length_208=("${options[@]}")
            all_checked_237="$(( ${ret_count_checked948_v0__406_35} == ${#__length_208[@]} ))"
            from=0
            __length_209=("${checked_210[@]}")
            to="${#__length_209[@]}"
            for i_238 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
                checked_210["${i_238}"]="$(( ! ${all_checked_237} ))"
            done
            go_up__879_v0 "${display_count_198}"
            array_210=("")
            eprintf__871_v0 "\\x1b[9999D" array_210[@]
            render_multi_choose_page__945_v0 page_options_216[@] checked_210[@] "${page_start_217}" "${selected_197}" "${cursor}" "${display_count_198}" "${term_width_170}"
            continue
        elif [ "$([ "_${key_228}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
        __length_211="${cursor}"
        max_option_width_239="$(( $(( $(( ${term_width_170} - ${#__length_211} )) - 2 )) - 1 ))"
        # 2 for check mark
        if [ "$(( ${prev_page_230} != ${current_page_196} ))" != 0 ]; then
            get_page_options__942_v0 options[@] "${current_page_196}" "${page_size}"
            page_options_216=("${ret_get_page_options942_v0[@]}")
            get_page_start__943_v0 "${current_page_196}" "${page_size}"
            page_start_217="${ret_get_page_start943_v0}"
            if [ "${up_paged_232}" != 0 ]; then
                __length_212=("${page_options_216[@]}")
                selected_197="$(( ${#__length_212[@]} - 1 ))"
            fi
            go_up__879_v0 1
            remove_line__875_v0 "$(( ${display_count_198} - 1 ))"
            remove_current_line__876_v0 
            array_213=("")
            eprintf__871_v0 "\\x1b[9999D" array_213[@]
            render_multi_choose_page__945_v0 page_options_216[@] checked_210[@] "${page_start_217}" "${selected_197}" "${cursor}" "${display_count_198}" "${term_width_170}"
            render_page_indicator__946_v0 "${current_page_196}" "${total_pages_195}"
        elif [ "$(( ${prev_selected_229} != ${selected_197} ))" != 0 ]; then
            prev_global_240="$(( ${page_start_217} + ${prev_selected_229} ))"
            go_up__879_v0 "$(( ${display_count_198} - ${prev_selected_229} ))"
            array_214=("")
            eprintf__871_v0 "\\x1b[K" array_214[@]
            __length_215="${cursor}"
            print_blank__877_v0 "${#__length_215}"
            if [ "${checked_210[${prev_global_240}]}" != 0 ]; then
                cutoff_text__891_v0 "${page_options_216[${prev_selected_229}]}" "${max_option_width_239}"
                ret_cutoff_text891_v0__442_54="${ret_cutoff_text891_v0}"
                colored_secondary__854_v0 "✓ ""${ret_cutoff_text891_v0__442_54}"
                ret_colored_secondary854_v0__442_29="${ret_colored_secondary854_v0}"
                array_216=("")
                eprintf__871_v0 "${ret_colored_secondary854_v0__442_29}" array_216[@]
            else
                cutoff_text__891_v0 "${page_options_216[${prev_selected_229}]}" "${max_option_width_239}"
                ret_cutoff_text891_v0__444_36="${ret_cutoff_text891_v0}"
                array_217=("")
                eprintf__871_v0 "• ""${ret_cutoff_text891_v0__444_36}" array_217[@]
            fi
            diff_241="$(( ${selected_197} - ${prev_selected_229} ))"
            go_up_or_down__881_v0 "${diff_241}"
            array_218=("")
            eprintf__871_v0 "\\x1b[9999D" array_218[@]
            array_219=("")
            eprintf__871_v0 "\\x1b[K" array_219[@]
            new_global_242="$(( ${page_start_217} + ${selected_197} ))"
            check_mark_243="$(if [ "${checked_210[${new_global_242}]}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
            cutoff_text__891_v0 "${page_options_216[${selected_197}]}" "${max_option_width_239}"
            ret_cutoff_text891_v0__453_65="${ret_cutoff_text891_v0}"
            colored_secondary__854_v0 "${cursor}""${check_mark_243}""${ret_cutoff_text891_v0__453_65}"
            ret_colored_secondary854_v0__453_25="${ret_colored_secondary854_v0}"
            array_220=("")
            eprintf__871_v0 "${ret_colored_secondary854_v0__453_25}" array_220[@]
            go_down__880_v0 "$(( ${display_count_198} - ${selected_197} ))"
            array_221=("")
            eprintf__871_v0 "\\x1b[9999D" array_221[@]
        fi
    done
    total_lines_244="$(( ${display_count_198} + 2 ))"
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_244="$(( ${total_lines_244} + 1 ))"
    fi
    go_down__880_v0 1
    remove_line__875_v0 "$(( ${total_lines_244} - 1 ))"
    remove_current_line__876_v0 
    result_245=()
    from=0
    __length_223=("${options[@]}")
    to="${#__length_223[@]}"
    for i_246 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        if [ "${checked_210[${i_246}]}" != 0 ]; then
            result_245+=("${options[${i_246}]}")
        fi
    done
    stty_unlock__834_v0 
    show_cursor__883_v0 
    ret_xyl_multi_choose949_v0=("${result_245[@]}")
    return 0
}

print_choose_help__1026_v0() {
    echo "Usage: ./xylitol.sh choose [<options> ...] [flags]"
    echo ""
    colored_primary__853_v0 "choose"
    ret_colored_primary853_v0__7_12="${ret_colored_primary853_v0}"
    array_225=("")
    printf__106_v0 "${ret_colored_primary853_v0__7_12}" array_225[@]
    array_226=("")
    printf__106_v0 " - Choose from a list of options." array_226[@]
    echo ""
    echo ""
    colored_secondary__854_v0 "Arguments: "
    ret_colored_secondary854_v0__11_12="${ret_colored_secondary854_v0}"
    array_227=("")
    printf__106_v0 "${ret_colored_secondary854_v0__11_12}""
" array_227[@]
    echo "  [<options> ...]        List of options to choose from"
    echo ""
    colored_secondary__854_v0 "Flags: "
    ret_colored_secondary854_v0__14_12="${ret_colored_secondary854_v0}"
    array_228=("")
    printf__106_v0 "${ret_colored_secondary854_v0__14_12}""
" array_228[@]
    echo "  -h, --help             Show this help message"
    echo "  --limit=<number>       Enable multi-selection mode with a limit of selections"
    echo "  --no-limit             Enable multi-selection mode with no limit"
    echo "  --cursor=\"<text>\"      Set the cursor text (default: '> ')"
    echo "  --header=\"<text>\"      Set a header text to display above the options (ANSI escape supported)"
    echo "  --page-size=<number>   Set the number of options per page (default: 10)"
    echo ""
}

read_stdin_options__1077_v0() {
    options_151=()
    command_230="$([ -t 0 ] && echo "true" || echo "false")"
    __status=$?
    is_tty_152="${command_230}"
    if [ "$([ "_${is_tty_152}" != "_false" ]; echo $?)" != 0 ]; then
        while IFS= read -r line || [[ -n "$line" ]]; do options_151+=("$line"); done
        __status=$?
    fi
    ret_read_stdin_options1077_v0=("${options_151[@]}")
    return 0
}

execute_choose__1078_v0() {
    local parameters=("${!1}")
    cursor_141="> "
    colored_primary__853_v0 "Choose: "
    ret_colored_primary853_v0__17_30="${ret_colored_primary853_v0}"
    header_150="\\x1b[1m""${ret_colored_primary853_v0__17_30}"
    read_stdin_options__1077_v0 
    options_153=("${ret_read_stdin_options1077_v0[@]}")
    multi_154=0
    limit_155=-1
    page_size_156=10
    for param_157 in "${parameters[@]:2:9997}"; do
        match_regex__20_v0 "${param_157}" "^-h\$" 0
        ret_match_regex20_v0__25_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_157}" "^--help\$" 0
        ret_match_regex20_v0__25_43="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_157}" "^--cursor=.*\$" 0
        ret_match_regex20_v0__29_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_157}" "^--header=.*\$" 0
        ret_match_regex20_v0__33_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_157}" "^--limit=.*\$" 0
        ret_match_regex20_v0__37_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_157}" "^--no-limit\$" 0
        ret_match_regex20_v0__45_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_157}" "^--page-size=.*\$" 0
        ret_match_regex20_v0__48_13="${ret_match_regex20_v0}"
        if [ "$(( ${ret_match_regex20_v0__25_13} || ${ret_match_regex20_v0__25_43} ))" != 0 ]; then
            print_choose_help__1026_v0 
            exit 0
        elif [ "${ret_match_regex20_v0__29_13}" != 0 ]; then
            split__5_v0 "${param_157}" "="
            result_158=("${ret_split5_v0[@]}")
            cursor_141="${result_158[1]}"
        elif [ "${ret_match_regex20_v0__33_13}" != 0 ]; then
            split__5_v0 "${param_157}" "="
            result_159=("${ret_split5_v0[@]}")
            header_150="${result_159[1]}"
        elif [ "${ret_match_regex20_v0__37_13}" != 0 ]; then
            split__5_v0 "${param_157}" "="
            result_160=("${ret_split5_v0[@]}")
            parse_int__14_v0 "${result_160[1]}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__872_v0 "ERROR: Invalid limit value: ""${result_160[1]}""
" 31
                exit 1
            fi
            limit_155="${ret_parse_int14_v0}"
            multi_154=1
        elif [ "${ret_match_regex20_v0__45_13}" != 0 ]; then
            multi_154=1
        elif [ "${ret_match_regex20_v0__48_13}" != 0 ]; then
            split__5_v0 "${param_157}" "="
            result_161=("${ret_split5_v0[@]}")
            parse_int__14_v0 "${result_161[1]}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__872_v0 "ERROR: Invalid page-size value: ""${result_161[1]}""
" 31
                exit 1
            fi
            page_size_156="${ret_parse_int14_v0}"
        else
            options_153+=("${param_157}")
        fi
    done
    has_ansi_escape__884_v0 "${header_150}"
    ret_has_ansi_escape884_v0__61_42="${ret_has_ansi_escape884_v0}"
    escape_ansi__885_v0 "${header_150}"
    ret_escape_ansi885_v0__61_71="${ret_escape_ansi885_v0}"
    colored_primary__853_v0 "${header_150}"
    ret_colored_primary853_v0__61_109="${ret_colored_primary853_v0}"
    display_header_163="$(if [ "$(( $([ "_${header_150}" != "_" ]; echo $?) || ${ret_has_ansi_escape884_v0__61_42} ))" != 0 ]; then echo "${ret_escape_ansi885_v0__61_71}"; else echo "\\x1b[1m""${ret_colored_primary853_v0__61_109}"; fi)"
    if [ "${multi_154}" != 0 ]; then
        xyl_multi_choose__949_v0 options_153[@] "${cursor_141}" "${display_header_163}" "${limit_155}" "${page_size_156}"
        results_249=("${ret_xyl_multi_choose949_v0[@]}")
        join__8_v0 results_249[@] "
"
        ret_execute_choose1078_v0="${ret_join8_v0}"
        return 0
    fi
    xyl_choose__947_v0 options_153[@] "${cursor_141}" "${display_header_163}" "${page_size_156}"
    ret_execute_choose1078_v0="${ret_xyl_choose947_v0}"
    return 0
}

# Perl Extensions Utilities
command_232="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_31="$([ "_${command_232}" != "_No" ]; echo $?)"
command_233="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_32="$(( $(( ! ${_perl_disabled_31} )) && $([ "_${command_233}" != "_0" ]; echo $?) ))"
perl_get_cjk_width__1207_v0() {
    local text=$1
    if [ "$(( ! ${_perl_available_32} ))" != 0 ]; then
        ret_perl_get_cjk_width1207_v0=''
        return 1
    fi
    command_234="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1207_v0=''
        return "${__status}"
    fi
    width_str_296="${command_234}"
    parse_int__14_v0 "${width_str_296}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1207_v0=''
        return "${__status}"
    fi
    width_297="${ret_parse_int14_v0}"
    ret_perl_get_cjk_width1207_v0="${width_297}"
    return 0
}

perl_truncate_cjk__1208_v0() {
    local text=$1
    local max_width=$2
    if [ "$(( ! ${_perl_available_32} ))" != 0 ]; then
        ret_perl_truncate_cjk1208_v0=''
        return 1
    fi
    command_235="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text}" ${max_width} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1208_v0=''
        return "${__status}"
    fi
    result_300="${command_235}"
    ret_perl_truncate_cjk1208_v0="${result_300}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
stty_lock__1215_v0() {
    command_237="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_287="${command_237}"
    parse_int__14_v0 "${count_287}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_288="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_288} == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_288="$(( ${count_num_288} + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_288}
    __status=$?
}

stty_unlock__1216_v0() {
    command_238="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_335="${command_238}"
    parse_int__14_v0 "${count_335}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_336="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_336} > 0 ))" != 0 ]; then
        count_num_336="$(( ${count_num_336} - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_336}
        __status=$?
        if [ "$(( ${count_num_336} == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

get_term_size__1217_v0() {
    # Query terminal size with \x1b[18t, response format: \x1b[8;rows;colst
    command_239="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -rsd t _ignore height width < /dev/tty; echo "$height; $width")"
    __status=$?
    result_289="${command_239}"
    split__5_v0 "${result_289}" ";"
    parts_290=("${ret_split5_v0[@]}")
    __length_240=("${parts_290[@]}")
    if [ "$(( ${#__length_240[@]} != 2 ))" != 0 ]; then
        ret_get_term_size1217_v0=''
        return 1
    fi
    parse_int__14_v0 "${parts_290[0]}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_term_size1217_v0=''
        return "${__status}"
    fi
    rows_291="${ret_parse_int14_v0}"
    parse_int__14_v0 "${parts_290[1]}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_term_size1217_v0=''
        return "${__status}"
    fi
    cols_292="${ret_parse_int14_v0}"
    _term_size_34=("${cols_292}" "${rows_291}")
    _got_term_size_33=1
}

term_width__1219_v0() {
    if [ "$([ "_$(( ! ${_got_term_size_33} ))" != "_0" ]; echo $?)" != 0 ]; then
        get_term_size__1217_v0 
        __status=$?
    fi
    ret_term_width1219_v0="${_term_size_34[0]}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_35="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_36=0
_primary_color_37=(3 207 159 92)
_secondary_color_38=(3 118 206 94)
get_supports_truecolor__1230_v0() {
    env_var_get__98_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    config_278="${ret_env_var_get98_v0}"
    if [ "$([ "_${config_278}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_35="No"
        ret_get_supports_truecolor1230_v0=0
        return 0
    fi
    env_var_get__98_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_35="No"
        ret_get_supports_truecolor1230_v0=0
        return 0
    fi
    colorterm_279="${ret_env_var_get98_v0}"
    _supports_truecolor_35="$(if [ "$(( $([ "_${colorterm_279}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_279}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1230_v0="$([ "_${_supports_truecolor_35}" != "_Yes" ]; echo $?)"
    return 0
}

colored_rgb__1231_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    if [ "$([ "_${_supports_truecolor_35}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1231_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_35}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1230_v0 
        ret_get_supports_truecolor1230_v0__50_17="${ret_get_supports_truecolor1230_v0}"
        if [ "${ret_get_supports_truecolor1230_v0__50_17}" != 0 ]; then
            ret_colored_rgb1231_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
            return 0
        elif [ "$(( ${fallback} == 0 ))" != 0 ]; then
            ret_colored_rgb1231_v0="${message}"
            return 0
        else
            ret_colored_rgb1231_v0="\\x1b[${fallback}m""${message}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( ${fallback} == 0 ))" != 0 ]; then
            ret_colored_rgb1231_v0="${message}"
            return 0
        fi
        ret_colored_rgb1231_v0="\\x1b[${fallback}m""${message}""\\x1b[0m"
        return 0
    fi
}

background_rgb__1232_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    # Convert foreground color code to background color code
    # 30-37 -> 40-47, 90-97 -> 100-107
    bg_fallback_321="${fallback}"
    if [ "$(( $(( ${fallback} >= 30 )) && $(( ${fallback} <= 37 )) ))" != 0 ]; then
        bg_fallback_321="$(( ${fallback} + 10 ))"
    fi
    if [ "$(( $(( ${fallback} >= 90 )) && $(( ${fallback} <= 97 )) ))" != 0 ]; then
        bg_fallback_321="$(( ${fallback} + 10 ))"
    fi
    if [ "$([ "_${_supports_truecolor_35}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_background_rgb1232_v0="\\x1b[48;2;${r};${g};${b}m""${message}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_35}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1230_v0 
        ret_get_supports_truecolor1230_v0__92_17="${ret_get_supports_truecolor1230_v0}"
        if [ "${ret_get_supports_truecolor1230_v0__92_17}" != 0 ]; then
            ret_background_rgb1232_v0="\\x1b[48;2;${r};${g};${b}m""${message}""\\x1b[0m"
            return 0
        elif [ "$(( ${bg_fallback_321} == 0 ))" != 0 ]; then
            ret_background_rgb1232_v0="${message}"
            return 0
        else
            ret_background_rgb1232_v0="\\x1b[${bg_fallback_321}m""${message}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( ${bg_fallback_321} == 0 ))" != 0 ]; then
            ret_background_rgb1232_v0="${message}"
            return 0
        fi
        ret_background_rgb1232_v0="\\x1b[${bg_fallback_321}m""${message}""\\x1b[0m"
        return 0
    fi
}

inner_get_xylitol_colors__1233_v0() {
    if [ "$(( ! ${_got_xylitol_colors_36} ))" != 0 ]; then
        env_var_get__98_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        primary_env_272="${ret_env_var_get98_v0}"
        if [ "$([ "_${primary_env_272}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${primary_env_272}" ";"
            parts_273=("${ret_split5_v0[@]}")
            __length_245=("${parts_273[@]}")
            if [ "$(( ${#__length_245[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_273[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__115_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_273[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__116_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_273[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__117_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_273[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__118_21="${ret_parse_int14_v0}"
                _primary_color_37=("${ret_parse_int14_v0__115_21}" "${ret_parse_int14_v0__116_21}" "${ret_parse_int14_v0__117_21}" "${ret_parse_int14_v0__118_21}")
            fi
        fi
        env_var_get__98_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        secondary_env_274="${ret_env_var_get98_v0}"
        if [ "$([ "_${secondary_env_274}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${secondary_env_274}" ";"
            parts_275=("${ret_split5_v0[@]}")
            __length_247=("${parts_275[@]}")
            if [ "$(( ${#__length_247[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_275[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__128_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_275[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__129_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_275[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__130_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_275[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__131_21="${ret_parse_int14_v0}"
                _secondary_color_38=("${ret_parse_int14_v0__128_21}" "${ret_parse_int14_v0__129_21}" "${ret_parse_int14_v0__130_21}" "${ret_parse_int14_v0__131_21}")
            fi
        fi
        env_var_get__98_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        accent_env_276="${ret_env_var_get98_v0}"
        if [ "$([ "_${accent_env_276}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${accent_env_276}" ";"
            parts_277=("${ret_split5_v0[@]}")
            __length_249=("${parts_277[@]}")
            if [ "$(( ${#__length_249[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_277[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__141_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_277[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__142_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_277[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__143_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_277[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__144_21="${ret_parse_int14_v0}"
            fi
        fi
        _got_xylitol_colors_36=1
    fi
}

get_xylitol_colors__1234_v0() {
    inner_get_xylitol_colors__1233_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__112_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_36=1
}

colored_primary__1235_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_36} ))" != 0 ]; then
        get_xylitol_colors__1234_v0 
    fi
    colored_rgb__1231_v0 "${message}" "${_primary_color_37[0]}" "${_primary_color_37[1]}" "${_primary_color_37[2]}" "${_primary_color_37[3]}"
    ret_colored_primary1235_v0="${ret_colored_rgb1231_v0}"
    return 0
}

colored_secondary__1236_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_36} ))" != 0 ]; then
        get_xylitol_colors__1234_v0 
    fi
    colored_rgb__1231_v0 "${message}" "${_secondary_color_38[0]}" "${_secondary_color_38[1]}" "${_secondary_color_38[2]}" "${_secondary_color_38[3]}"
    ret_colored_secondary1236_v0="${ret_colored_rgb1231_v0}"
    return 0
}

background_secondary__1239_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_36} ))" != 0 ]; then
        get_xylitol_colors__1234_v0 
    fi
    background_rgb__1232_v0 "${message}" "${_secondary_color_38[0]}" "${_secondary_color_38[1]}" "${_secondary_color_38[2]}" "${_secondary_color_38[3]}"
    ret_background_secondary1239_v0="${ret_background_rgb1232_v0}"
    return 0
}

# // IO Functions /////
get_key__1251_v0() {
    command_251="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    var_332="${command_251}"
    if [ "$([ "_${var_332}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1251_v0="UP"
        return 0
    elif [ "$([ "_${var_332}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1251_v0="DOWN"
        return 0
    elif [ "$([ "_${var_332}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1251_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_332}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1251_v0="LEFT"
        return 0
    elif [ "$([ "_${var_332}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1251_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_332}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1251_v0="INPUT"
        return 0
    else
        ret_get_key1251_v0="${var_332}"
        return 0
    fi
}

eprintf__1253_v0() {
    local format=$1
    local args=("${!2}")
    args=("${format}" "${args[@]}")
    __status=$?
    printf "${args[@]}" >&2
    __status=$?
}

eprintf_colored__1254_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    array_252=("${message}")
    eprintf__1253_v0 "\\x1b[${color}m%s\\x1b[0m" array_252[@]
}

colored__1255_v0() {
    local message=$1
    local color=$2
    # Returns a text wrapped in color codes.
    ret_colored1255_v0="\\x1b[${color}m""${message}""\\x1b[0m"
    return 0
}

remove_line__1257_v0() {
    local cnt=$1
    printf '\x1b[2K\x1b[1A%.0s' $(seq ${cnt}) >&2
    __status=$?
    array_253=("")
    eprintf__1253_v0 "\\x1b[9999D" array_253[@]
}

remove_current_line__1258_v0() {
    array_254=("")
    eprintf__1253_v0 "\\x1b[2K\\x1b[9999D" array_254[@]
}

go_up__1261_v0() {
    local cnt=$1
    array_255=("")
    eprintf__1253_v0 "\\x1b[${cnt}A" array_255[@]
}

go_down__1262_v0() {
    local cnt=$1
    array_256=("")
    eprintf__1253_v0 "\\x1b[${cnt}B" array_256[@]
}

# move the cursor up or down `cnt` lines.
hide_cursor__1264_v0() {
    array_257=("")
    eprintf__1253_v0 "\\x1b[?25l" array_257[@]
}

show_cursor__1265_v0() {
    array_258=("")
    eprintf__1253_v0 "\\x1b[?25h" array_258[@]
}

# / Text Utilities /////
has_ansi_escape__1266_v0() {
    local text=$1
    # Check for ESC character (0x1B = 27) or literal \x1b[
    command_259="$([[ "${text}" == *$'\x1b'* || "${text}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    has_escape_285="${command_259}"
    ret_has_ansi_escape1266_v0="$([ "_${has_escape_285}" != "_1" ]; echo $?)"
    return 0
}

escape_ansi__1267_v0() {
    local text=$1
    command_260="$(printf '%s' "${text}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1267_v0="${command_260}"
    return 0
}

strip_ansi__1268_v0() {
    local text=$1
    command_261="$(printf "%s" "${text}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1268_v0="${command_261}"
    return 0
}

is_all_ascii__1269_v0() {
    local text=$1
    command_262="$(printf "%s" "${text}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    result_295="${command_262}"
    ret_is_all_ascii1269_v0="$([ "_${result_295}" != "_0" ]; echo $?)"
    return 0
}

get_visible_len__1270_v0() {
    local text=$1
    strip_ansi__1268_v0 "${text}"
    stripped_294="${ret_strip_ansi1268_v0}"
    # Check if text is all ASCII
    is_all_ascii__1269_v0 "${stripped_294}"
    ret_is_all_ascii1269_v0__140_12="${ret_is_all_ascii1269_v0}"
    if [ "$(( ! ${ret_is_all_ascii1269_v0__140_12} ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1207_v0 "${stripped_294}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            __length_263="${stripped_294}"
            ret_get_visible_len1270_v0="${#__length_263}"
            return 0
        fi
        ret_get_visible_len1270_v0="${ret_perl_get_cjk_width1207_v0}"
        return 0
    else
        __length_264="${stripped_294}"
        ret_get_visible_len1270_v0="${#__length_264}"
        return 0
    fi
}

truncate_text__1271_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__1270_v0 "${text}"
    visible_len_299="${ret_get_visible_len1270_v0}"
    if [ "$(( ${visible_len_299} <= ${max_width} ))" != 0 ]; then
        ret_truncate_text1271_v0="${text}"
        return 0
    fi
    is_all_ascii__1269_v0 "${text}"
    ret_is_all_ascii1269_v0__157_12="${ret_is_all_ascii1269_v0}"
    if [ "$(( ! ${ret_is_all_ascii1269_v0__157_12} ))" != 0 ]; then
        perl_truncate_cjk__1208_v0 "${text}" "${max_width}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text}" | cut -c1-${max_width}
            __status=$?
        fi
        ret_truncate_text1271_v0="${ret_perl_truncate_cjk1208_v0}"
        return 0
    fi
    command_265="$(printf "%s" "${text}" | cut -c1-${max_width})"
    __status=$?
    ret_truncate_text1271_v0="${command_265}"
    return 0
}

truncate_ansi__1272_v0() {
    local text=$1
    local max_width=$2
    has_ansi_escape__1266_v0 "${text}"
    ret_has_ansi_escape1266_v0__169_12="${ret_has_ansi_escape1266_v0}"
    if [ "$(( ! ${ret_has_ansi_escape1266_v0__169_12} ))" != 0 ]; then
        truncate_text__1271_v0 "${text}" "${max_width}"
        ret_truncate_ansi1272_v0="${ret_truncate_text1271_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    command_266="$([[ "${text}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    starts_with_ansi_301="${command_266}"
    # Replace \x1b[ with newline, then split
    command_267="$(t="${text}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    replaced_302="${command_267}"
    split__5_v0 "${replaced_302}" "
"
    parts_303=("${ret_split5_v0[@]}")
    result_304=""
    remaining_width_305="${max_width}"
    from=0
    __length_268=("${parts_303[@]}")
    to="${#__length_268[@]}"
    for idx_306 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        part_307="${parts_303[${idx_306}]}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( ${idx_306} == 0 )) && $([ "_${starts_with_ansi_301}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_307}" == "_" ]; echo $?) && $(( ${remaining_width_305} > 0 )) ))" != 0 ]; then
                truncate_text__1271_v0 "${part_307}" "${remaining_width_305}"
                truncated_308="${ret_truncate_text1271_v0}"
                result_304+="${truncated_308}"
                get_visible_len__1270_v0 "${truncated_308}"
                ret_get_visible_len1270_v0__193_36="${ret_get_visible_len1270_v0}"
                remaining_width_305="$(( ${remaining_width_305} - ${ret_get_visible_len1270_v0__193_36} ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            command_269="$(__p="${part_307}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            m_idx_309="${command_269}"
            if [ "$([ "_${m_idx_309}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                command_270="$(__p="${part_307}"; printf "%s" "${__p:0:${m_idx_309}}")"
                __status=$?
                ansi_params_310="${command_270}"
                result_304+="\\x1b[""${ansi_params_310}""m"
                # Rest is text content
                parse_int__14_v0 "${m_idx_309}"
                __status=$?
                m_idx_num_311="${ret_parse_int14_v0}"
                text_start_312="$(( ${m_idx_num_311} + 1 ))"
                command_271="$(__p="${part_307}"; printf "%s" "${__p:${text_start_312}}")"
                __status=$?
                text_part_313="${command_271}"
                if [ "$(( $([ "_${text_part_313}" == "_" ]; echo $?) && $(( ${remaining_width_305} > 0 )) ))" != 0 ]; then
                    truncate_text__1271_v0 "${text_part_313}" "${remaining_width_305}"
                    truncated_314="${ret_truncate_text1271_v0}"
                    result_304+="${truncated_314}"
                    get_visible_len__1270_v0 "${truncated_314}"
                    ret_get_visible_len1270_v0__210_40="${ret_get_visible_len1270_v0}"
                    remaining_width_305="$(( ${remaining_width_305} - ${ret_get_visible_len1270_v0__210_40} ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_307}" == "_" ]; echo $?) && $(( ${remaining_width_305} > 0 )) ))" != 0 ]; then
                    truncate_text__1271_v0 "${part_307}" "${remaining_width_305}"
                    truncated_315="${ret_truncate_text1271_v0}"
                    result_304+="${truncated_315}"
                    get_visible_len__1270_v0 "${truncated_315}"
                    remaining_width_305="$(( ${remaining_width_305} - ${ret_get_visible_len1270_v0__217_40} ))"
                fi
            fi
        fi
    done
    ret_truncate_ansi1272_v0="${result_304}"
    return 0
}

cutoff_text__1273_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__1270_v0 "${text}"
    visible_len_298="${ret_get_visible_len1270_v0}"
    if [ "$(( ${visible_len_298} <= ${max_width} ))" != 0 ]; then
        ret_cutoff_text1273_v0="${text}"
        return 0
    fi
    truncate_ansi__1272_v0 "${text}" "$(( ${max_width} - 3 ))"
    ret_truncate_ansi1272_v0__233_12="${ret_truncate_ansi1272_v0}"
    ret_cutoff_text1273_v0="${ret_truncate_ansi1272_v0__233_12}""..."
    return 0
}

# // Application Utilities /////
render_tooltip__1274_v0() {
    local items=("${!1}")
    local total_len=$2
    local term_width=$3
    separator_322=" • "
    separator_len_323=3
    # Fast path: no truncation needed
    if [ "$(( ${total_len} <= ${term_width} ))" != 0 ]; then
        iter_324=0
        while :
        do
            __length_272=("${items[@]}")
            if [ "$(( ${iter_324} >= ${#__length_272[@]} ))" != 0 ]; then
                break
            elif [ "$(( ${iter_324} > 0 ))" != 0 ]; then
                eprintf_colored__1254_v0 "${separator_322}" 90
            fi
            colored__1255_v0 "${items[$(( ${iter_324} + 1 ))]}" 2
            ret_colored1255_v0__258_41="${ret_colored1255_v0}"
            array_273=("")
            eprintf__1253_v0 "${items[${iter_324}]}"" ""${ret_colored1255_v0__258_41}" array_273[@]
            iter_324="$(( ${iter_324} + 2 ))"
        done
    else
        # Slow path: truncate
        current_len_325=0
        first_326=1
        iter_327=0
        while :
        do
            __length_274=("${items[@]}")
            if [ "$(( ${iter_327} >= ${#__length_274[@]} ))" != 0 ]; then
                break
            fi
            key_328="${items[${iter_327}]}"
            action_329="${items[$(( ${iter_327} + 1 ))]}"
            __length_275="${key_328}"
            __length_276="${action_329}"
            part_len_330="$(( $(( ${#__length_275} + 1 )) + ${#__length_276} ))"
            needed_331="${part_len_330}"
            if [ "$(( ! ${first_326} ))" != 0 ]; then
                needed_331="$(( ${needed_331} + ${separator_len_323} ))"
            fi
            if [ "$(( $(( ${current_len_325} + ${needed_331} )) > ${term_width} ))" != 0 ]; then
                break
            fi
            if [ "$(( ! ${first_326} ))" != 0 ]; then
                eprintf_colored__1254_v0 "${separator_322}" 90
            fi
            colored__1255_v0 "${action_329}" 2
            ret_colored1255_v0__286_33="${ret_colored1255_v0}"
            array_277=("")
            eprintf__1253_v0 "${key_328}"" ""${ret_colored1255_v0__286_33}" array_277[@]
            current_len_325="$(( ${current_len_325} + ${needed_331} ))"
            first_326=0
            iter_327="$(( ${iter_327} + 2 ))"
        done
    fi
}

render_confirm_options__1324_v0() {
    local selected=$1
    local term_width=$2
    small_317="$(( ${term_width} < 30 ))"
    yes_label_318="$(if [ "${small_317}" != 0 ]; then echo " Yes "; else echo "    Yes    "; fi)"
    no_label_319="$(if [ "${small_317}" != 0 ]; then echo " No "; else echo "    No    "; fi)"
    gap_320="$(if [ "${small_317}" != 0 ]; then echo " "; else echo "  "; fi)"
    array_278=("")
    eprintf__1253_v0 " " array_278[@]
    if [ "${selected}" != 0 ]; then
        # Yes selected
        background_secondary__1239_v0 "${yes_label_318}"
        ret_background_secondary1239_v0__15_30="${ret_background_secondary1239_v0}"
        array_279=("")
        eprintf__1253_v0 "\\x1b[97m""${ret_background_secondary1239_v0__15_30}" array_279[@]
        array_280=("")
        eprintf__1253_v0 "${gap_320}" array_280[@]
        # No not selected (dim)
        array_281=("")
        eprintf__1253_v0 "\\x1b[49;37m""${no_label_319}""\\x1b[0m" array_281[@]
    else
        # No selected
        array_282=("")
        eprintf__1253_v0 "\\x1b[49;37m""${yes_label_318}""\\x1b[0m" array_282[@]
        array_283=("")
        eprintf__1253_v0 "${gap_320}" array_283[@]
        background_secondary__1239_v0 "${no_label_319}"
        ret_background_secondary1239_v0__23_30="${ret_background_secondary1239_v0}"
        array_284=("")
        eprintf__1253_v0 "\\x1b[97m""${ret_background_secondary1239_v0__23_30}" array_284[@]
    fi
}

xyl_confirm__1325_v0() {
    local header=$1
    local default_yes=$2
    stty_lock__1215_v0 
    hide_cursor__1264_v0 
    term_width__1219_v0 
    term_width_293="${ret_term_width1219_v0}"
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__1273_v0 "${header}" "${term_width_293}"
        ret_cutoff_text1273_v0__45_17="${ret_cutoff_text1273_v0}"
        array_285=("")
        eprintf__1253_v0 "${ret_cutoff_text1273_v0__45_17}""

" array_285[@]
    fi
    selected_316="${default_yes}"
    # Render initial options
    render_confirm_options__1324_v0 "${selected_316}" "${term_width_293}"
    array_286=("")
    eprintf__1253_v0 "

" array_286[@]
    # "←→ select • enter confirm • y yes • n no" = 9 + 3 + 13 + 3 + 5 + 3 + 4 = 40
    array_287=("←→" "select" "enter" "confirm" "y" "yes" "n" "no")
    render_tooltip__1274_v0 array_287[@] 40 "${term_width_293}"
    go_up__1261_v0 2
    while :
    do
        get_key__1251_v0 
        key_333="${ret_get_key1251_v0}"
        if [ "$(( $(( $(( $([ "_${key_333}" != "_LEFT" ]; echo $?) || $([ "_${key_333}" != "_h" ]; echo $?) )) || $([ "_${key_333}" != "_RIGHT" ]; echo $?) )) || $([ "_${key_333}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "${selected_316}" != 0 ]; then
                selected_316=0
                array_288=("")
                eprintf__1253_v0 "\\x1b[9999D\\x1b[K" array_288[@]
                render_confirm_options__1324_v0 "${selected_316}" "${term_width_293}"
            elif [ "$(( ! ${selected_316} ))" != 0 ]; then
                selected_316=1
                array_289=("")
                eprintf__1253_v0 "\\x1b[9999D\\x1b[K" array_289[@]
                render_confirm_options__1324_v0 "${selected_316}" "${term_width_293}"
            fi
        elif [ "$(( $([ "_${key_333}" != "_y" ]; echo $?) || $([ "_${key_333}" != "_Y" ]; echo $?) ))" != 0 ]; then
            selected_316=1
            break
        elif [ "$(( $([ "_${key_333}" != "_n" ]; echo $?) || $([ "_${key_333}" != "_N" ]; echo $?) ))" != 0 ]; then
            selected_316=0
            break
        elif [ "$([ "_${key_333}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
    done
    # Clean up: remove options line and hint line
    total_lines_334=4
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_334="$(( ${total_lines_334} + 1 ))"
    fi
    go_down__1262_v0 2
    remove_line__1257_v0 "$(( ${total_lines_334} - 1 ))"
    remove_current_line__1258_v0 
    stty_unlock__1216_v0 
    show_cursor__1265_v0 
    ret_xyl_confirm1325_v0="${selected_316}"
    return 0
}

print_confirm_help__1401_v0() {
    echo "Usage: ./xylitol.sh confirm [flags]"
    echo ""
    colored_primary__1235_v0 "confirm"
    ret_colored_primary1235_v0__7_12="${ret_colored_primary1235_v0}"
    array_290=("")
    printf__106_v0 "${ret_colored_primary1235_v0__7_12}" array_290[@]
    array_291=("")
    printf__106_v0 " - Display a Yes/No confirmation dialog." array_291[@]
    echo ""
    echo ""
    colored_secondary__1236_v0 "Flags: "
    ret_colored_secondary1236_v0__11_12="${ret_colored_secondary1236_v0}"
    array_292=("")
    printf__106_v0 "${ret_colored_secondary1236_v0__11_12}""
" array_292[@]
    echo "  -h, --help             Show this help message"
    echo "  --header=\"<text>\"      Set a header text to display above the options (ANSI escape supported)"
    echo "  --default=<yes|no>     Set the default selection (default: yes)"
    echo ""
}

execute_confirm__1452_v0() {
    local parameters=("${!1}")
    colored_primary__1235_v0 "Are you sure?"
    ret_colored_primary1235_v0__9_30="${ret_colored_primary1235_v0}"
    header_280="\\x1b[1m""${ret_colored_primary1235_v0__9_30}"
    default_yes_281=1
    for param_282 in "${parameters[@]}"; do
        match_regex__20_v0 "${param_282}" "^-h\$" 0
        ret_match_regex20_v0__14_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_282}" "^--help\$" 0
        ret_match_regex20_v0__14_43="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_282}" "^--header=.*\$" 0
        ret_match_regex20_v0__18_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_282}" "^--default=.*\$" 0
        ret_match_regex20_v0__22_13="${ret_match_regex20_v0}"
        if [ "$(( ${ret_match_regex20_v0__14_13} || ${ret_match_regex20_v0__14_43} ))" != 0 ]; then
            print_confirm_help__1401_v0 
            exit 0
        elif [ "${ret_match_regex20_v0__18_13}" != 0 ]; then
            split__5_v0 "${param_282}" "="
            result_283=("${ret_split5_v0[@]}")
            header_280="${result_283[1]}"
        elif [ "${ret_match_regex20_v0__22_13}" != 0 ]; then
            split__5_v0 "${param_282}" "="
            result_284=("${ret_split5_v0[@]}")
            if [ "$(( $([ "_${result_284[1]}" != "_yes" ]; echo $?) || $([ "_${result_284[1]}" != "_y" ]; echo $?) ))" != 0 ]; then
                default_yes_281=1
            elif [ "$(( $([ "_${result_284[1]}" != "_no" ]; echo $?) || $([ "_${result_284[1]}" != "_n" ]; echo $?) ))" != 0 ]; then
                default_yes_281=0
            else
                eprintf_colored__1254_v0 "ERROR: Invalid default value: ""${result_284[1]}"". Use 'yes' or 'no'.
" 31
                exit 1
            fi
        fi
    done
    has_ansi_escape__1266_v0 "${header_280}"
    ret_has_ansi_escape1266_v0__36_42="${ret_has_ansi_escape1266_v0}"
    escape_ansi__1267_v0 "${header_280}"
    ret_escape_ansi1267_v0__36_71="${ret_escape_ansi1267_v0}"
    colored_primary__1235_v0 "${header_280}"
    ret_colored_primary1235_v0__36_109="${ret_colored_primary1235_v0}"
    display_header_286="$(if [ "$(( $([ "_${header_280}" != "_" ]; echo $?) || ${ret_has_ansi_escape1266_v0__36_42} ))" != 0 ]; then echo "${ret_escape_ansi1267_v0__36_71}"; else echo "\\x1b[1m""${ret_colored_primary1235_v0__36_109}"; fi)"
    xyl_confirm__1325_v0 "${display_header_286}" "${default_yes_281}"
    result_337="${ret_xyl_confirm1325_v0}"
    ret_execute_confirm1452_v0="$(if [ "${result_337}" != 0 ]; then echo "yes"; else echo "no"; fi)"
    return 0
}

get_directory_entries__1570_v0() {
    local path=$1
    command_293="$(ls -lA "${path}" 2>/dev/null | tail -n +2)"
    __status=$?
    raw_365="${command_293}"
    command_294="$(ls -lA "${path}" | tail -n +2 | sed -E 's/^(.).*/\1/')"
    __status=$?
    types_366="${command_294}"
    command_295="$(ls -1A "${path}")"
    __status=$?
    names_367="${command_295}"
    split__5_v0 "${types_366}" "
"
    types_368=("${ret_split5_v0[@]}")
    split__5_v0 "${raw_365}" "
"
    raw_369=("${ret_split5_v0[@]}")
    split__5_v0 "${names_367}" "
"
    names_370=("${ret_split5_v0[@]}")
    entries_371=()
    from=0
    __length_297=("${raw_369[@]}")
    to="${#__length_297[@]}"
    for i_372 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        file_type_373="f"
        target_374=""
        if [ "$([ "_${types_368[${i_372}]}" != "_-" ]; echo $?)" != 0 ]; then
            file_type_373="f"
        elif [ "$([ "_${types_368[${i_372}]}" != "_l" ]; echo $?)" != 0 ]; then
            command_298="$(echo ${raw_369[${i_372}]} | sed 's/.*-> //')"
            __status=$?
            target_374="${command_298}"
            file_type_373="l"
        fi
        if [ "$([ "_${file_type_373}" != "_l" ]; echo $?)" != 0 ]; then
            entries_371+=("${names_370[${i_372}]}	${types_368[${i_372}]}	${target_374}")
        else
            entries_371+=("${names_370[${i_372}]}	${types_368[${i_372}]}")
        fi
    done
    ret_get_directory_entries1570_v0=("${entries_371[@]}")
    return 0
}

parse_entry__1571_v0() {
    local entry=$1
    split__5_v0 "${entry}" "	"
    ret_parse_entry1571_v0=("${ret_split5_v0[@]}")
    return 0
}

get_cwd__1572_v0() {
    command_301="$(pwd)"
    __status=$?
    ret_get_cwd1572_v0="${command_301}"
    return 0
}

normalize_path__1573_v0() {
    local path=$1
    command_302="$(cd "${path}" 2>/dev/null && pwd)"
    __status=$?
    normalized_364="${command_302}"
    if [ "$([ "_${normalized_364}" != "_" ]; echo $?)" != 0 ]; then
        ret_normalize_path1573_v0="${path}"
        return 0
    fi
    ret_normalize_path1573_v0="${normalized_364}"
    return 0
}

path_join__1575_v0() {
    local base=$1
    local child=$2
    if [ "$([ "_${base}" != "_/" ]; echo $?)" != 0 ]; then
        ret_path_join1575_v0="/""${child}"
        return 0
    fi
    ret_path_join1575_v0="${base}""/""${child}"
    return 0
}

get_parent_dir__1576_v0() {
    local path=$1
    command_303="$(dirname "${path}")"
    __status=$?
    parent_470="${command_303}"
    ret_get_parent_dir1576_v0="${parent_470}"
    return 0
}

# Perl Extensions Utilities
command_304="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_40="$([ "_${command_304}" != "_No" ]; echo $?)"
command_305="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_41="$(( $(( ! ${_perl_disabled_40} )) && $([ "_${command_305}" != "_0" ]; echo $?) ))"
# global variables to store terminal size
# (prevent multiple queries in one session)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
stty_lock__1593_v0() {
    command_307="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_355="${command_307}"
    parse_int__14_v0 "${count_355}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_356="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_356} == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_356="$(( ${count_num_356} + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_356}
    __status=$?
}

stty_unlock__1594_v0() {
    command_308="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_384="${command_308}"
    parse_int__14_v0 "${count_384}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_385="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_385} > 0 ))" != 0 ]; then
        count_num_385="$(( ${count_num_385} - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_385}
        __status=$?
        if [ "$(( ${count_num_385} == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

get_term_size__1595_v0() {
    # Query terminal size with \x1b[18t, response format: \x1b[8;rows;colst
    command_309="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -rsd t _ignore height width < /dev/tty; echo "$height; $width")"
    __status=$?
    result_357="${command_309}"
    split__5_v0 "${result_357}" ";"
    parts_358=("${ret_split5_v0[@]}")
    __length_310=("${parts_358[@]}")
    if [ "$(( ${#__length_310[@]} != 2 ))" != 0 ]; then
        ret_get_term_size1595_v0=''
        return 1
    fi
    parse_int__14_v0 "${parts_358[0]}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_term_size1595_v0=''
        return "${__status}"
    fi
    rows_359="${ret_parse_int14_v0}"
    parse_int__14_v0 "${parts_358[1]}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_term_size1595_v0=''
        return "${__status}"
    fi
    cols_360="${ret_parse_int14_v0}"
    _term_size_43=("${cols_360}" "${rows_359}")
    _got_term_size_42=1
}

term_width__1597_v0() {
    if [ "$([ "_$(( ! ${_got_term_size_42} ))" != "_0" ]; echo $?)" != 0 ]; then
        get_term_size__1595_v0 
        __status=$?
    fi
    ret_term_width1597_v0="${_term_size_43[0]}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_44="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_45=0
_primary_color_46=(3 207 159 92)
_secondary_color_47=(3 118 206 94)
_accent_color_48=(234 72 121 95)
get_supports_truecolor__1608_v0() {
    env_var_get__98_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    config_350="${ret_env_var_get98_v0}"
    if [ "$([ "_${config_350}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_44="No"
        ret_get_supports_truecolor1608_v0=0
        return 0
    fi
    env_var_get__98_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_44="No"
        ret_get_supports_truecolor1608_v0=0
        return 0
    fi
    colorterm_351="${ret_env_var_get98_v0}"
    _supports_truecolor_44="$(if [ "$(( $([ "_${colorterm_351}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_351}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1608_v0="$([ "_${_supports_truecolor_44}" != "_Yes" ]; echo $?)"
    return 0
}

colored_rgb__1609_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    if [ "$([ "_${_supports_truecolor_44}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1609_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_44}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1608_v0 
        ret_get_supports_truecolor1608_v0__50_17="${ret_get_supports_truecolor1608_v0}"
        if [ "${ret_get_supports_truecolor1608_v0__50_17}" != 0 ]; then
            ret_colored_rgb1609_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
            return 0
        elif [ "$(( ${fallback} == 0 ))" != 0 ]; then
            ret_colored_rgb1609_v0="${message}"
            return 0
        else
            ret_colored_rgb1609_v0="\\x1b[${fallback}m""${message}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( ${fallback} == 0 ))" != 0 ]; then
            ret_colored_rgb1609_v0="${message}"
            return 0
        fi
        ret_colored_rgb1609_v0="\\x1b[${fallback}m""${message}""\\x1b[0m"
        return 0
    fi
}

inner_get_xylitol_colors__1611_v0() {
    if [ "$(( ! ${_got_xylitol_colors_45} ))" != 0 ]; then
        env_var_get__98_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        primary_env_344="${ret_env_var_get98_v0}"
        if [ "$([ "_${primary_env_344}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${primary_env_344}" ";"
            parts_345=("${ret_split5_v0[@]}")
            __length_315=("${parts_345[@]}")
            if [ "$(( ${#__length_315[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_345[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__115_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_345[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__116_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_345[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__117_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_345[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__118_21="${ret_parse_int14_v0}"
                _primary_color_46=("${ret_parse_int14_v0__115_21}" "${ret_parse_int14_v0__116_21}" "${ret_parse_int14_v0__117_21}" "${ret_parse_int14_v0__118_21}")
            fi
        fi
        env_var_get__98_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        secondary_env_346="${ret_env_var_get98_v0}"
        if [ "$([ "_${secondary_env_346}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${secondary_env_346}" ";"
            parts_347=("${ret_split5_v0[@]}")
            __length_317=("${parts_347[@]}")
            if [ "$(( ${#__length_317[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_347[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__128_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_347[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__129_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_347[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__130_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_347[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__131_21="${ret_parse_int14_v0}"
                _secondary_color_47=("${ret_parse_int14_v0__128_21}" "${ret_parse_int14_v0__129_21}" "${ret_parse_int14_v0__130_21}" "${ret_parse_int14_v0__131_21}")
            fi
        fi
        env_var_get__98_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        accent_env_348="${ret_env_var_get98_v0}"
        if [ "$([ "_${accent_env_348}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${accent_env_348}" ";"
            parts_349=("${ret_split5_v0[@]}")
            __length_319=("${parts_349[@]}")
            if [ "$(( ${#__length_319[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_349[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__141_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_349[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__142_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_349[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__143_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_349[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__144_21="${ret_parse_int14_v0}"
                _accent_color_48=("${ret_parse_int14_v0__141_21}" "${ret_parse_int14_v0__142_21}" "${ret_parse_int14_v0__143_21}" "${ret_parse_int14_v0__144_21}")
            fi
        fi
        _got_xylitol_colors_45=1
    fi
}

get_xylitol_colors__1612_v0() {
    inner_get_xylitol_colors__1611_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__112_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_45=1
}

colored_primary__1613_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_45} ))" != 0 ]; then
        get_xylitol_colors__1612_v0 
    fi
    colored_rgb__1609_v0 "${message}" "${_primary_color_46[0]}" "${_primary_color_46[1]}" "${_primary_color_46[2]}" "${_primary_color_46[3]}"
    ret_colored_primary1613_v0="${ret_colored_rgb1609_v0}"
    return 0
}

colored_secondary__1614_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_45} ))" != 0 ]; then
        get_xylitol_colors__1612_v0 
    fi
    colored_rgb__1609_v0 "${message}" "${_secondary_color_47[0]}" "${_secondary_color_47[1]}" "${_secondary_color_47[2]}" "${_secondary_color_47[3]}"
    ret_colored_secondary1614_v0="${ret_colored_rgb1609_v0}"
    return 0
}

colored_accent__1615_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_45} ))" != 0 ]; then
        get_xylitol_colors__1612_v0 
    fi
    colored_rgb__1609_v0 "${message}" "${_accent_color_48[0]}" "${_accent_color_48[1]}" "${_accent_color_48[2]}" "${_accent_color_48[3]}"
    ret_colored_accent1615_v0="${ret_colored_rgb1609_v0}"
    return 0
}

# // IO Functions /////
eprintf__1631_v0() {
    local format=$1
    local args=("${!2}")
    args=("${format}" "${args[@]}")
    __status=$?
    printf "${args[@]}" >&2
    __status=$?
}

eprintf_colored__1632_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    array_321=("${message}")
    eprintf__1631_v0 "\\x1b[${color}m%s\\x1b[0m" array_321[@]
}

remove_current_line__1636_v0() {
    array_322=("")
    eprintf__1631_v0 "\\x1b[2K\\x1b[9999D" array_322[@]
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# // Application Utilities /////
# Perl Extensions Utilities
command_323="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_49="$([ "_${command_323}" != "_No" ]; echo $?)"
command_324="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_50="$(( $(( ! ${_perl_disabled_49} )) && $([ "_${command_324}" != "_0" ]; echo $?) ))"
perl_get_cjk_width__1780_v0() {
    local text=$1
    if [ "$(( ! ${_perl_available_50} ))" != 0 ]; then
        ret_perl_get_cjk_width1780_v0=''
        return 1
    fi
    command_325="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1780_v0=''
        return "${__status}"
    fi
    width_str_398="${command_325}"
    parse_int__14_v0 "${width_str_398}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1780_v0=''
        return "${__status}"
    fi
    width_399="${ret_parse_int14_v0}"
    ret_perl_get_cjk_width1780_v0="${width_399}"
    return 0
}

perl_truncate_cjk__1781_v0() {
    local text=$1
    local max_width=$2
    if [ "$(( ! ${_perl_available_50} ))" != 0 ]; then
        ret_perl_truncate_cjk1781_v0=''
        return 1
    fi
    command_326="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text}" ${max_width} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1781_v0=''
        return "${__status}"
    fi
    result_403="${command_326}"
    ret_perl_truncate_cjk1781_v0="${result_403}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
stty_lock__1788_v0() {
    command_328="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_387="${command_328}"
    parse_int__14_v0 "${count_387}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_388="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_388} == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_388="$(( ${count_num_388} + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_388}
    __status=$?
}

stty_unlock__1789_v0() {
    command_329="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_461="${command_329}"
    parse_int__14_v0 "${count_461}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_462="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_462} > 0 ))" != 0 ]; then
        count_num_462="$(( ${count_num_462} - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_462}
        __status=$?
        if [ "$(( ${count_num_462} == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

get_term_size__1790_v0() {
    # Query terminal size with \x1b[18t, response format: \x1b[8;rows;colst
    command_330="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -rsd t _ignore height width < /dev/tty; echo "$height; $width")"
    __status=$?
    result_389="${command_330}"
    split__5_v0 "${result_389}" ";"
    parts_390=("${ret_split5_v0[@]}")
    __length_331=("${parts_390[@]}")
    if [ "$(( ${#__length_331[@]} != 2 ))" != 0 ]; then
        ret_get_term_size1790_v0=''
        return 1
    fi
    parse_int__14_v0 "${parts_390[0]}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_term_size1790_v0=''
        return "${__status}"
    fi
    rows_391="${ret_parse_int14_v0}"
    parse_int__14_v0 "${parts_390[1]}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_term_size1790_v0=''
        return "${__status}"
    fi
    cols_392="${ret_parse_int14_v0}"
    _term_size_52=("${cols_392}" "${rows_391}")
    _got_term_size_51=1
}

term_width__1792_v0() {
    if [ "$([ "_$(( ! ${_got_term_size_51} ))" != "_0" ]; echo $?)" != 0 ]; then
        get_term_size__1790_v0 
        __status=$?
    fi
    ret_term_width1792_v0="${_term_size_52[0]}"
    return 0
}

term_height__1793_v0() {
    if [ "$([ "_$(( ! ${_got_term_size_51} ))" != "_0" ]; echo $?)" != 0 ]; then
        get_term_size__1790_v0 
        __status=$?
    fi
    ret_term_height1793_v0="${_term_size_52[1]}"
    return 0
}

# A global variable indicating if the terminal supports truecolor.
# "None" or "Yes" or "No"
# 
# This value is only updated by the `get_supports_truecolor` function
# executed by `colored_rgb` on its first call.
_supports_truecolor_53="None"
# A global variable indicating if the Xylitol colors have been loaded from environment variables.
_got_xylitol_colors_54=0
_secondary_color_56=(3 118 206 94)
get_supports_truecolor__1803_v0() {
    env_var_get__98_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    config_449="${ret_env_var_get98_v0}"
    if [ "$([ "_${config_449}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_53="No"
        ret_get_supports_truecolor1803_v0=0
        return 0
    fi
    env_var_get__98_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_53="No"
        ret_get_supports_truecolor1803_v0=0
        return 0
    fi
    colorterm_450="${ret_env_var_get98_v0}"
    _supports_truecolor_53="$(if [ "$(( $([ "_${colorterm_450}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_450}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1803_v0="$([ "_${_supports_truecolor_53}" != "_Yes" ]; echo $?)"
    return 0
}

colored_rgb__1804_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    if [ "$([ "_${_supports_truecolor_53}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1804_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_53}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1803_v0 
        ret_get_supports_truecolor1803_v0__50_17="${ret_get_supports_truecolor1803_v0}"
        if [ "${ret_get_supports_truecolor1803_v0__50_17}" != 0 ]; then
            ret_colored_rgb1804_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
            return 0
        elif [ "$(( ${fallback} == 0 ))" != 0 ]; then
            ret_colored_rgb1804_v0="${message}"
            return 0
        else
            ret_colored_rgb1804_v0="\\x1b[${fallback}m""${message}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( ${fallback} == 0 ))" != 0 ]; then
            ret_colored_rgb1804_v0="${message}"
            return 0
        fi
        ret_colored_rgb1804_v0="\\x1b[${fallback}m""${message}""\\x1b[0m"
        return 0
    fi
}

inner_get_xylitol_colors__1806_v0() {
    if [ "$(( ! ${_got_xylitol_colors_54} ))" != 0 ]; then
        env_var_get__98_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        primary_env_443="${ret_env_var_get98_v0}"
        if [ "$([ "_${primary_env_443}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${primary_env_443}" ";"
            parts_444=("${ret_split5_v0[@]}")
            __length_336=("${parts_444[@]}")
            if [ "$(( ${#__length_336[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_444[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__115_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_444[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__116_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_444[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__117_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_444[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__118_21="${ret_parse_int14_v0}"
            fi
        fi
        env_var_get__98_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        secondary_env_445="${ret_env_var_get98_v0}"
        if [ "$([ "_${secondary_env_445}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${secondary_env_445}" ";"
            parts_446=("${ret_split5_v0[@]}")
            __length_338=("${parts_446[@]}")
            if [ "$(( ${#__length_338[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_446[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__128_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_446[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__129_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_446[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__130_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_446[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__131_21="${ret_parse_int14_v0}"
                _secondary_color_56=("${ret_parse_int14_v0__128_21}" "${ret_parse_int14_v0__129_21}" "${ret_parse_int14_v0__130_21}" "${ret_parse_int14_v0__131_21}")
            fi
        fi
        env_var_get__98_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        accent_env_447="${ret_env_var_get98_v0}"
        if [ "$([ "_${accent_env_447}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${accent_env_447}" ";"
            parts_448=("${ret_split5_v0[@]}")
            __length_340=("${parts_448[@]}")
            if [ "$(( ${#__length_340[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_448[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__141_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_448[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__142_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_448[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__143_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_448[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__144_21="${ret_parse_int14_v0}"
            fi
        fi
        _got_xylitol_colors_54=1
    fi
}

get_xylitol_colors__1807_v0() {
    inner_get_xylitol_colors__1806_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__112_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_54=1
}

colored_secondary__1809_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_54} ))" != 0 ]; then
        get_xylitol_colors__1807_v0 
    fi
    colored_rgb__1804_v0 "${message}" "${_secondary_color_56[0]}" "${_secondary_color_56[1]}" "${_secondary_color_56[2]}" "${_secondary_color_56[3]}"
    ret_colored_secondary1809_v0="${ret_colored_rgb1804_v0}"
    return 0
}

# // IO Functions /////
get_key__1824_v0() {
    command_342="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    var_453="${command_342}"
    if [ "$([ "_${var_453}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1824_v0="UP"
        return 0
    elif [ "$([ "_${var_453}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1824_v0="DOWN"
        return 0
    elif [ "$([ "_${var_453}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1824_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_453}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1824_v0="LEFT"
        return 0
    elif [ "$([ "_${var_453}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1824_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_453}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1824_v0="INPUT"
        return 0
    else
        ret_get_key1824_v0="${var_453}"
        return 0
    fi
}

eprintf__1826_v0() {
    local format=$1
    local args=("${!2}")
    args=("${format}" "${args[@]}")
    __status=$?
    printf "${args[@]}" >&2
    __status=$?
}

eprintf_colored__1827_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    array_343=("${message}")
    eprintf__1826_v0 "\\x1b[${color}m%s\\x1b[0m" array_343[@]
}

colored__1828_v0() {
    local message=$1
    local color=$2
    # Returns a text wrapped in color codes.
    ret_colored1828_v0="\\x1b[${color}m""${message}""\\x1b[0m"
    return 0
}

remove_line__1830_v0() {
    local cnt=$1
    printf '\x1b[2K\x1b[1A%.0s' $(seq ${cnt}) >&2
    __status=$?
    array_344=("")
    eprintf__1826_v0 "\\x1b[9999D" array_344[@]
}

remove_current_line__1831_v0() {
    array_345=("")
    eprintf__1826_v0 "\\x1b[2K\\x1b[9999D" array_345[@]
}

print_blank__1832_v0() {
    local cnt=$1
    printf '%*s' "${cnt}" ' ' >&2
    __status=$?
}

new_line__1833_v0() {
    local cnt=$1
    from=0
    to="${cnt}"
    for i_423 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        array_346=("")
        eprintf__1826_v0 "
" array_346[@]
    done
}

go_up__1834_v0() {
    local cnt=$1
    array_347=("")
    eprintf__1826_v0 "\\x1b[${cnt}A" array_347[@]
}

go_down__1835_v0() {
    local cnt=$1
    array_348=("")
    eprintf__1826_v0 "\\x1b[${cnt}B" array_348[@]
}

# move the cursor up or down `cnt` lines.
go_up_or_down__1836_v0() {
    local cnt=$1
    if [ "$(( ${cnt} > 0 ))" != 0 ]; then
        go_down__1835_v0 "${cnt}"
    else
        go_up__1834_v0 "$(( - ${cnt} ))"
    fi
}

hide_cursor__1837_v0() {
    array_349=("")
    eprintf__1826_v0 "\\x1b[?25l" array_349[@]
}

show_cursor__1838_v0() {
    array_350=("")
    eprintf__1826_v0 "\\x1b[?25h" array_350[@]
}

# / Text Utilities /////
has_ansi_escape__1839_v0() {
    local text=$1
    # Check for ESC character (0x1B = 27) or literal \x1b[
    command_351="$([[ "${text}" == *$'\x1b'* || "${text}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    has_escape_401="${command_351}"
    ret_has_ansi_escape1839_v0="$([ "_${has_escape_401}" != "_1" ]; echo $?)"
    return 0
}

strip_ansi__1841_v0() {
    local text=$1
    command_352="$(printf "%s" "${text}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1841_v0="${command_352}"
    return 0
}

is_all_ascii__1842_v0() {
    local text=$1
    command_353="$(printf "%s" "${text}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    result_397="${command_353}"
    ret_is_all_ascii1842_v0="$([ "_${result_397}" != "_0" ]; echo $?)"
    return 0
}

get_visible_len__1843_v0() {
    local text=$1
    strip_ansi__1841_v0 "${text}"
    stripped_396="${ret_strip_ansi1841_v0}"
    # Check if text is all ASCII
    is_all_ascii__1842_v0 "${stripped_396}"
    ret_is_all_ascii1842_v0__140_12="${ret_is_all_ascii1842_v0}"
    if [ "$(( ! ${ret_is_all_ascii1842_v0__140_12} ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1780_v0 "${stripped_396}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            __length_354="${stripped_396}"
            ret_get_visible_len1843_v0="${#__length_354}"
            return 0
        fi
        ret_get_visible_len1843_v0="${ret_perl_get_cjk_width1780_v0}"
        return 0
    else
        __length_355="${stripped_396}"
        ret_get_visible_len1843_v0="${#__length_355}"
        return 0
    fi
}

truncate_text__1844_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__1843_v0 "${text}"
    visible_len_402="${ret_get_visible_len1843_v0}"
    if [ "$(( ${visible_len_402} <= ${max_width} ))" != 0 ]; then
        ret_truncate_text1844_v0="${text}"
        return 0
    fi
    is_all_ascii__1842_v0 "${text}"
    ret_is_all_ascii1842_v0__157_12="${ret_is_all_ascii1842_v0}"
    if [ "$(( ! ${ret_is_all_ascii1842_v0__157_12} ))" != 0 ]; then
        perl_truncate_cjk__1781_v0 "${text}" "${max_width}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text}" | cut -c1-${max_width}
            __status=$?
        fi
        ret_truncate_text1844_v0="${ret_perl_truncate_cjk1781_v0}"
        return 0
    fi
    command_356="$(printf "%s" "${text}" | cut -c1-${max_width})"
    __status=$?
    ret_truncate_text1844_v0="${command_356}"
    return 0
}

truncate_ansi__1845_v0() {
    local text=$1
    local max_width=$2
    has_ansi_escape__1839_v0 "${text}"
    ret_has_ansi_escape1839_v0__169_12="${ret_has_ansi_escape1839_v0}"
    if [ "$(( ! ${ret_has_ansi_escape1839_v0__169_12} ))" != 0 ]; then
        truncate_text__1844_v0 "${text}" "${max_width}"
        ret_truncate_ansi1845_v0="${ret_truncate_text1844_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    command_357="$([[ "${text}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    starts_with_ansi_404="${command_357}"
    # Replace \x1b[ with newline, then split
    command_358="$(t="${text}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    replaced_405="${command_358}"
    split__5_v0 "${replaced_405}" "
"
    parts_406=("${ret_split5_v0[@]}")
    result_407=""
    remaining_width_408="${max_width}"
    from=0
    __length_359=("${parts_406[@]}")
    to="${#__length_359[@]}"
    for idx_409 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        part_410="${parts_406[${idx_409}]}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( ${idx_409} == 0 )) && $([ "_${starts_with_ansi_404}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_410}" == "_" ]; echo $?) && $(( ${remaining_width_408} > 0 )) ))" != 0 ]; then
                truncate_text__1844_v0 "${part_410}" "${remaining_width_408}"
                truncated_411="${ret_truncate_text1844_v0}"
                result_407+="${truncated_411}"
                get_visible_len__1843_v0 "${truncated_411}"
                ret_get_visible_len1843_v0__193_36="${ret_get_visible_len1843_v0}"
                remaining_width_408="$(( ${remaining_width_408} - ${ret_get_visible_len1843_v0__193_36} ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            command_360="$(__p="${part_410}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            m_idx_412="${command_360}"
            if [ "$([ "_${m_idx_412}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                command_361="$(__p="${part_410}"; printf "%s" "${__p:0:${m_idx_412}}")"
                __status=$?
                ansi_params_413="${command_361}"
                result_407+="\\x1b[""${ansi_params_413}""m"
                # Rest is text content
                parse_int__14_v0 "${m_idx_412}"
                __status=$?
                m_idx_num_414="${ret_parse_int14_v0}"
                text_start_415="$(( ${m_idx_num_414} + 1 ))"
                command_362="$(__p="${part_410}"; printf "%s" "${__p:${text_start_415}}")"
                __status=$?
                text_part_416="${command_362}"
                if [ "$(( $([ "_${text_part_416}" == "_" ]; echo $?) && $(( ${remaining_width_408} > 0 )) ))" != 0 ]; then
                    truncate_text__1844_v0 "${text_part_416}" "${remaining_width_408}"
                    truncated_417="${ret_truncate_text1844_v0}"
                    result_407+="${truncated_417}"
                    get_visible_len__1843_v0 "${truncated_417}"
                    ret_get_visible_len1843_v0__210_40="${ret_get_visible_len1843_v0}"
                    remaining_width_408="$(( ${remaining_width_408} - ${ret_get_visible_len1843_v0__210_40} ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_410}" == "_" ]; echo $?) && $(( ${remaining_width_408} > 0 )) ))" != 0 ]; then
                    truncate_text__1844_v0 "${part_410}" "${remaining_width_408}"
                    truncated_418="${ret_truncate_text1844_v0}"
                    result_407+="${truncated_418}"
                    get_visible_len__1843_v0 "${truncated_418}"
                    remaining_width_408="$(( ${remaining_width_408} - ${ret_get_visible_len1843_v0__217_40} ))"
                fi
            fi
        fi
    done
    ret_truncate_ansi1845_v0="${result_407}"
    return 0
}

cutoff_text__1846_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__1843_v0 "${text}"
    visible_len_400="${ret_get_visible_len1843_v0}"
    if [ "$(( ${visible_len_400} <= ${max_width} ))" != 0 ]; then
        ret_cutoff_text1846_v0="${text}"
        return 0
    fi
    truncate_ansi__1845_v0 "${text}" "$(( ${max_width} - 3 ))"
    ret_truncate_ansi1845_v0__233_12="${ret_truncate_ansi1845_v0}"
    ret_cutoff_text1846_v0="${ret_truncate_ansi1845_v0__233_12}""..."
    return 0
}

# // Application Utilities /////
render_tooltip__1847_v0() {
    local items=("${!1}")
    local total_len=$2
    local term_width=$3
    separator_424=" • "
    separator_len_425=3
    # Fast path: no truncation needed
    if [ "$(( ${total_len} <= ${term_width} ))" != 0 ]; then
        iter_426=0
        while :
        do
            __length_363=("${items[@]}")
            if [ "$(( ${iter_426} >= ${#__length_363[@]} ))" != 0 ]; then
                break
            elif [ "$(( ${iter_426} > 0 ))" != 0 ]; then
                eprintf_colored__1827_v0 "${separator_424}" 90
            fi
            colored__1828_v0 "${items[$(( ${iter_426} + 1 ))]}" 2
            ret_colored1828_v0__258_41="${ret_colored1828_v0}"
            array_364=("")
            eprintf__1826_v0 "${items[${iter_426}]}"" ""${ret_colored1828_v0__258_41}" array_364[@]
            iter_426="$(( ${iter_426} + 2 ))"
        done
    else
        # Slow path: truncate
        current_len_427=0
        first_428=1
        iter_429=0
        while :
        do
            __length_365=("${items[@]}")
            if [ "$(( ${iter_429} >= ${#__length_365[@]} ))" != 0 ]; then
                break
            fi
            key_430="${items[${iter_429}]}"
            action_431="${items[$(( ${iter_429} + 1 ))]}"
            __length_366="${key_430}"
            __length_367="${action_431}"
            part_len_432="$(( $(( ${#__length_366} + 1 )) + ${#__length_367} ))"
            needed_433="${part_len_432}"
            if [ "$(( ! ${first_428} ))" != 0 ]; then
                needed_433="$(( ${needed_433} + ${separator_len_425} ))"
            fi
            if [ "$(( $(( ${current_len_427} + ${needed_433} )) > ${term_width} ))" != 0 ]; then
                break
            fi
            if [ "$(( ! ${first_428} ))" != 0 ]; then
                eprintf_colored__1827_v0 "${separator_424}" 90
            fi
            colored__1828_v0 "${action_431}" 2
            ret_colored1828_v0__286_33="${ret_colored1828_v0}"
            array_368=("")
            eprintf__1826_v0 "${key_430}"" ""${ret_colored1828_v0__286_33}" array_368[@]
            current_len_427="$(( ${current_len_427} + ${needed_433} ))"
            first_428=0
            iter_429="$(( ${iter_429} + 2 ))"
        done
    fi
}

get_page_options__1897_v0() {
    local options=("${!1}")
    local page=$2
    local page_size=$3
    start_434="$(( ${page} * ${page_size} ))"
    end_435="$(( ${start_434} + ${page_size} ))"
    __length_369=("${options[@]}")
    if [ "$(( ${end_435} > ${#__length_369[@]} ))" != 0 ]; then
        __length_370=("${options[@]}")
        end_435="${#__length_370[@]}"
    fi
    result_436=()
    from="${start_434}"
    to="${end_435}"
    for i_437 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        result_436+=("${options[${i_437}]}")
    done
    ret_get_page_options1897_v0=("${result_436[@]}")
    return 0
}

render_choose_page__1899_v0() {
    local page_options=("${!1}")
    local sel=$2
    local cursor=$3
    local display_count=$4
    local term_width=$5
    __length_373="${cursor}"
    cursor_len_439="${#__length_373}"
    max_option_width_440="$(( $(( ${term_width} - ${cursor_len_439} )) - 1 ))"
    from=0
    __length_374=("${page_options[@]}")
    to="${#__length_374[@]}"
    for i_441 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        cutoff_text__1846_v0 "${page_options[${i_441}]}" "${max_option_width_440}"
        truncated_option_442="${ret_cutoff_text1846_v0}"
        if [ "$(( ${i_441} == ${sel} ))" != 0 ]; then
            colored_secondary__1809_v0 "${cursor}""${truncated_option_442}""
"
            ret_colored_secondary1809_v0__28_21="${ret_colored_secondary1809_v0}"
            array_375=("")
            eprintf__1826_v0 "${ret_colored_secondary1809_v0__28_21}" array_375[@]
        else
            print_blank__1832_v0 "${cursor_len_439}"
            array_376=("")
            eprintf__1826_v0 "${truncated_option_442}""
" array_376[@]
        fi
    done
    __length_377=("${page_options[@]}")
    remaining_slots_451="$(( ${display_count} - ${#__length_377[@]} ))"
    if [ "$(( ${remaining_slots_451} > 0 ))" != 0 ]; then
        # Amber bug gaurd
        from=0
        to="${remaining_slots_451}"
        for ____452 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
            array_378=("")
            eprintf__1826_v0 "\\x1b[K
" array_378[@]
        done
    fi
}

render_page_indicator__1901_v0() {
    local page=$1
    local total_pages=$2
    if [ "$(( ${total_pages} > 1 ))" != 0 ]; then
        array_379=("")
        eprintf__1826_v0 "\\x1b[9999D\\x1b[K" array_379[@]
        eprintf_colored__1827_v0 "Page $(( ${page} + 1 ))/${total_pages}" 90
        array_380=("")
        eprintf__1826_v0 "\\x1b[9999D" array_380[@]
    fi
}

xyl_choose__1902_v0() {
    local options=("${!1}")
    local cursor=$2
    local header=$3
    local page_size=$4
    __length_381=("${options[@]}")
    if [ "$(( ${#__length_381[@]} == 0 ))" != 0 ]; then
        eprintf_colored__1827_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    stty_lock__1788_v0 
    hide_cursor__1837_v0 
    term_width__1792_v0 
    term_width_393="${ret_term_width1792_v0}"
    term_height__1793_v0 
    term_height_394="${ret_term_height1793_v0}"
    max_page_size_395="$(( ${term_height_394} - $(if [ "$([ "_${header}" != "_" ]; echo $?)" != 0 ]; then echo 2; else echo 3; fi) ))"
    if [ "$(( ${page_size} > ${max_page_size_395} ))" != 0 ]; then
        page_size="${max_page_size_395}"
    fi
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__1846_v0 "${header}" "${term_width_393}"
        ret_cutoff_text1846_v0__107_17="${ret_cutoff_text1846_v0}"
        array_382=("")
        eprintf__1826_v0 "${ret_cutoff_text1846_v0__107_17}""
" array_382[@]
    fi
    __length_383=("${options[@]}")
    math_floor__416_v0 "$(( $(( $(( ${#__length_383[@]} + ${page_size} )) - 1 )) / ${page_size} ))"
    total_pages_419="${ret_math_floor416_v0}"
    current_page_420=0
    selected_421=0
    display_count_422="${page_size}"
    __length_384=("${options[@]}")
    if [ "$(( ${#__length_384[@]} < ${page_size} ))" != 0 ]; then
        __length_385=("${options[@]}")
        display_count_422="${#__length_385[@]}"
    fi
    new_line__1833_v0 "${display_count_422}"
    array_386=("")
    eprintf__1826_v0 "\\x1b[9999D" array_386[@]
    if [ "$(( ${total_pages_419} > 1 ))" != 0 ]; then
        eprintf_colored__1827_v0 "Page $(( ${current_page_420} + 1 ))/${total_pages_419}" 90
    fi
    new_line__1833_v0 1
    # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
    # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    if [ "$(( ${total_pages_419} > 1 ))" != 0 ]; then
        array_387=("↑↓" "select" "←→" "page" "enter" "confirm")
        render_tooltip__1847_v0 array_387[@] 36 "${term_width_393}"
    else
        array_388=("↑↓" "select" "enter" "confirm")
        render_tooltip__1847_v0 array_388[@] 25 "${term_width_393}"
    fi
    go_up__1834_v0 "$(( ${display_count_422} + 1 ))"
    array_389=("")
    eprintf__1826_v0 "\\x1b[9999D" array_389[@]
    get_page_options__1897_v0 options[@] "${current_page_420}" "${page_size}"
    page_options_438=("${ret_get_page_options1897_v0[@]}")
    render_choose_page__1899_v0 page_options_438[@] "${selected_421}" "${cursor}" "${display_count_422}" "${term_width_393}"
    while :
    do
        get_key__1824_v0 
        key_454="${ret_get_key1824_v0}"
        prev_selected_455="${selected_421}"
        prev_page_456="${current_page_420}"
        up_paged_457=0
        if [ "$(( $([ "_${key_454}" != "_UP" ]; echo $?) || $([ "_${key_454}" != "_k" ]; echo $?) ))" != 0 ]; then
            if [ "$(( $(( ${selected_421} == 0 )) && $(( ${total_pages_419} > 1 )) ))" != 0 ]; then
                if [ "$(( ${current_page_420} > 0 ))" != 0 ]; then
                    current_page_420="$(( ${current_page_420} - 1 ))"
                else
                    current_page_420="$(( ${total_pages_419} - 1 ))"
                fi
                up_paged_457=1
            elif [ "$(( ${selected_421} == 0 ))" != 0 ]; then
                __length_390=("${page_options_438[@]}")
                selected_421="$(( ${#__length_390[@]} - 1 ))"
            else
                selected_421="$(( ${selected_421} - 1 ))"
            fi
        elif [ "$(( $([ "_${key_454}" != "_DOWN" ]; echo $?) || $([ "_${key_454}" != "_j" ]; echo $?) ))" != 0 ]; then
            __length_391=("${page_options_438[@]}")
            if [ "$(( ${selected_421} == $(( ${#__length_391[@]} - 1 )) ))" != 0 ]; then
                if [ "$(( ${current_page_420} < $(( ${total_pages_419} - 1 )) ))" != 0 ]; then
                    current_page_420="$(( ${current_page_420} + 1 ))"
                    selected_421=0
                else
                    current_page_420=0
                    selected_421=0
                fi
            else
                selected_421="$(( ${selected_421} + 1 ))"
            fi
        elif [ "$(( $([ "_${key_454}" != "_LEFT" ]; echo $?) || $([ "_${key_454}" != "_h" ]; echo $?) ))" != 0 ]; then
            if [ "$(( ${current_page_420} > 0 ))" != 0 ]; then
                current_page_420="$(( ${current_page_420} - 1 ))"
                selected_421=0
            else
                selected_421=0
            fi
        elif [ "$(( $([ "_${key_454}" != "_RIGHT" ]; echo $?) || $([ "_${key_454}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "$(( ${current_page_420} < $(( ${total_pages_419} - 1 )) ))" != 0 ]; then
                current_page_420="$(( ${current_page_420} + 1 ))"
                selected_421=0
            else
                __length_392=("${page_options_438[@]}")
                selected_421="$(( ${#__length_392[@]} - 1 ))"
            fi
        elif [ "$([ "_${key_454}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
        __length_393="${cursor}"
        max_option_width_458="$(( $(( ${term_width_393} - ${#__length_393} )) - 1 ))"
        if [ "$(( ${prev_page_456} != ${current_page_420} ))" != 0 ]; then
            get_page_options__1897_v0 options[@] "${current_page_420}" "${page_size}"
            page_options_438=("${ret_get_page_options1897_v0[@]}")
            if [ "${up_paged_457}" != 0 ]; then
                __length_394=("${page_options_438[@]}")
                selected_421="$(( ${#__length_394[@]} - 1 ))"
            fi
            go_up__1834_v0 1
            remove_line__1830_v0 "$(( ${display_count_422} - 1 ))"
            remove_current_line__1831_v0 
            array_395=("")
            eprintf__1826_v0 "\\x1b[9999D" array_395[@]
            render_choose_page__1899_v0 page_options_438[@] "${selected_421}" "${cursor}" "${display_count_422}" "${term_width_393}"
            render_page_indicator__1901_v0 "${current_page_420}" "${total_pages_419}"
        elif [ "$(( ${prev_selected_455} != ${selected_421} ))" != 0 ]; then
            go_up__1834_v0 "$(( ${display_count_422} - ${prev_selected_455} ))"
            array_396=("")
            eprintf__1826_v0 "\\x1b[K" array_396[@]
            __length_397="${cursor}"
            print_blank__1832_v0 "${#__length_397}"
            cutoff_text__1846_v0 "${page_options_438[${prev_selected_455}]}" "${max_option_width_458}"
            ret_cutoff_text1846_v0__218_25="${ret_cutoff_text1846_v0}"
            array_398=("")
            eprintf__1826_v0 "${ret_cutoff_text1846_v0__218_25}" array_398[@]
            diff_459="$(( ${selected_421} - ${prev_selected_455} ))"
            go_up_or_down__1836_v0 "${diff_459}"
            array_399=("")
            eprintf__1826_v0 "\\x1b[9999D" array_399[@]
            array_400=("")
            eprintf__1826_v0 "\\x1b[K" array_400[@]
            cutoff_text__1846_v0 "${page_options_438[${selected_421}]}" "${max_option_width_458}"
            ret_cutoff_text1846_v0__224_52="${ret_cutoff_text1846_v0}"
            colored_secondary__1809_v0 "${cursor}""${ret_cutoff_text1846_v0__224_52}"
            ret_colored_secondary1809_v0__224_25="${ret_colored_secondary1809_v0}"
            array_401=("")
            eprintf__1826_v0 "${ret_colored_secondary1809_v0__224_25}" array_401[@]
            go_down__1835_v0 "$(( ${display_count_422} - ${selected_421} ))"
            array_402=("")
            eprintf__1826_v0 "\\x1b[9999D" array_402[@]
        fi
    done
    total_lines_460="$(( ${display_count_422} + 2 ))"
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_460="$(( ${total_lines_460} + 1 ))"
    fi
    go_down__1835_v0 1
    remove_line__1830_v0 "$(( ${total_lines_460} - 1 ))"
    remove_current_line__1831_v0 
    stty_unlock__1789_v0 
    show_cursor__1838_v0 
    global_selected_463="$(( $(( ${current_page_420} * ${page_size} )) + ${selected_421} ))"
    ret_xyl_choose1902_v0="${options[${global_selected_463}]}"
    return 0
}

format_entry_display__1906_v0() {
    local entry=("${!1}")
    name_382="${entry[0]}"
    file_type_383="${entry[1]}"
    if [ "$([ "_${file_type_383}" != "_d" ]; echo $?)" != 0 ]; then
        colored_primary__1613_v0 "/"
        ret_colored_primary1613_v0__13_23="${ret_colored_primary1613_v0}"
        ret_format_entry_display1906_v0="${name_382}""${ret_colored_primary1613_v0__13_23}"
        return 0
    fi
    if [ "$([ "_${file_type_383}" != "_l" ]; echo $?)" != 0 ]; then
        colored_accent__1615_v0 " > "
        ret_colored_accent1615_v0__16_23="${ret_colored_accent1615_v0}"
        colored_primary__1613_v0 "${entry[2]}"
        ret_colored_primary1613_v0__16_47="${ret_colored_primary1613_v0}"
        ret_format_entry_display1906_v0="${name_382}""${ret_colored_accent1615_v0__16_23}""${ret_colored_primary1613_v0__16_47}"
        return 0
    fi
    ret_format_entry_display1906_v0="${name_382}"
    return 0
}

xyl_file__1907_v0() {
    local start_path=$1
    local cursor=$2
    local show_hidden=$3
    local page_size=$4
    stty_lock__1593_v0 
    term_width__1597_v0 
    # Initialize current path
    current_path_363="${start_path}"
    if [ "$([ "_${current_path_363}" != "_" ]; echo $?)" != 0 ]; then
        get_cwd__1572_v0 
        current_path_363="${ret_get_cwd1572_v0}"
    fi
    normalize_path__1573_v0 "${current_path_363}"
    current_path_363="${ret_normalize_path1573_v0}"
    while :
    do
        colored_primary__1613_v0 "Loading files..."
        ret_colored_primary1613_v0__47_17="${ret_colored_primary1613_v0}"
        array_404=("")
        eprintf__1631_v0 "${ret_colored_primary1613_v0__47_17}" array_404[@]
        # Get directory entries
        get_directory_entries__1570_v0 "${current_path_363}"
        raw_entries_375=("${ret_get_directory_entries1570_v0[@]}")
        # Build options list and parallel entries list
        options_376=()
        entries_377=()
        # Add parent directory entry (..)
        if [ "$([ "_${current_path_363}" == "_/" ]; echo $?)" != 0 ]; then
            options_376+=("..")
            entries_377+=("..	d")
        fi
        for raw_entry_378 in "${raw_entries_375[@]}"; do
            parse_entry__1571_v0 "${raw_entry_378}"
            entry_379=("${ret_parse_entry1571_v0[@]}")
            name_380="${entry_379[0]}"
            # Skip hidden files if not showing them
            command_409="$(echo "${name_380}" | cut -c1)"
            __status=$?
            first_char_381="${command_409}"
            if [ "$(( $(( ! ${show_hidden} )) && $([ "_${first_char_381}" != "_." ]; echo $?) ))" != 0 ]; then
                continue
            fi
            format_entry_display__1906_v0 entry_379[@]
            ret_format_entry_display1906_v0__70_25="${ret_format_entry_display1906_v0}"
            options_376+=("${ret_format_entry_display1906_v0__70_25}")
            entries_377+=("${raw_entry_378}")
        done
        __length_412=("${entries_377[@]}")
        if [ "$(( ${#__length_412[@]} == 0 ))" != 0 ]; then
            eprintf_colored__1632_v0 "ERROR: Directory is empty or inaccessible.
" 31
            stty_unlock__1594_v0 
            ret_xyl_file1907_v0=""
            return 0
        fi
        # Use xyl_choose with current path as header
        colored_primary__1613_v0 "${current_path_363}"
        header_386="${ret_colored_primary1613_v0}"
        remove_current_line__1636_v0 
        xyl_choose__1902_v0 options_376[@] "${cursor}" "${header_386}" "${page_size}"
        selected_option_464="${ret_xyl_choose1902_v0}"
        # Find selected entry index
        selected_idx_465=-1
        from=0
        __length_413=("${options_376[@]}")
        to="${#__length_413[@]}"
        for i_466 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
            if [ "$([ "_${options_376[${i_466}]}" != "_${selected_option_464}" ]; echo $?)" != 0 ]; then
                selected_idx_465="${i_466}"
                break
            fi
        done
        if [ "$(( ${selected_idx_465} < 0 ))" != 0 ]; then
            ret_xyl_file1907_v0=""
            return 0
        fi
        parse_entry__1571_v0 "${entries_377[${selected_idx_465}]}"
        entry_467=("${ret_parse_entry1571_v0[@]}")
        name_468="${entry_467[0]}"
        file_type_469="${entry_467[1]}"
        if [ "$([ "_${name_468}" != "_.." ]; echo $?)" != 0 ]; then
            get_parent_dir__1576_v0 "${current_path_363}"
            current_path_363="${ret_get_parent_dir1576_v0}"
        elif [ "$([ "_${file_type_469}" != "_d" ]; echo $?)" != 0 ]; then
            path_join__1575_v0 "${current_path_363}" "${name_468}"
            current_path_363="${ret_path_join1575_v0}"
            normalize_path__1573_v0 "${current_path_363}"
            current_path_363="${ret_normalize_path1573_v0}"
        elif [ "$([ "_${file_type_469}" != "_l" ]; echo $?)" != 0 ]; then
            # For symlinks, check if they point to a directory
            starts_with__23_v0 "${entry_467[2]}" "/"
            ret_starts_with23_v0__113_20="${ret_starts_with23_v0}"
            if [ "${ret_starts_with23_v0__113_20}" != 0 ]; then
                current_path_363="${entry_467[2]}"
                normalize_path__1573_v0 "${current_path_363}"
                current_path_363="${ret_normalize_path1573_v0}"
            else
                stty_unlock__1594_v0 
                path_join__1575_v0 "${current_path_363}" "${entry_467[2]}"
                ret_xyl_file1907_v0="${ret_path_join1575_v0}"
                return 0
            fi
        else
            stty_unlock__1594_v0 
            path_join__1575_v0 "${current_path_363}" "${name_468}"
            ret_xyl_file1907_v0="${ret_path_join1575_v0}"
            return 0
        fi
    done
    stty_unlock__1594_v0 
    ret_xyl_file1907_v0=""
    return 0
}

print_file_help__1983_v0() {
    echo "Usage: ./xylitol.sh file [<path>] [flags]"
    echo ""
    colored_primary__1613_v0 "file"
    ret_colored_primary1613_v0__7_12="${ret_colored_primary1613_v0}"
    array_414=("")
    printf__106_v0 "${ret_colored_primary1613_v0__7_12}" array_414[@]
    array_415=("")
    printf__106_v0 " - Browse filesystem and select a file." array_415[@]
    echo ""
    echo ""
    colored_secondary__1614_v0 "Arguments: "
    ret_colored_secondary1614_v0__11_12="${ret_colored_secondary1614_v0}"
    array_416=("")
    printf__106_v0 "${ret_colored_secondary1614_v0__11_12}""
" array_416[@]
    echo "  [<path>]               Starting directory path (default: current directory)"
    echo ""
    colored_secondary__1614_v0 "Flags: "
    ret_colored_secondary1614_v0__14_12="${ret_colored_secondary1614_v0}"
    array_417=("")
    printf__106_v0 "${ret_colored_secondary1614_v0__14_12}""
" array_417[@]
    echo "  -h, --help             Show this help message"
    echo "  -a, --all              Show hidden files"
    echo "  --cursor=\"<text>\"      Set the cursor text (default: '> ')"
    echo "  --path=\"<path>\"        Set the starting directory path"
    echo "  --page-size=<number>   Set the number of entries per page (default: 10)"
    echo ""
}

execute_file__2034_v0() {
    local parameters=("${!1}")
    cursor_339="> "
    start_path_340=""
    show_hidden_341=0
    page_size_342=10
    for param_343 in "${parameters[@]:2:9997}"; do
        match_regex__20_v0 "${param_343}" "^-h\$" 0
        ret_match_regex20_v0__14_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_343}" "^--help\$" 0
        ret_match_regex20_v0__14_43="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_343}" "^--cursor=.*\$" 0
        ret_match_regex20_v0__18_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_343}" "^--path=.*\$" 0
        ret_match_regex20_v0__22_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_343}" "^-a\$" 0
        ret_match_regex20_v0__26_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_343}" "^--all\$" 0
        ret_match_regex20_v0__26_43="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_343}" "^--page-size=.*\$" 0
        ret_match_regex20_v0__29_13="${ret_match_regex20_v0}"
        if [ "$(( ${ret_match_regex20_v0__14_13} || ${ret_match_regex20_v0__14_43} ))" != 0 ]; then
            print_file_help__1983_v0 
            exit 0
        elif [ "${ret_match_regex20_v0__18_13}" != 0 ]; then
            split__5_v0 "${param_343}" "="
            result_352=("${ret_split5_v0[@]}")
            cursor_339="${result_352[1]}"
        elif [ "${ret_match_regex20_v0__22_13}" != 0 ]; then
            split__5_v0 "${param_343}" "="
            result_353=("${ret_split5_v0[@]}")
            start_path_340="${result_353[1]}"
        elif [ "$(( ${ret_match_regex20_v0__26_13} || ${ret_match_regex20_v0__26_43} ))" != 0 ]; then
            show_hidden_341=1
        elif [ "${ret_match_regex20_v0__29_13}" != 0 ]; then
            split__5_v0 "${param_343}" "="
            result_354=("${ret_split5_v0[@]}")
            parse_int__14_v0 "${result_354[1]}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1632_v0 "ERROR: Invalid page-size value: ""${result_354[1]}""
" 31
                exit 1
            fi
            page_size_342="${ret_parse_int14_v0}"
        else
            # Treat as start path if not a flag
            start_path_340="${param_343}"
        fi
    done
    xyl_file__1907_v0 "${start_path_340}" "${cursor_339}" "${show_hidden_341}" "${page_size_342}"
    ret_execute_file2034_v0="${ret_xyl_file1907_v0}"
    return 0
}

# #!/usr/bin/env amber
__VERSION_58="0.1.0"
__AMBER_VERSION_59="0.4.0"
check_prerequirements__2036_v0() {
    echo "0" | bc -l > /dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        eprintf_colored__213_v0 "Error: " 91
        array_418=("")
        eprintf__212_v0 "bc is not installed. Please install bc to use xylitol.
" array_418[@]
        array_419=("")
        eprintf__212_v0 "  For Debian/Ubuntu: sudo apt install bc
" array_419[@]
        array_420=("")
        eprintf__212_v0 "  For Fedora: sudo dnf install bc
" array_420[@]
        array_421=("")
        eprintf__212_v0 "  For Arch Linux: sudo pacman -S bc
" array_421[@]
        ret_check_prerequirements2036_v0=0
        return 0
    fi
    ret_check_prerequirements2036_v0=1
    return 0
}

trap_cleanup__2037_v0() {
    trap 'printf "\x1b[?25h\x1b[0m" >&2; 
            stty echo < /dev/tty' EXIT
    __status=$?
}

declare -r args_0=("$0" "$@")
trap_cleanup__2037_v0 
check_prerequirements__2036_v0 
ret_check_prerequirements2036_v0__32_12="${ret_check_prerequirements2036_v0}"
if [ "$(( ! ${ret_check_prerequirements2036_v0__32_12} ))" != 0 ]; then
    exit 1
fi
__length_423=("${args_60[@]}")
if [ "$(( $(( $(( $(( ${#__length_423[@]} < 2 )) || $([ "_${args_60[1]}" != "_help" ]; echo $?) )) || $([ "_${args_60[1]}" != "_--help" ]; echo $?) )) || $([ "_${args_60[1]}" != "_-h" ]; echo $?) ))" != 0 ]; then
    print_help__358_v0 
elif [ "$([ "_${args_60[1]}" != "_input" ]; echo $?)" != 0 ]; then
    execute_input__716_v0 args_60[@]
    ret_execute_input716_v0__39_18="${ret_execute_input716_v0}"
    echo "${ret_execute_input716_v0__39_18}"
elif [ "$([ "_${args_60[1]}" != "_choose" ]; echo $?)" != 0 ]; then
    execute_choose__1078_v0 args_60[@]
    ret_execute_choose1078_v0__42_18="${ret_execute_choose1078_v0}"
    echo "${ret_execute_choose1078_v0__42_18}"
elif [ "$([ "_${args_60[1]}" != "_confirm" ]; echo $?)" != 0 ]; then
    execute_confirm__1452_v0 args_60[@]
    result_338="${ret_execute_confirm1452_v0}"
    if [ "$([ "_${result_338}" != "_yes" ]; echo $?)" != 0 ]; then
        exit 0
    else
        exit 1
    fi
elif [ "$([ "_${args_60[1]}" != "_file" ]; echo $?)" != 0 ]; then
    execute_file__2034_v0 args_60[@]
    ret_execute_file2034_v0__52_18="${ret_execute_file2034_v0}"
    echo "${ret_execute_file2034_v0__52_18}"
elif [ "$(( $(( $([ "_${args_60[1]}" != "_version" ]; echo $?) || $([ "_${args_60[1]}" != "_--version" ]; echo $?) )) || $([ "_${args_60[1]}" != "_-v" ]; echo $?) ))" != 0 ]; then
    colored_primary__194_v0 "xylitol.sh"
    ret_colored_primary194_v0__55_20="${ret_colored_primary194_v0}"
    array_424=("")
    printf__106_v0 "${ret_colored_primary194_v0__55_20}" array_424[@]
    array_425=("")
    printf__106_v0 " version: " array_425[@]
    colored_accent__196_v0 "${__VERSION_58}"
    ret_colored_accent196_v0__57_20="${ret_colored_accent196_v0}"
    array_426=("")
    printf__106_v0 "${ret_colored_accent196_v0__57_20}" array_426[@]
    echo ""
    printf_colored__211_v0 "written in Amber: " 90
    printf_colored__211_v0 "  ""${__AMBER_VERSION_59}" 90
else
    print_help__358_v0 
    printf_colored__211_v0 "ERROR: Unknown command '""${args_60[1]}""'" 91
fi
