#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: 0.5.1-alpha
# We cannot import `bash_version` from `env.ab` because it imports `text.ab` making a circular dependency.
# This is a workaround to avoid that issue and the import system should be improved in the future.
bash_version__0_v0() {
    major_76="$(echo "${BASH_VERSINFO[0]}")"
    minor_77="$(echo "${BASH_VERSINFO[1]}")"
    command_2="$(echo "${BASH_VERSINFO[2]}")"
    __status=$?
    patch_78="${command_2}"
    ret_bash_version0_v0=("${major_76}" "${minor_77}" "${patch_78}")
    return 0
}

replace__1_v0() {
    local source=$1
    local search=$2
    local replace=$3
    # Here we use a command to avoid #646
    result_75=""
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
        result_75="${source//"${search}"/"${replace}"}"
        __status=$?
    else
        result_75="${source//"${search}"/${replace}}"
        __status=$?
    fi
    ret_replace1_v0="${result_75}"
    return 0
}

__SED_VERSION_UNKNOWN_0=0
__SED_VERSION_GNU_1=1
__SED_VERSION_BUSYBOX_2=2
sed_version__3_v0() {
    # We can't match against a word "GNU" because
    # alpine's busybox sed returns "This is not GNU sed version"
    re='\bCopyright\b.+\bFree Software Foundation\b'; [[ $(sed --version 2>/dev/null) =~ $re ]]
    __status=$?
    if [ "$(( ${__status} == 0 ))" != 0 ]; then
        ret_sed_version3_v0="${__SED_VERSION_GNU_1}"
        return 0
    fi
    # On BSD single `sed` waits for stdin. We must use `sed --help` to avoid this.
    re='\bBusyBox\b'; [[ $(sed --help 2>&1) =~ $re ]]
    __status=$?
    if [ "$(( ${__status} == 0 ))" != 0 ]; then
        ret_sed_version3_v0="${__SED_VERSION_BUSYBOX_2}"
        return 0
    fi
    ret_sed_version3_v0="${__SED_VERSION_UNKNOWN_0}"
    return 0
}

split__5_v0() {
    local text=$1
    local delimiter=$2
    result_61=()
    IFS="${delimiter}" read -rd '' -a result_61 < <(printf %s "$text")
    __status=$?
    ret_split5_v0=("${result_61[@]}")
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
    sed_version_74="${ret_sed_version3_v0}"
    replace__1_v0 "${search}" "/" "\\/"
    search="${ret_replace1_v0}"
    output_79=""
    if [ "$(( $(( ${sed_version_74} == ${__SED_VERSION_GNU_1} )) || $(( ${sed_version_74} == ${__SED_VERSION_BUSYBOX_2} )) ))" != 0 ]; then
        # '\b' is supported but not in POSIX standards. Disable it
        replace__1_v0 "${search}" "\\b" "\\\\b"
        search="${ret_replace1_v0}"
    fi
    if [ "${extended}" != 0 ]; then
        # GNU sed versions 4.0 through 4.2 support extended regex syntax,
        # but only via the "-r" option
        if [ "$(( ${sed_version_74} == ${__SED_VERSION_GNU_1} ))" != 0 ]; then
            # '\b' is not in POSIX standards. Disable it
            replace__1_v0 "${search}" "\\b" "\\b"
            search="${ret_replace1_v0}"
            command_7="$(echo "${source}" | sed -r -ne "/${search}/p")"
            __status=$?
            output_79="${command_7}"
        else
            command_8="$(echo "${source}" | sed -E -ne "/${search}/p")"
            __status=$?
            output_79="${command_8}"
        fi
    else
        if [ "$(( $(( ${sed_version_74} == ${__SED_VERSION_GNU_1} )) || $(( ${sed_version_74} == ${__SED_VERSION_BUSYBOX_2} )) ))" != 0 ]; then
            # GNU Sed BRE handle \| as a metacharacter, but it is not POSIX standands. Disable it
            replace__1_v0 "${search}" "\\|" "|"
            search="${ret_replace1_v0}"
        fi
        command_9="$(echo "${source}" | sed -ne "/${search}/p")"
        __status=$?
        output_79="${command_9}"
    fi
    if [ "$([ "_${output_79}" == "_" ]; echo $?)" != 0 ]; then
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
    result_505="${command_10}"
    ret_starts_with23_v0="$([ "_${result_505}" != "_1" ]; echo $?)"
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
_perl_disabled_3="$([ "_${command_13}" != "_No" ]; echo $?)"
command_14="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_4="$(( $(( ! ${_perl_disabled_3} )) && $([ "_${command_14}" != "_0" ]; echo $?) ))"
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
get_supports_truecolor__193_v0() {
    env_var_get__98_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    config_67="${ret_env_var_get98_v0}"
    if [ "$([ "_${config_67}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_7="No"
        ret_get_supports_truecolor193_v0=0
        return 0
    fi
    env_var_get__98_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_7="No"
        ret_get_supports_truecolor193_v0=0
        return 0
    fi
    colorterm_68="${ret_env_var_get98_v0}"
    _supports_truecolor_7="$(if [ "$(( $([ "_${colorterm_68}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_68}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor193_v0="$([ "_${_supports_truecolor_7}" != "_Yes" ]; echo $?)"
    return 0
}

colored_rgb__194_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    if [ "$([ "_${_supports_truecolor_7}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb194_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_7}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__193_v0 
        ret_get_supports_truecolor193_v0__50_17="${ret_get_supports_truecolor193_v0}"
        if [ "${ret_get_supports_truecolor193_v0__50_17}" != 0 ]; then
            ret_colored_rgb194_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
            return 0
        elif [ "$(( ${fallback} == 0 ))" != 0 ]; then
            ret_colored_rgb194_v0="${message}"
            return 0
        else
            ret_colored_rgb194_v0="\\x1b[${fallback}m""${message}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( ${fallback} == 0 ))" != 0 ]; then
            ret_colored_rgb194_v0="${message}"
            return 0
        fi
        ret_colored_rgb194_v0="\\x1b[${fallback}m""${message}""\\x1b[0m"
        return 0
    fi
}

inner_get_xylitol_colors__196_v0() {
    if [ "$(( ! ${_got_xylitol_colors_8} ))" != 0 ]; then
        env_var_get__98_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        primary_env_60="${ret_env_var_get98_v0}"
        if [ "$([ "_${primary_env_60}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${primary_env_60}" ";"
            parts_62=("${ret_split5_v0[@]}")
            __length_19=("${parts_62[@]}")
            if [ "$(( ${#__length_19[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_62[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors196_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__115_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_62[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors196_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__116_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_62[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors196_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__117_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_62[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors196_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__118_21="${ret_parse_int14_v0}"
                _primary_color_9=("${ret_parse_int14_v0__115_21}" "${ret_parse_int14_v0__116_21}" "${ret_parse_int14_v0__117_21}" "${ret_parse_int14_v0__118_21}")
            fi
        fi
        env_var_get__98_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        secondary_env_63="${ret_env_var_get98_v0}"
        if [ "$([ "_${secondary_env_63}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${secondary_env_63}" ";"
            parts_64=("${ret_split5_v0[@]}")
            __length_21=("${parts_64[@]}")
            if [ "$(( ${#__length_21[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_64[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors196_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__128_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_64[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors196_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__129_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_64[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors196_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__130_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_64[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors196_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__131_21="${ret_parse_int14_v0}"
                _secondary_color_10=("${ret_parse_int14_v0__128_21}" "${ret_parse_int14_v0__129_21}" "${ret_parse_int14_v0__130_21}" "${ret_parse_int14_v0__131_21}")
            fi
        fi
        env_var_get__98_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        accent_env_65="${ret_env_var_get98_v0}"
        if [ "$([ "_${accent_env_65}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${accent_env_65}" ";"
            parts_66=("${ret_split5_v0[@]}")
            __length_23=("${parts_66[@]}")
            if [ "$(( ${#__length_23[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_66[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors196_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__141_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_66[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors196_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__142_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_66[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors196_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__143_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_66[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors196_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__144_21="${ret_parse_int14_v0}"
                _accent_color_11=("${ret_parse_int14_v0__141_21}" "${ret_parse_int14_v0__142_21}" "${ret_parse_int14_v0__143_21}" "${ret_parse_int14_v0__144_21}")
            fi
        fi
        _got_xylitol_colors_8=1
    fi
}

get_xylitol_colors__197_v0() {
    inner_get_xylitol_colors__196_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__112_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_8=1
}

colored_primary__198_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_8} ))" != 0 ]; then
        get_xylitol_colors__197_v0 
    fi
    colored_rgb__194_v0 "${message}" "${_primary_color_9[0]}" "${_primary_color_9[1]}" "${_primary_color_9[2]}" "${_primary_color_9[3]}"
    ret_colored_primary198_v0="${ret_colored_rgb194_v0}"
    return 0
}

colored_secondary__199_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_8} ))" != 0 ]; then
        get_xylitol_colors__197_v0 
    fi
    colored_rgb__194_v0 "${message}" "${_secondary_color_10[0]}" "${_secondary_color_10[1]}" "${_secondary_color_10[2]}" "${_secondary_color_10[3]}"
    ret_colored_secondary199_v0="${ret_colored_rgb194_v0}"
    return 0
}

colored_accent__200_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_8} ))" != 0 ]; then
        get_xylitol_colors__197_v0 
    fi
    colored_rgb__194_v0 "${message}" "${_accent_color_11[0]}" "${_accent_color_11[1]}" "${_accent_color_11[2]}" "${_accent_color_11[3]}"
    ret_colored_accent200_v0="${ret_colored_rgb194_v0}"
    return 0
}

# // IO Functions /////
printf_colored__215_v0() {
    local message=$1
    local color=$2
    # Prints a text with a specified color.
    array_25=("${message}")
    printf__106_v0 "\\x1b[${color}m%s\\x1b[0m" array_25[@]
}

eprintf__216_v0() {
    local format=$1
    local args=("${!2}")
    args=("${format}" "${args[@]}")
    __status=$?
    printf "${args[@]}" >&2
    __status=$?
}

eprintf_colored__217_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    array_26=("${message}")
    eprintf__216_v0 "\\x1b[${color}m%s\\x1b[0m" array_26[@]
}

colored__218_v0() {
    local message=$1
    local color=$2
    # Returns a text wrapped in color codes.
    ret_colored218_v0="\\x1b[${color}m""${message}""\\x1b[0m"
    return 0
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# // Application Utilities /////
print_help__362_v0() {
    echo "Usage: ./xylitol.sh <command> [flags]"
    echo ""
    colored_primary__198_v0 "Xylitol"
    ret_colored_primary198_v0__7_24="${ret_colored_primary198_v0}"
    array_27=("")
    printf__106_v0 "\\x1b[1m""${ret_colored_primary198_v0__7_24}" array_27[@]
    array_28=("")
    printf__106_v0 " - A tool for " array_28[@]
    colored_primary__198_v0 "fresh"
    ret_colored_primary198_v0__9_12="${ret_colored_primary198_v0}"
    array_29=("")
    printf__106_v0 "${ret_colored_primary198_v0__9_12}" array_29[@]
    array_30=("")
    printf__106_v0 " shell scripts." array_30[@]
    echo ""
    echo ""
    colored_secondary__199_v0 "Flags: "
    ret_colored_secondary199_v0__13_12="${ret_colored_secondary199_v0}"
    array_31=("")
    printf__106_v0 "${ret_colored_secondary199_v0__13_12}""
" array_31[@]
    echo "  -h, --help        Show this help message"
    echo "  -v, --version     Show version information"
    echo ""
    colored_secondary__199_v0 "Commands: "
    ret_colored_secondary199_v0__17_12="${ret_colored_secondary199_v0}"
    array_32=("")
    printf__106_v0 "${ret_colored_secondary199_v0__17_12}""
" array_32[@]
    echo "  input             Prompt for some input"
    echo "  choose            Choose from a list of options"
    echo "  confirm           Prompt for a yes/no confirmation"
    echo "  file              Browse filesystem and select a file"
    echo ""
    colored_secondary__199_v0 "Envs: "
    ret_colored_secondary199_v0__23_12="${ret_colored_secondary199_v0}"
    array_33=("")
    printf__106_v0 "${ret_colored_secondary199_v0__23_12}""
" array_33[@]
    colored__218_v0 "(\"Yes\" or \"No\", default: Yes)" 90
    ret_colored218_v0__24_78="${ret_colored218_v0}"
    array_34=("")
    printf__106_v0 "  \$XYLITOL_USE_PERL          Use Perl for CJK / Optimization ""${ret_colored218_v0__24_78}""
" array_34[@]
    colored__218_v0 "(\"Yes\" or \"No\", default: Yes)" 90
    ret_colored218_v0__25_78="${ret_colored218_v0}"
    array_35=("")
    printf__106_v0 "  \$XYLITOL_TRUECOLOR         Enable 24-bit truecolor support ""${ret_colored218_v0__25_78}""
" array_35[@]
    colored__218_v0 "(default: 3;207;159;92)" 90
    ret_colored218_v0__26_68="${ret_colored218_v0}"
    array_36=("")
    printf__106_v0 "  \$XYLITOL_PRIMARY_COLOR     Set the primary color ""${ret_colored218_v0__26_68}""
" array_36[@]
    colored__218_v0 "(default: 3;118;206;94)" 90
    ret_colored218_v0__27_70="${ret_colored218_v0}"
    array_37=("")
    printf__106_v0 "  \$XYLITOL_SECONDARY_COLOR   Set the secondary color ""${ret_colored218_v0__27_70}""
" array_37[@]
    colored__218_v0 "(default: 234;72;121;95)" 90
    ret_colored218_v0__28_67="${ret_colored218_v0}"
    array_38=("")
    printf__106_v0 "  \$XYLITOL_ACCENT_COLOR      Set the accent color ""${ret_colored218_v0__28_67}""
" array_38[@]
    echo ""
    colored_accent__200_v0 "./xylitol.sh <command> --help"
    ret_colored_accent200_v0__30_21="${ret_colored_accent200_v0}"
    array_39=("")
    printf__106_v0 "Run ""${ret_colored_accent200_v0__30_21}"" for more information on a command.
" array_39[@]
}

math_floor__420_v0() {
    local number=$1
    command_40="$(echo "${number}" | awk '{printf "%d", ($1 < 0 ? int($1) - 1 : int($1))}')"
    __status=$?
    ret_math_floor420_v0="${command_40}"
    return 0
}

math_ceil__421_v0() {
    local number=$1
    math_floor__420_v0 "${number}"
    ret_math_floor420_v0__52_12="${ret_math_floor420_v0}"
    ret_math_ceil421_v0="$(( ${ret_math_floor420_v0__52_12} + 1 ))"
    return 0
}

# Perl Extensions Utilities
command_41="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_12="$([ "_${command_41}" != "_No" ]; echo $?)"
command_42="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_13="$(( $(( ! ${_perl_disabled_12} )) && $([ "_${command_42}" != "_0" ]; echo $?) ))"
perl_get_cjk_width__476_v0() {
    local text=$1
    if [ "$(( ! ${_perl_available_13} ))" != 0 ]; then
        ret_perl_get_cjk_width476_v0=''
        return 1
    fi
    command_43="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width476_v0=''
        return "${__status}"
    fi
    width_str_107="${command_43}"
    parse_int__14_v0 "${width_str_107}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width476_v0=''
        return "${__status}"
    fi
    width_108="${ret_parse_int14_v0}"
    ret_perl_get_cjk_width476_v0="${width_108}"
    return 0
}

perl_truncate_cjk__477_v0() {
    local text=$1
    local max_width=$2
    if [ "$(( ! ${_perl_available_13} ))" != 0 ]; then
        ret_perl_truncate_cjk477_v0=''
        return 1
    fi
    command_44="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text}" ${max_width} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk477_v0=''
        return "${__status}"
    fi
    result_111="${command_44}"
    ret_perl_truncate_cjk477_v0="${result_111}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_14=0
_term_size_15=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
stty_lock__485_v0() {
    command_46="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_93="${command_46}"
    parse_int__14_v0 "${count_93}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_94="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_94} == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_94="$(( ${count_num_94} + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_94}
    __status=$?
}

stty_unlock__486_v0() {
    command_47="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_141="${command_47}"
    parse_int__14_v0 "${count_141}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_142="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_142} > 0 ))" != 0 ]; then
        count_num_142="$(( ${count_num_142} - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_142}
        __status=$?
        if [ "$(( ${count_num_142} == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

parse_size__487_v0() {
    local text=$1
    # `match_regex` uses BRE by default, where `+` is a literal character
    match_regex__20_v0 "${text}" "^[0-9][0-9]*\$" 0
    ret_match_regex20_v0__38_12="${ret_match_regex20_v0}"
    if [ "$(( ! ${ret_match_regex20_v0__38_12} ))" != 0 ]; then
        ret_parse_size487_v0=0
        return 0
    fi
    parse_int__14_v0 "${text}"
    __status=$?
    ret_parse_size487_v0="${ret_parse_int14_v0}"
    return 0
}

query_term_size__488_v0() {
    command_48="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; echo "$height; $width")"
    __status=$?
    result_95="${command_48}"
    split__5_v0 "${result_95}" ";"
    parts_96=("${ret_split5_v0[@]}")
    __length_49=("${parts_96[@]}")
    if [ "$(( ${#__length_49[@]} != 2 ))" != 0 ]; then
        ret_query_term_size488_v0=0
        return 0
    fi
    parse_size__487_v0 "${parts_96[0]}"
    rows_97="${ret_parse_size487_v0}"
    parse_size__487_v0 "${parts_96[1]}"
    cols_98="${ret_parse_size487_v0}"
    if [ "$(( $(( ${rows_97} <= 0 )) || $(( ${cols_98} <= 0 )) ))" != 0 ]; then
        ret_query_term_size488_v0=0
        return 0
    fi
    _term_size_15=("${cols_98}" "${rows_97}")
    ret_query_term_size488_v0=1
    return 0
}

stty_term_size__489_v0() {
    command_51="$(stty size < /dev/tty 2>/dev/null)"
    __status=$?
    result_100="${command_51}"
    split__5_v0 "${result_100}" " "
    parts_101=("${ret_split5_v0[@]}")
    __length_52=("${parts_101[@]}")
    if [ "$(( ${#__length_52[@]} != 2 ))" != 0 ]; then
        ret_stty_term_size489_v0=0
        return 0
    fi
    parse_size__487_v0 "${parts_101[0]}"
    rows_102="${ret_parse_size487_v0}"
    parse_size__487_v0 "${parts_101[1]}"
    cols_103="${ret_parse_size487_v0}"
    if [ "$(( $(( ${rows_102} <= 0 )) || $(( ${cols_103} <= 0 )) ))" != 0 ]; then
        ret_stty_term_size489_v0=0
        return 0
    fi
    _term_size_15=("${cols_103}" "${rows_102}")
    ret_stty_term_size489_v0=1
    return 0
}

get_term_size__490_v0() {
    query_term_size__488_v0 
    detected_99="${ret_query_term_size488_v0}"
    if [ "$(( ! ${detected_99} ))" != 0 ]; then
        stty_term_size__489_v0 
        detected_99="${ret_stty_term_size489_v0__84_20}"
    fi
    _got_term_size_14=1
}

term_width__492_v0() {
    if [ "$(( ! ${_got_term_size_14} ))" != 0 ]; then
        get_term_size__490_v0 
    fi
    ret_term_width492_v0="${_term_size_15[0]}"
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
get_supports_truecolor__503_v0() {
    env_var_get__98_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    config_86="${ret_env_var_get98_v0}"
    if [ "$([ "_${config_86}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_16="No"
        ret_get_supports_truecolor503_v0=0
        return 0
    fi
    env_var_get__98_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_16="No"
        ret_get_supports_truecolor503_v0=0
        return 0
    fi
    colorterm_87="${ret_env_var_get98_v0}"
    _supports_truecolor_16="$(if [ "$(( $([ "_${colorterm_87}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_87}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor503_v0="$([ "_${_supports_truecolor_16}" != "_Yes" ]; echo $?)"
    return 0
}

colored_rgb__504_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    if [ "$([ "_${_supports_truecolor_16}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb504_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_16}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__503_v0 
        ret_get_supports_truecolor503_v0__50_17="${ret_get_supports_truecolor503_v0}"
        if [ "${ret_get_supports_truecolor503_v0__50_17}" != 0 ]; then
            ret_colored_rgb504_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
            return 0
        elif [ "$(( ${fallback} == 0 ))" != 0 ]; then
            ret_colored_rgb504_v0="${message}"
            return 0
        else
            ret_colored_rgb504_v0="\\x1b[${fallback}m""${message}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( ${fallback} == 0 ))" != 0 ]; then
            ret_colored_rgb504_v0="${message}"
            return 0
        fi
        ret_colored_rgb504_v0="\\x1b[${fallback}m""${message}""\\x1b[0m"
        return 0
    fi
}

inner_get_xylitol_colors__506_v0() {
    if [ "$(( ! ${_got_xylitol_colors_17} ))" != 0 ]; then
        env_var_get__98_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        primary_env_80="${ret_env_var_get98_v0}"
        if [ "$([ "_${primary_env_80}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${primary_env_80}" ";"
            parts_81=("${ret_split5_v0[@]}")
            __length_57=("${parts_81[@]}")
            if [ "$(( ${#__length_57[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_81[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors506_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__115_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_81[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors506_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__116_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_81[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors506_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__117_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_81[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors506_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__118_21="${ret_parse_int14_v0}"
                _primary_color_18=("${ret_parse_int14_v0__115_21}" "${ret_parse_int14_v0__116_21}" "${ret_parse_int14_v0__117_21}" "${ret_parse_int14_v0__118_21}")
            fi
        fi
        env_var_get__98_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        secondary_env_82="${ret_env_var_get98_v0}"
        if [ "$([ "_${secondary_env_82}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${secondary_env_82}" ";"
            parts_83=("${ret_split5_v0[@]}")
            __length_59=("${parts_83[@]}")
            if [ "$(( ${#__length_59[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_83[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors506_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__128_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_83[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors506_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__129_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_83[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors506_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__130_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_83[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors506_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__131_21="${ret_parse_int14_v0}"
                _secondary_color_19=("${ret_parse_int14_v0__128_21}" "${ret_parse_int14_v0__129_21}" "${ret_parse_int14_v0__130_21}" "${ret_parse_int14_v0__131_21}")
            fi
        fi
        env_var_get__98_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        accent_env_84="${ret_env_var_get98_v0}"
        if [ "$([ "_${accent_env_84}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${accent_env_84}" ";"
            parts_85=("${ret_split5_v0[@]}")
            __length_61=("${parts_85[@]}")
            if [ "$(( ${#__length_61[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_85[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors506_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__141_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_85[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors506_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__142_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_85[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors506_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__143_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_85[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors506_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__144_21="${ret_parse_int14_v0}"
            fi
        fi
        _got_xylitol_colors_17=1
    fi
}

get_xylitol_colors__507_v0() {
    inner_get_xylitol_colors__506_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__112_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_17=1
}

colored_primary__508_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_17} ))" != 0 ]; then
        get_xylitol_colors__507_v0 
    fi
    colored_rgb__504_v0 "${message}" "${_primary_color_18[0]}" "${_primary_color_18[1]}" "${_primary_color_18[2]}" "${_primary_color_18[3]}"
    ret_colored_primary508_v0="${ret_colored_rgb504_v0}"
    return 0
}

colored_secondary__509_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_17} ))" != 0 ]; then
        get_xylitol_colors__507_v0 
    fi
    colored_rgb__504_v0 "${message}" "${_secondary_color_19[0]}" "${_secondary_color_19[1]}" "${_secondary_color_19[2]}" "${_secondary_color_19[3]}"
    ret_colored_secondary509_v0="${ret_colored_rgb504_v0}"
    return 0
}

# // IO Functions /////
get_char__523_v0() {
    command_63="$(read -n 1 key < /dev/tty; printf "%s" "$key")"
    __status=$?
    char_138="${command_63}"
    ret_get_char523_v0="${char_138}"
    return 0
}

eprintf__526_v0() {
    local format=$1
    local args=("${!2}")
    args=("${format}" "${args[@]}")
    __status=$?
    printf "${args[@]}" >&2
    __status=$?
}

eprintf_colored__527_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    array_64=("${message}")
    eprintf__526_v0 "\\x1b[${color}m%s\\x1b[0m" array_64[@]
}

colored__528_v0() {
    local message=$1
    local color=$2
    # Returns a text wrapped in color codes.
    ret_colored528_v0="\\x1b[${color}m""${message}""\\x1b[0m"
    return 0
}

remove__529_v0() {
    local cnt=$1
    if [ "$(( ${cnt} > 0 ))" != 0 ]; then
        array_65=("")
        eprintf__526_v0 "\\x1b[${cnt}D\\x1b[K" array_65[@]
    fi
}

remove_line__530_v0() {
    local cnt=$1
    if [ "$(( ${cnt} > 0 ))" != 0 ]; then
        sequence_145=""
        from=0
        to="${cnt}"
        for ____146 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
            sequence_145+="\\x1b[2K\\x1b[1A"
        done
        array_66=("")
        eprintf__526_v0 "${sequence_145}" array_66[@]
    fi
    array_67=("")
    eprintf__526_v0 "\\x1b[9999D" array_67[@]
}

remove_current_line__531_v0() {
    array_68=("")
    eprintf__526_v0 "\\x1b[2K\\x1b[9999D" array_68[@]
}

new_line__533_v0() {
    local cnt=$1
    from=0
    to="${cnt}"
    for i_127 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        array_69=("")
        eprintf__526_v0 "
" array_69[@]
    done
}

go_up__534_v0() {
    local cnt=$1
    array_70=("")
    eprintf__526_v0 "\\x1b[${cnt}A" array_70[@]
}

go_down__535_v0() {
    local cnt=$1
    array_71=("")
    eprintf__526_v0 "\\x1b[${cnt}B" array_71[@]
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
has_ansi_escape__539_v0() {
    local text=$1
    # Check for ESC character (0x1B = 27) or literal \x1b[
    command_72="$([[ "${text}" == *$'\x1b'* || "${text}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    has_escape_91="${command_72}"
    ret_has_ansi_escape539_v0="$([ "_${has_escape_91}" != "_1" ]; echo $?)"
    return 0
}

escape_ansi__540_v0() {
    local text=$1
    command_73="$(printf '%s' "${text}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi540_v0="${command_73}"
    return 0
}

strip_ansi__541_v0() {
    local text=$1
    command_74="$(printf "%s" "${text}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi541_v0="${command_74}"
    return 0
}

is_all_ascii__542_v0() {
    local text=$1
    command_75="$(printf "%s" "${text}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    result_106="${command_75}"
    ret_is_all_ascii542_v0="$([ "_${result_106}" != "_0" ]; echo $?)"
    return 0
}

get_visible_len__543_v0() {
    local text=$1
    strip_ansi__541_v0 "${text}"
    stripped_105="${ret_strip_ansi541_v0}"
    # Check if text is all ASCII
    is_all_ascii__542_v0 "${stripped_105}"
    ret_is_all_ascii542_v0__150_12="${ret_is_all_ascii542_v0}"
    if [ "$(( ! ${ret_is_all_ascii542_v0__150_12} ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__476_v0 "${stripped_105}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            __length_76="${stripped_105}"
            ret_get_visible_len543_v0="${#__length_76}"
            return 0
        fi
        ret_get_visible_len543_v0="${ret_perl_get_cjk_width476_v0}"
        return 0
    else
        __length_77="${stripped_105}"
        ret_get_visible_len543_v0="${#__length_77}"
        return 0
    fi
}

truncate_text__544_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__543_v0 "${text}"
    visible_len_110="${ret_get_visible_len543_v0}"
    if [ "$(( ${visible_len_110} <= ${max_width} ))" != 0 ]; then
        ret_truncate_text544_v0="${text}"
        return 0
    fi
    is_all_ascii__542_v0 "${text}"
    ret_is_all_ascii542_v0__167_12="${ret_is_all_ascii542_v0}"
    if [ "$(( ! ${ret_is_all_ascii542_v0__167_12} ))" != 0 ]; then
        perl_truncate_cjk__477_v0 "${text}" "${max_width}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text}" | cut -c1-${max_width}
            __status=$?
        fi
        ret_truncate_text544_v0="${ret_perl_truncate_cjk477_v0}"
        return 0
    fi
    command_78="$(printf "%s" "${text}" | cut -c1-${max_width})"
    __status=$?
    ret_truncate_text544_v0="${command_78}"
    return 0
}

truncate_ansi__545_v0() {
    local text=$1
    local max_width=$2
    has_ansi_escape__539_v0 "${text}"
    ret_has_ansi_escape539_v0__179_12="${ret_has_ansi_escape539_v0}"
    if [ "$(( ! ${ret_has_ansi_escape539_v0__179_12} ))" != 0 ]; then
        truncate_text__544_v0 "${text}" "${max_width}"
        ret_truncate_ansi545_v0="${ret_truncate_text544_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    command_79="$([[ "${text}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    starts_with_ansi_112="${command_79}"
    # Replace \x1b[ with newline, then split
    command_80="$(t="${text}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    replaced_113="${command_80}"
    split__5_v0 "${replaced_113}" "
"
    parts_114=("${ret_split5_v0[@]}")
    result_115=""
    remaining_width_116="${max_width}"
    from=0
    __length_81=("${parts_114[@]}")
    to="${#__length_81[@]}"
    for idx_117 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        part_118="${parts_114[${idx_117}]}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( ${idx_117} == 0 )) && $([ "_${starts_with_ansi_112}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_118}" == "_" ]; echo $?) && $(( ${remaining_width_116} > 0 )) ))" != 0 ]; then
                truncate_text__544_v0 "${part_118}" "${remaining_width_116}"
                truncated_119="${ret_truncate_text544_v0}"
                result_115+="${truncated_119}"
                get_visible_len__543_v0 "${truncated_119}"
                ret_get_visible_len543_v0__203_36="${ret_get_visible_len543_v0}"
                remaining_width_116="$(( ${remaining_width_116} - ${ret_get_visible_len543_v0__203_36} ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            command_82="$(__p="${part_118}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            m_idx_120="${command_82}"
            if [ "$([ "_${m_idx_120}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                command_83="$(__p="${part_118}"; printf "%s" "${__p:0:${m_idx_120}}")"
                __status=$?
                ansi_params_121="${command_83}"
                result_115+="\\x1b[""${ansi_params_121}""m"
                # Rest is text content
                parse_int__14_v0 "${m_idx_120}"
                __status=$?
                m_idx_num_122="${ret_parse_int14_v0}"
                text_start_123="$(( ${m_idx_num_122} + 1 ))"
                command_84="$(__p="${part_118}"; printf "%s" "${__p:${text_start_123}}")"
                __status=$?
                text_part_124="${command_84}"
                if [ "$(( $([ "_${text_part_124}" == "_" ]; echo $?) && $(( ${remaining_width_116} > 0 )) ))" != 0 ]; then
                    truncate_text__544_v0 "${text_part_124}" "${remaining_width_116}"
                    truncated_125="${ret_truncate_text544_v0}"
                    result_115+="${truncated_125}"
                    get_visible_len__543_v0 "${truncated_125}"
                    ret_get_visible_len543_v0__220_40="${ret_get_visible_len543_v0}"
                    remaining_width_116="$(( ${remaining_width_116} - ${ret_get_visible_len543_v0__220_40} ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_118}" == "_" ]; echo $?) && $(( ${remaining_width_116} > 0 )) ))" != 0 ]; then
                    truncate_text__544_v0 "${part_118}" "${remaining_width_116}"
                    truncated_126="${ret_truncate_text544_v0}"
                    result_115+="${truncated_126}"
                    get_visible_len__543_v0 "${truncated_126}"
                    remaining_width_116="$(( ${remaining_width_116} - ${ret_get_visible_len543_v0__227_40} ))"
                fi
            fi
        fi
    done
    ret_truncate_ansi545_v0="${result_115}"
    return 0
}

cutoff_text__546_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__543_v0 "${text}"
    visible_len_109="${ret_get_visible_len543_v0}"
    if [ "$(( ${visible_len_109} <= ${max_width} ))" != 0 ]; then
        ret_cutoff_text546_v0="${text}"
        return 0
    fi
    truncate_ansi__545_v0 "${text}" "$(( ${max_width} - 3 ))"
    ret_truncate_ansi545_v0__243_12="${ret_truncate_ansi545_v0}"
    ret_cutoff_text546_v0="${ret_truncate_ansi545_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
render_tooltip__547_v0() {
    local items=("${!1}")
    local total_len=$2
    local term_width=$3
    separator_128=" • "
    separator_len_129=3
    # Fast path: no truncation needed
    if [ "$(( ${total_len} <= ${term_width} ))" != 0 ]; then
        iter_130=0
        while :
        do
            __length_85=("${items[@]}")
            if [ "$(( ${iter_130} >= ${#__length_85[@]} ))" != 0 ]; then
                break
            elif [ "$(( ${iter_130} > 0 ))" != 0 ]; then
                eprintf_colored__527_v0 "${separator_128}" 90
            fi
            colored__528_v0 "${items[$(( ${iter_130} + 1 ))]}" 2
            ret_colored528_v0__268_41="${ret_colored528_v0}"
            array_86=("")
            eprintf__526_v0 "${items[${iter_130}]}"" ""${ret_colored528_v0__268_41}" array_86[@]
            iter_130="$(( ${iter_130} + 2 ))"
        done
    else
        # Slow path: truncate
        current_len_131=0
        first_132=1
        iter_133=0
        while :
        do
            __length_87=("${items[@]}")
            if [ "$(( ${iter_133} >= ${#__length_87[@]} ))" != 0 ]; then
                break
            fi
            key_134="${items[${iter_133}]}"
            action_135="${items[$(( ${iter_133} + 1 ))]}"
            __length_88="${key_134}"
            __length_89="${action_135}"
            part_len_136="$(( $(( ${#__length_88} + 1 )) + ${#__length_89} ))"
            needed_137="${part_len_136}"
            if [ "$(( ! ${first_132} ))" != 0 ]; then
                needed_137="$(( ${needed_137} + ${separator_len_129} ))"
            fi
            if [ "$(( $(( ${current_len_131} + ${needed_137} )) > ${term_width} ))" != 0 ]; then
                break
            fi
            if [ "$(( ! ${first_132} ))" != 0 ]; then
                eprintf_colored__527_v0 "${separator_128}" 90
            fi
            colored__528_v0 "${action_135}" 2
            ret_colored528_v0__296_33="${ret_colored528_v0}"
            array_90=("")
            eprintf__526_v0 "${key_134}"" ""${ret_colored528_v0__296_33}" array_90[@]
            current_len_131="$(( ${current_len_131} + ${needed_137} ))"
            first_132=0
            iter_133="$(( ${iter_133} + 2 ))"
        done
    fi
}

xyl_input__597_v0() {
    local prompt=$1
    local placeholder=$2
    local header=$3
    local password=$4
    stty_lock__485_v0 
    term_width__492_v0 
    term_width_104="${ret_term_width492_v0}"
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__546_v0 "${header}" "${term_width_104}"
        ret_cutoff_text546_v0__23_17="${ret_cutoff_text546_v0}"
        array_91=("")
        eprintf__526_v0 "${ret_cutoff_text546_v0__23_17}""
" array_91[@]
    fi
    new_line__533_v0 2
    # "enter submit" = 12
    array_92=("enter" "submit")
    render_tooltip__547_v0 array_92[@] 12 "${term_width_104}"
    go_up__534_v0 2
    array_93=("")
    eprintf__526_v0 "\\x1b[99999D" array_93[@]
    array_94=("")
    eprintf__526_v0 "${prompt}" array_94[@]
    eprintf_colored__527_v0 "${placeholder}" 90
    get_char__523_v0 
    char_139="${ret_get_char523_v0}"
    __length_95="${prompt}"
    remove__529_v0 "${#__length_95}"
    __length_96="${placeholder}"
    remove__529_v0 "$(( ${#__length_96} + 1 ))"
    text_140=""
    if [ "$(( ! ${password} ))" != 0 ]; then
        stty_unlock__486_v0 
        command_97="$(read -e -i ${char_139} -p "${prompt}" text < /dev/tty; printf "%s" "$text")"
        __status=$?
        text_140="${command_97}"
    else
        stty_unlock__486_v0 
        command_98="$(read -es -i ${char_139} -p "${prompt}" text < /dev/tty; printf "%s" "$text")"
        __status=$?
        text_140="${command_98}"
    fi
    stty_lock__485_v0 
    # Calculate how many lines the input takes up (prompt + text may wrap)
    get_visible_len__543_v0 "${prompt}""${text_140}"
    input_display_len_143="${ret_get_visible_len543_v0}"
    math_ceil__421_v0 "$(( ${input_display_len_143} / ${term_width_104} ))"
    input_lines_144="${ret_math_ceil421_v0}"
    if [ "$(( ${input_lines_144} < 3 ))" != 0 ]; then
        go_down__535_v0 "$(( 2 - ${input_lines_144} ))"
        remove_line__530_v0 2
        remove_current_line__531_v0 
    fi
    if [ "$(( ${input_lines_144} >= 3 ))" != 0 ]; then
        remove_line__530_v0 "${input_lines_144}"
    fi
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        remove_line__530_v0 1
        remove_current_line__531_v0 
    fi
    stty_unlock__486_v0 
    ret_xyl_input597_v0="${text_140}"
    return 0
}

print_input_help__673_v0() {
    echo "Usage: ./xylitol.sh input [flags]"
    echo ""
    colored_primary__508_v0 "input"
    ret_colored_primary508_v0__7_12="${ret_colored_primary508_v0}"
    array_99=("")
    printf__106_v0 "${ret_colored_primary508_v0__7_12}" array_99[@]
    array_100=("")
    printf__106_v0 " - Prompt for some input from the user." array_100[@]
    echo ""
    echo ""
    colored_secondary__509_v0 "Flags: "
    ret_colored_secondary509_v0__11_12="${ret_colored_secondary509_v0}"
    array_101=("")
    printf__106_v0 "${ret_colored_secondary509_v0__11_12}""
" array_101[@]
    echo "  -h, --help                 Show this help message"
    echo "  --placeholder=\"<text>\"     Set the placeholder text (default: 'Type here...')"
    echo "  --prompt=\"<text>\"          Set the prompt text (default: '> ')"
    echo "  --header=\"<text>\"          Set a header text to display above the prompt (ANSI escape supported)"
    echo "  --password                 Hide input (for password entry)"
    echo ""
}

execute_input__724_v0() {
    local parameters=("${!1}")
    prompt_69="> "
    placeholder_70="Type here..."
    header_71=""
    password_72=0
    for param_73 in "${parameters[@]}"; do
        match_regex__20_v0 "${param_73}" "^-h\$" 0
        ret_match_regex20_v0__13_12="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_73}" "^--help\$" 0
        ret_match_regex20_v0__13_42="${ret_match_regex20_v0}"
        if [ "$(( ${ret_match_regex20_v0__13_12} || ${ret_match_regex20_v0__13_42} ))" != 0 ]; then
            print_input_help__673_v0 
            exit 0
        fi
        match_regex__20_v0 "${param_73}" "^--prompt=.*\$" 0
        ret_match_regex20_v0__17_12="${ret_match_regex20_v0}"
        if [ "${ret_match_regex20_v0__17_12}" != 0 ]; then
            split__5_v0 "${param_73}" "="
            result_88=("${ret_split5_v0[@]}")
            prompt_69="${result_88[1]}"
        fi
        match_regex__20_v0 "${param_73}" "^--placeholder=.*\$" 0
        ret_match_regex20_v0__21_12="${ret_match_regex20_v0}"
        if [ "${ret_match_regex20_v0__21_12}" != 0 ]; then
            split__5_v0 "${param_73}" "="
            result_89=("${ret_split5_v0[@]}")
            placeholder_70="${result_89[1]}"
        fi
        match_regex__20_v0 "${param_73}" "^--header=.*\$" 0
        ret_match_regex20_v0__25_12="${ret_match_regex20_v0}"
        if [ "${ret_match_regex20_v0__25_12}" != 0 ]; then
            split__5_v0 "${param_73}" "="
            result_90=("${ret_split5_v0[@]}")
            header_71="${result_90[1]}"
        fi
        match_regex__20_v0 "${param_73}" "^--password\$" 0
        ret_match_regex20_v0__29_12="${ret_match_regex20_v0}"
        if [ "${ret_match_regex20_v0__29_12}" != 0 ]; then
            password_72=1
        fi
    done
    has_ansi_escape__539_v0 "${header_71}"
    ret_has_ansi_escape539_v0__34_42="${ret_has_ansi_escape539_v0}"
    escape_ansi__540_v0 "${header_71}"
    ret_escape_ansi540_v0__34_71="${ret_escape_ansi540_v0}"
    colored_primary__508_v0 "${header_71}"
    ret_colored_primary508_v0__34_109="${ret_colored_primary508_v0}"
    display_header_92="$(if [ "$(( $([ "_${header_71}" != "_" ]; echo $?) || ${ret_has_ansi_escape539_v0__34_42} ))" != 0 ]; then echo "${ret_escape_ansi540_v0__34_71}"; else echo "\\x1b[1m""${ret_colored_primary508_v0__34_109}"; fi)"
    xyl_input__597_v0 "${prompt_69}" "${placeholder_70}" "${display_header_92}" "${password_72}"
    ret_execute_input724_v0="${ret_xyl_input597_v0}"
    return 0
}

# Perl Extensions Utilities
command_102="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_21="$([ "_${command_102}" != "_No" ]; echo $?)"
command_103="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_22="$(( $(( ! ${_perl_disabled_21} )) && $([ "_${command_103}" != "_0" ]; echo $?) ))"
perl_get_cjk_width__833_v0() {
    local text=$1
    if [ "$(( ! ${_perl_available_22} ))" != 0 ]; then
        ret_perl_get_cjk_width833_v0=''
        return 1
    fi
    command_104="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width833_v0=''
        return "${__status}"
    fi
    width_str_186="${command_104}"
    parse_int__14_v0 "${width_str_186}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width833_v0=''
        return "${__status}"
    fi
    width_187="${ret_parse_int14_v0}"
    ret_perl_get_cjk_width833_v0="${width_187}"
    return 0
}

perl_truncate_cjk__834_v0() {
    local text=$1
    local max_width=$2
    if [ "$(( ! ${_perl_available_22} ))" != 0 ]; then
        ret_perl_truncate_cjk834_v0=''
        return 1
    fi
    command_105="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text}" ${max_width} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk834_v0=''
        return "${__status}"
    fi
    result_190="${command_105}"
    ret_perl_truncate_cjk834_v0="${result_190}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_23=0
_term_size_24=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
stty_lock__842_v0() {
    command_107="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_170="${command_107}"
    parse_int__14_v0 "${count_170}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_171="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_171} == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_171="$(( ${count_num_171} + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_171}
    __status=$?
}

stty_unlock__843_v0() {
    command_108="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_260="${command_108}"
    parse_int__14_v0 "${count_260}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_261="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_261} > 0 ))" != 0 ]; then
        count_num_261="$(( ${count_num_261} - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_261}
        __status=$?
        if [ "$(( ${count_num_261} == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

parse_size__844_v0() {
    local text=$1
    # `match_regex` uses BRE by default, where `+` is a literal character
    match_regex__20_v0 "${text}" "^[0-9][0-9]*\$" 0
    ret_match_regex20_v0__38_12="${ret_match_regex20_v0}"
    if [ "$(( ! ${ret_match_regex20_v0__38_12} ))" != 0 ]; then
        ret_parse_size844_v0=0
        return 0
    fi
    parse_int__14_v0 "${text}"
    __status=$?
    ret_parse_size844_v0="${ret_parse_int14_v0}"
    return 0
}

query_term_size__845_v0() {
    command_109="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; echo "$height; $width")"
    __status=$?
    result_172="${command_109}"
    split__5_v0 "${result_172}" ";"
    parts_173=("${ret_split5_v0[@]}")
    __length_110=("${parts_173[@]}")
    if [ "$(( ${#__length_110[@]} != 2 ))" != 0 ]; then
        ret_query_term_size845_v0=0
        return 0
    fi
    parse_size__844_v0 "${parts_173[0]}"
    rows_174="${ret_parse_size844_v0}"
    parse_size__844_v0 "${parts_173[1]}"
    cols_175="${ret_parse_size844_v0}"
    if [ "$(( $(( ${rows_174} <= 0 )) || $(( ${cols_175} <= 0 )) ))" != 0 ]; then
        ret_query_term_size845_v0=0
        return 0
    fi
    _term_size_24=("${cols_175}" "${rows_174}")
    ret_query_term_size845_v0=1
    return 0
}

stty_term_size__846_v0() {
    command_112="$(stty size < /dev/tty 2>/dev/null)"
    __status=$?
    result_177="${command_112}"
    split__5_v0 "${result_177}" " "
    parts_178=("${ret_split5_v0[@]}")
    __length_113=("${parts_178[@]}")
    if [ "$(( ${#__length_113[@]} != 2 ))" != 0 ]; then
        ret_stty_term_size846_v0=0
        return 0
    fi
    parse_size__844_v0 "${parts_178[0]}"
    rows_179="${ret_parse_size844_v0}"
    parse_size__844_v0 "${parts_178[1]}"
    cols_180="${ret_parse_size844_v0}"
    if [ "$(( $(( ${rows_179} <= 0 )) || $(( ${cols_180} <= 0 )) ))" != 0 ]; then
        ret_stty_term_size846_v0=0
        return 0
    fi
    _term_size_24=("${cols_180}" "${rows_179}")
    ret_stty_term_size846_v0=1
    return 0
}

get_term_size__847_v0() {
    query_term_size__845_v0 
    detected_176="${ret_query_term_size845_v0}"
    if [ "$(( ! ${detected_176} ))" != 0 ]; then
        stty_term_size__846_v0 
        detected_176="${ret_stty_term_size846_v0__84_20}"
    fi
    _got_term_size_23=1
}

term_width__849_v0() {
    if [ "$(( ! ${_got_term_size_23} ))" != 0 ]; then
        get_term_size__847_v0 
    fi
    ret_term_width849_v0="${_term_size_24[0]}"
    return 0
}

term_height__850_v0() {
    if [ "$(( ! ${_got_term_size_23} ))" != 0 ]; then
        get_term_size__847_v0 
    fi
    ret_term_height850_v0="${_term_size_24[1]}"
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
get_supports_truecolor__860_v0() {
    env_var_get__98_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    config_154="${ret_env_var_get98_v0}"
    if [ "$([ "_${config_154}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_25="No"
        ret_get_supports_truecolor860_v0=0
        return 0
    fi
    env_var_get__98_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_25="No"
        ret_get_supports_truecolor860_v0=0
        return 0
    fi
    colorterm_155="${ret_env_var_get98_v0}"
    _supports_truecolor_25="$(if [ "$(( $([ "_${colorterm_155}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_155}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor860_v0="$([ "_${_supports_truecolor_25}" != "_Yes" ]; echo $?)"
    return 0
}

colored_rgb__861_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    if [ "$([ "_${_supports_truecolor_25}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb861_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_25}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__860_v0 
        ret_get_supports_truecolor860_v0__50_17="${ret_get_supports_truecolor860_v0}"
        if [ "${ret_get_supports_truecolor860_v0__50_17}" != 0 ]; then
            ret_colored_rgb861_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
            return 0
        elif [ "$(( ${fallback} == 0 ))" != 0 ]; then
            ret_colored_rgb861_v0="${message}"
            return 0
        else
            ret_colored_rgb861_v0="\\x1b[${fallback}m""${message}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( ${fallback} == 0 ))" != 0 ]; then
            ret_colored_rgb861_v0="${message}"
            return 0
        fi
        ret_colored_rgb861_v0="\\x1b[${fallback}m""${message}""\\x1b[0m"
        return 0
    fi
}

inner_get_xylitol_colors__863_v0() {
    if [ "$(( ! ${_got_xylitol_colors_26} ))" != 0 ]; then
        env_var_get__98_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        primary_env_148="${ret_env_var_get98_v0}"
        if [ "$([ "_${primary_env_148}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${primary_env_148}" ";"
            parts_149=("${ret_split5_v0[@]}")
            __length_118=("${parts_149[@]}")
            if [ "$(( ${#__length_118[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_149[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors863_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__115_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_149[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors863_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__116_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_149[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors863_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__117_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_149[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors863_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__118_21="${ret_parse_int14_v0}"
                _primary_color_27=("${ret_parse_int14_v0__115_21}" "${ret_parse_int14_v0__116_21}" "${ret_parse_int14_v0__117_21}" "${ret_parse_int14_v0__118_21}")
            fi
        fi
        env_var_get__98_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        secondary_env_150="${ret_env_var_get98_v0}"
        if [ "$([ "_${secondary_env_150}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${secondary_env_150}" ";"
            parts_151=("${ret_split5_v0[@]}")
            __length_120=("${parts_151[@]}")
            if [ "$(( ${#__length_120[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_151[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors863_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__128_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_151[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors863_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__129_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_151[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors863_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__130_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_151[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors863_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__131_21="${ret_parse_int14_v0}"
                _secondary_color_28=("${ret_parse_int14_v0__128_21}" "${ret_parse_int14_v0__129_21}" "${ret_parse_int14_v0__130_21}" "${ret_parse_int14_v0__131_21}")
            fi
        fi
        env_var_get__98_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        accent_env_152="${ret_env_var_get98_v0}"
        if [ "$([ "_${accent_env_152}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${accent_env_152}" ";"
            parts_153=("${ret_split5_v0[@]}")
            __length_122=("${parts_153[@]}")
            if [ "$(( ${#__length_122[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_153[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors863_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__141_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_153[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors863_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__142_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_153[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors863_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__143_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_153[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors863_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__144_21="${ret_parse_int14_v0}"
            fi
        fi
        _got_xylitol_colors_26=1
    fi
}

get_xylitol_colors__864_v0() {
    inner_get_xylitol_colors__863_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__112_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_26=1
}

colored_primary__865_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_26} ))" != 0 ]; then
        get_xylitol_colors__864_v0 
    fi
    colored_rgb__861_v0 "${message}" "${_primary_color_27[0]}" "${_primary_color_27[1]}" "${_primary_color_27[2]}" "${_primary_color_27[3]}"
    ret_colored_primary865_v0="${ret_colored_rgb861_v0}"
    return 0
}

colored_secondary__866_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_26} ))" != 0 ]; then
        get_xylitol_colors__864_v0 
    fi
    colored_rgb__861_v0 "${message}" "${_secondary_color_28[0]}" "${_secondary_color_28[1]}" "${_secondary_color_28[2]}" "${_secondary_color_28[3]}"
    ret_colored_secondary866_v0="${ret_colored_rgb861_v0}"
    return 0
}

# // IO Functions /////
get_key__881_v0() {
    command_124="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    var_238="${command_124}"
    if [ "$([ "_${var_238}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key881_v0="UP"
        return 0
    elif [ "$([ "_${var_238}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key881_v0="DOWN"
        return 0
    elif [ "$([ "_${var_238}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key881_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_238}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key881_v0="LEFT"
        return 0
    elif [ "$([ "_${var_238}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key881_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_238}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key881_v0="INPUT"
        return 0
    else
        ret_get_key881_v0="${var_238}"
        return 0
    fi
}

eprintf__883_v0() {
    local format=$1
    local args=("${!2}")
    args=("${format}" "${args[@]}")
    __status=$?
    printf "${args[@]}" >&2
    __status=$?
}

eprintf_colored__884_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    array_125=("${message}")
    eprintf__883_v0 "\\x1b[${color}m%s\\x1b[0m" array_125[@]
}

colored__885_v0() {
    local message=$1
    local color=$2
    # Returns a text wrapped in color codes.
    ret_colored885_v0="\\x1b[${color}m""${message}""\\x1b[0m"
    return 0
}

remove_line__887_v0() {
    local cnt=$1
    if [ "$(( ${cnt} > 0 ))" != 0 ]; then
        sequence_251=""
        from=0
        to="${cnt}"
        for ____252 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
            sequence_251+="\\x1b[2K\\x1b[1A"
        done
        array_126=("")
        eprintf__883_v0 "${sequence_251}" array_126[@]
    fi
    array_127=("")
    eprintf__883_v0 "\\x1b[9999D" array_127[@]
}

remove_current_line__888_v0() {
    array_128=("")
    eprintf__883_v0 "\\x1b[2K\\x1b[9999D" array_128[@]
}

print_blank__889_v0() {
    local cnt=$1
    printf '%*s' "${cnt}" ' ' >&2
    __status=$?
}

new_line__890_v0() {
    local cnt=$1
    from=0
    to="${cnt}"
    for i_210 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        array_129=("")
        eprintf__883_v0 "
" array_129[@]
    done
}

go_up__891_v0() {
    local cnt=$1
    array_130=("")
    eprintf__883_v0 "\\x1b[${cnt}A" array_130[@]
}

go_down__892_v0() {
    local cnt=$1
    array_131=("")
    eprintf__883_v0 "\\x1b[${cnt}B" array_131[@]
}

# move the cursor up or down `cnt` lines.
go_up_or_down__893_v0() {
    local cnt=$1
    if [ "$(( ${cnt} > 0 ))" != 0 ]; then
        go_down__892_v0 "${cnt}"
    else
        go_up__891_v0 "$(( - ${cnt} ))"
    fi
}

hide_cursor__894_v0() {
    array_132=("")
    eprintf__883_v0 "\\x1b[?25l" array_132[@]
}

show_cursor__895_v0() {
    array_133=("")
    eprintf__883_v0 "\\x1b[?25h" array_133[@]
}

# / Text Utilities /////
has_ansi_escape__896_v0() {
    local text=$1
    # Check for ESC character (0x1B = 27) or literal \x1b[
    command_134="$([[ "${text}" == *$'\x1b'* || "${text}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    has_escape_168="${command_134}"
    ret_has_ansi_escape896_v0="$([ "_${has_escape_168}" != "_1" ]; echo $?)"
    return 0
}

escape_ansi__897_v0() {
    local text=$1
    command_135="$(printf '%s' "${text}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi897_v0="${command_135}"
    return 0
}

strip_ansi__898_v0() {
    local text=$1
    command_136="$(printf "%s" "${text}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi898_v0="${command_136}"
    return 0
}

is_all_ascii__899_v0() {
    local text=$1
    command_137="$(printf "%s" "${text}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    result_185="${command_137}"
    ret_is_all_ascii899_v0="$([ "_${result_185}" != "_0" ]; echo $?)"
    return 0
}

get_visible_len__900_v0() {
    local text=$1
    strip_ansi__898_v0 "${text}"
    stripped_184="${ret_strip_ansi898_v0}"
    # Check if text is all ASCII
    is_all_ascii__899_v0 "${stripped_184}"
    ret_is_all_ascii899_v0__150_12="${ret_is_all_ascii899_v0}"
    if [ "$(( ! ${ret_is_all_ascii899_v0__150_12} ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__833_v0 "${stripped_184}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            __length_138="${stripped_184}"
            ret_get_visible_len900_v0="${#__length_138}"
            return 0
        fi
        ret_get_visible_len900_v0="${ret_perl_get_cjk_width833_v0}"
        return 0
    else
        __length_139="${stripped_184}"
        ret_get_visible_len900_v0="${#__length_139}"
        return 0
    fi
}

truncate_text__901_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__900_v0 "${text}"
    visible_len_189="${ret_get_visible_len900_v0}"
    if [ "$(( ${visible_len_189} <= ${max_width} ))" != 0 ]; then
        ret_truncate_text901_v0="${text}"
        return 0
    fi
    is_all_ascii__899_v0 "${text}"
    ret_is_all_ascii899_v0__167_12="${ret_is_all_ascii899_v0}"
    if [ "$(( ! ${ret_is_all_ascii899_v0__167_12} ))" != 0 ]; then
        perl_truncate_cjk__834_v0 "${text}" "${max_width}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text}" | cut -c1-${max_width}
            __status=$?
        fi
        ret_truncate_text901_v0="${ret_perl_truncate_cjk834_v0}"
        return 0
    fi
    command_140="$(printf "%s" "${text}" | cut -c1-${max_width})"
    __status=$?
    ret_truncate_text901_v0="${command_140}"
    return 0
}

truncate_ansi__902_v0() {
    local text=$1
    local max_width=$2
    has_ansi_escape__896_v0 "${text}"
    ret_has_ansi_escape896_v0__179_12="${ret_has_ansi_escape896_v0}"
    if [ "$(( ! ${ret_has_ansi_escape896_v0__179_12} ))" != 0 ]; then
        truncate_text__901_v0 "${text}" "${max_width}"
        ret_truncate_ansi902_v0="${ret_truncate_text901_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    command_141="$([[ "${text}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    starts_with_ansi_191="${command_141}"
    # Replace \x1b[ with newline, then split
    command_142="$(t="${text}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    replaced_192="${command_142}"
    split__5_v0 "${replaced_192}" "
"
    parts_193=("${ret_split5_v0[@]}")
    result_194=""
    remaining_width_195="${max_width}"
    from=0
    __length_143=("${parts_193[@]}")
    to="${#__length_143[@]}"
    for idx_196 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        part_197="${parts_193[${idx_196}]}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( ${idx_196} == 0 )) && $([ "_${starts_with_ansi_191}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_197}" == "_" ]; echo $?) && $(( ${remaining_width_195} > 0 )) ))" != 0 ]; then
                truncate_text__901_v0 "${part_197}" "${remaining_width_195}"
                truncated_198="${ret_truncate_text901_v0}"
                result_194+="${truncated_198}"
                get_visible_len__900_v0 "${truncated_198}"
                ret_get_visible_len900_v0__203_36="${ret_get_visible_len900_v0}"
                remaining_width_195="$(( ${remaining_width_195} - ${ret_get_visible_len900_v0__203_36} ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            command_144="$(__p="${part_197}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            m_idx_199="${command_144}"
            if [ "$([ "_${m_idx_199}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                command_145="$(__p="${part_197}"; printf "%s" "${__p:0:${m_idx_199}}")"
                __status=$?
                ansi_params_200="${command_145}"
                result_194+="\\x1b[""${ansi_params_200}""m"
                # Rest is text content
                parse_int__14_v0 "${m_idx_199}"
                __status=$?
                m_idx_num_201="${ret_parse_int14_v0}"
                text_start_202="$(( ${m_idx_num_201} + 1 ))"
                command_146="$(__p="${part_197}"; printf "%s" "${__p:${text_start_202}}")"
                __status=$?
                text_part_203="${command_146}"
                if [ "$(( $([ "_${text_part_203}" == "_" ]; echo $?) && $(( ${remaining_width_195} > 0 )) ))" != 0 ]; then
                    truncate_text__901_v0 "${text_part_203}" "${remaining_width_195}"
                    truncated_204="${ret_truncate_text901_v0}"
                    result_194+="${truncated_204}"
                    get_visible_len__900_v0 "${truncated_204}"
                    ret_get_visible_len900_v0__220_40="${ret_get_visible_len900_v0}"
                    remaining_width_195="$(( ${remaining_width_195} - ${ret_get_visible_len900_v0__220_40} ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_197}" == "_" ]; echo $?) && $(( ${remaining_width_195} > 0 )) ))" != 0 ]; then
                    truncate_text__901_v0 "${part_197}" "${remaining_width_195}"
                    truncated_205="${ret_truncate_text901_v0}"
                    result_194+="${truncated_205}"
                    get_visible_len__900_v0 "${truncated_205}"
                    remaining_width_195="$(( ${remaining_width_195} - ${ret_get_visible_len900_v0__227_40} ))"
                fi
            fi
        fi
    done
    ret_truncate_ansi902_v0="${result_194}"
    return 0
}

cutoff_text__903_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__900_v0 "${text}"
    visible_len_188="${ret_get_visible_len900_v0}"
    if [ "$(( ${visible_len_188} <= ${max_width} ))" != 0 ]; then
        ret_cutoff_text903_v0="${text}"
        return 0
    fi
    truncate_ansi__902_v0 "${text}" "$(( ${max_width} - 3 ))"
    ret_truncate_ansi902_v0__243_12="${ret_truncate_ansi902_v0}"
    ret_cutoff_text903_v0="${ret_truncate_ansi902_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
render_tooltip__904_v0() {
    local items=("${!1}")
    local total_len=$2
    local term_width=$3
    separator_211=" • "
    separator_len_212=3
    # Fast path: no truncation needed
    if [ "$(( ${total_len} <= ${term_width} ))" != 0 ]; then
        iter_213=0
        while :
        do
            __length_147=("${items[@]}")
            if [ "$(( ${iter_213} >= ${#__length_147[@]} ))" != 0 ]; then
                break
            elif [ "$(( ${iter_213} > 0 ))" != 0 ]; then
                eprintf_colored__884_v0 "${separator_211}" 90
            fi
            colored__885_v0 "${items[$(( ${iter_213} + 1 ))]}" 2
            ret_colored885_v0__268_41="${ret_colored885_v0}"
            array_148=("")
            eprintf__883_v0 "${items[${iter_213}]}"" ""${ret_colored885_v0__268_41}" array_148[@]
            iter_213="$(( ${iter_213} + 2 ))"
        done
    else
        # Slow path: truncate
        current_len_214=0
        first_215=1
        iter_216=0
        while :
        do
            __length_149=("${items[@]}")
            if [ "$(( ${iter_216} >= ${#__length_149[@]} ))" != 0 ]; then
                break
            fi
            key_217="${items[${iter_216}]}"
            action_218="${items[$(( ${iter_216} + 1 ))]}"
            __length_150="${key_217}"
            __length_151="${action_218}"
            part_len_219="$(( $(( ${#__length_150} + 1 )) + ${#__length_151} ))"
            needed_220="${part_len_219}"
            if [ "$(( ! ${first_215} ))" != 0 ]; then
                needed_220="$(( ${needed_220} + ${separator_len_212} ))"
            fi
            if [ "$(( $(( ${current_len_214} + ${needed_220} )) > ${term_width} ))" != 0 ]; then
                break
            fi
            if [ "$(( ! ${first_215} ))" != 0 ]; then
                eprintf_colored__884_v0 "${separator_211}" 90
            fi
            colored__885_v0 "${action_218}" 2
            ret_colored885_v0__296_33="${ret_colored885_v0}"
            array_152=("")
            eprintf__883_v0 "${key_217}"" ""${ret_colored885_v0__296_33}" array_152[@]
            current_len_214="$(( ${current_len_214} + ${needed_220} ))"
            first_215=0
            iter_216="$(( ${iter_216} + 2 ))"
        done
    fi
}

get_page_options__954_v0() {
    local options=("${!1}")
    local page=$2
    local page_size=$3
    start_223="$(( ${page} * ${page_size} ))"
    end_224="$(( ${start_223} + ${page_size} ))"
    __length_153=("${options[@]}")
    if [ "$(( ${end_224} > ${#__length_153[@]} ))" != 0 ]; then
        __length_154=("${options[@]}")
        end_224="${#__length_154[@]}"
    fi
    result_225=()
    from="${start_223}"
    to="${end_224}"
    for i_226 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        result_225+=("${options[${i_226}]}")
    done
    ret_get_page_options954_v0=("${result_225[@]}")
    return 0
}

get_page_start__955_v0() {
    local page=$1
    local page_size=$2
    ret_get_page_start955_v0="$(( ${page} * ${page_size} ))"
    return 0
}

render_choose_page__956_v0() {
    local page_options=("${!1}")
    local sel=$2
    local cursor=$3
    local display_count=$4
    local term_width=$5
    __length_157="${cursor}"
    cursor_len_271="${#__length_157}"
    max_option_width_272="$(( $(( ${term_width} - ${cursor_len_271} )) - 1 ))"
    from=0
    __length_158=("${page_options[@]}")
    to="${#__length_158[@]}"
    for i_273 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        cutoff_text__903_v0 "${page_options[${i_273}]}" "${max_option_width_272}"
        truncated_option_274="${ret_cutoff_text903_v0}"
        if [ "$(( ${i_273} == ${sel} ))" != 0 ]; then
            colored_secondary__866_v0 "${cursor}""${truncated_option_274}""
"
            ret_colored_secondary866_v0__28_21="${ret_colored_secondary866_v0}"
            array_159=("")
            eprintf__883_v0 "${ret_colored_secondary866_v0__28_21}" array_159[@]
        else
            print_blank__889_v0 "${cursor_len_271}"
            array_160=("")
            eprintf__883_v0 "${truncated_option_274}""
" array_160[@]
        fi
    done
    __length_161=("${page_options[@]}")
    remaining_slots_275="$(( ${display_count} - ${#__length_161[@]} ))"
    if [ "$(( ${remaining_slots_275} > 0 ))" != 0 ]; then
        # Amber bug gaurd
        from=0
        to="${remaining_slots_275}"
        for ____276 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
            array_162=("")
            eprintf__883_v0 "\\x1b[K
" array_162[@]
        done
    fi
}

render_multi_choose_page__957_v0() {
    local page_options=("${!1}")
    local checked=("${!2}")
    local page_start=$3
    local sel=$4
    local cursor=$5
    local display_count=$6
    local term_width=$7
    __length_163="${cursor}"
    cursor_len_229="${#__length_163}"
    check_mark_len_230=2
    # "✓ " or "• "
    max_option_width_231="$(( $(( $(( ${term_width} - ${cursor_len_229} )) - ${check_mark_len_230} )) - 1 ))"
    from=0
    __length_164=("${page_options[@]}")
    to="${#__length_164[@]}"
    for i_232 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        global_idx_233="$(( ${page_start} + ${i_232} ))"
        check_mark_234="$(if [ "${checked[${global_idx_233}]}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__903_v0 "${page_options[${i_232}]}" "${max_option_width_231}"
        truncated_option_235="${ret_cutoff_text903_v0}"
        if [ "$(( ${i_232} == ${sel} ))" != 0 ]; then
            colored_secondary__866_v0 "${cursor}""${check_mark_234}""${truncated_option_235}""
"
            ret_colored_secondary866_v0__51_31="${ret_colored_secondary866_v0}"
            array_165=("")
            eprintf__883_v0 "${ret_colored_secondary866_v0__51_31}" array_165[@]
        elif [ "${checked[${global_idx_233}]}" != 0 ]; then
            print_blank__889_v0 "${cursor_len_229}"
            colored_secondary__866_v0 "${check_mark_234}""${truncated_option_235}""
"
            ret_colored_secondary866_v0__54_25="${ret_colored_secondary866_v0}"
            array_166=("")
            eprintf__883_v0 "${ret_colored_secondary866_v0__54_25}" array_166[@]
        else
            print_blank__889_v0 "${cursor_len_229}"
            array_167=("")
            eprintf__883_v0 "${check_mark_234}""${truncated_option_235}""
" array_167[@]
        fi
    done
    __length_168=("${page_options[@]}")
    remaining_slots_236="$(( ${display_count} - ${#__length_168[@]} ))"
    if [ "$(( ${remaining_slots_236} > 0 ))" != 0 ]; then
        # Amber bug guard
        from=0
        to="${remaining_slots_236}"
        for ____237 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
            array_169=("")
            eprintf__883_v0 "\\x1b[K
" array_169[@]
        done
    fi
}

render_page_indicator__958_v0() {
    local page=$1
    local total_pages=$2
    if [ "$(( ${total_pages} > 1 ))" != 0 ]; then
        array_170=("")
        eprintf__883_v0 "\\x1b[9999D\\x1b[K" array_170[@]
        eprintf_colored__884_v0 "Page $(( ${page} + 1 ))/${total_pages}" 90
        array_171=("")
        eprintf__883_v0 "\\x1b[9999D" array_171[@]
    fi
}

xyl_choose__959_v0() {
    local options=("${!1}")
    local cursor=$2
    local header=$3
    local page_size=$4
    __length_172=("${options[@]}")
    if [ "$(( ${#__length_172[@]} == 0 ))" != 0 ]; then
        eprintf_colored__884_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    stty_lock__842_v0 
    hide_cursor__894_v0 
    term_width__849_v0 
    term_width_263="${ret_term_width849_v0}"
    term_height__850_v0 
    term_height_264="${ret_term_height850_v0}"
    max_page_size_265="$(( ${term_height_264} - $(if [ "$([ "_${header}" != "_" ]; echo $?)" != 0 ]; then echo 2; else echo 3; fi) ))"
    if [ "$(( ${page_size} > ${max_page_size_265} ))" != 0 ]; then
        page_size="${max_page_size_265}"
    fi
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__903_v0 "${header}" "${term_width_263}"
        ret_cutoff_text903_v0__107_17="${ret_cutoff_text903_v0}"
        array_173=("")
        eprintf__883_v0 "${ret_cutoff_text903_v0__107_17}""
" array_173[@]
    fi
    __length_174=("${options[@]}")
    math_floor__420_v0 "$(( $(( $(( ${#__length_174[@]} + ${page_size} )) - 1 )) / ${page_size} ))"
    total_pages_266="${ret_math_floor420_v0}"
    current_page_267=0
    selected_268=0
    display_count_269="${page_size}"
    __length_175=("${options[@]}")
    if [ "$(( ${#__length_175[@]} < ${page_size} ))" != 0 ]; then
        __length_176=("${options[@]}")
        display_count_269="${#__length_176[@]}"
    fi
    new_line__890_v0 "${display_count_269}"
    array_177=("")
    eprintf__883_v0 "\\x1b[9999D" array_177[@]
    if [ "$(( ${total_pages_266} > 1 ))" != 0 ]; then
        eprintf_colored__884_v0 "Page $(( ${current_page_267} + 1 ))/${total_pages_266}" 90
    fi
    new_line__890_v0 1
    # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
    # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    if [ "$(( ${total_pages_266} > 1 ))" != 0 ]; then
        array_178=("↑↓" "select" "←→" "page" "enter" "confirm")
        render_tooltip__904_v0 array_178[@] 36 "${term_width_263}"
    else
        array_179=("↑↓" "select" "enter" "confirm")
        render_tooltip__904_v0 array_179[@] 25 "${term_width_263}"
    fi
    go_up__891_v0 "$(( ${display_count_269} + 1 ))"
    array_180=("")
    eprintf__883_v0 "\\x1b[9999D" array_180[@]
    get_page_options__954_v0 options[@] "${current_page_267}" "${page_size}"
    page_options_270=("${ret_get_page_options954_v0[@]}")
    render_choose_page__956_v0 page_options_270[@] "${selected_268}" "${cursor}" "${display_count_269}" "${term_width_263}"
    while :
    do
        get_key__881_v0 
        key_277="${ret_get_key881_v0}"
        prev_selected_278="${selected_268}"
        prev_page_279="${current_page_267}"
        up_paged_280=0
        if [ "$(( $([ "_${key_277}" != "_UP" ]; echo $?) || $([ "_${key_277}" != "_k" ]; echo $?) ))" != 0 ]; then
            if [ "$(( $(( ${selected_268} == 0 )) && $(( ${total_pages_266} > 1 )) ))" != 0 ]; then
                if [ "$(( ${current_page_267} > 0 ))" != 0 ]; then
                    current_page_267="$(( ${current_page_267} - 1 ))"
                else
                    current_page_267="$(( ${total_pages_266} - 1 ))"
                fi
                up_paged_280=1
            elif [ "$(( ${selected_268} == 0 ))" != 0 ]; then
                __length_181=("${page_options_270[@]}")
                selected_268="$(( ${#__length_181[@]} - 1 ))"
            else
                selected_268="$(( ${selected_268} - 1 ))"
            fi
        elif [ "$(( $([ "_${key_277}" != "_DOWN" ]; echo $?) || $([ "_${key_277}" != "_j" ]; echo $?) ))" != 0 ]; then
            __length_182=("${page_options_270[@]}")
            if [ "$(( ${selected_268} == $(( ${#__length_182[@]} - 1 )) ))" != 0 ]; then
                if [ "$(( ${current_page_267} < $(( ${total_pages_266} - 1 )) ))" != 0 ]; then
                    current_page_267="$(( ${current_page_267} + 1 ))"
                    selected_268=0
                else
                    current_page_267=0
                    selected_268=0
                fi
            else
                selected_268="$(( ${selected_268} + 1 ))"
            fi
        elif [ "$(( $([ "_${key_277}" != "_LEFT" ]; echo $?) || $([ "_${key_277}" != "_h" ]; echo $?) ))" != 0 ]; then
            if [ "$(( ${current_page_267} > 0 ))" != 0 ]; then
                current_page_267="$(( ${current_page_267} - 1 ))"
                selected_268=0
            else
                selected_268=0
            fi
        elif [ "$(( $([ "_${key_277}" != "_RIGHT" ]; echo $?) || $([ "_${key_277}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "$(( ${current_page_267} < $(( ${total_pages_266} - 1 )) ))" != 0 ]; then
                current_page_267="$(( ${current_page_267} + 1 ))"
                selected_268=0
            else
                __length_183=("${page_options_270[@]}")
                selected_268="$(( ${#__length_183[@]} - 1 ))"
            fi
        elif [ "$([ "_${key_277}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
        __length_184="${cursor}"
        max_option_width_281="$(( $(( ${term_width_263} - ${#__length_184} )) - 1 ))"
        if [ "$(( ${prev_page_279} != ${current_page_267} ))" != 0 ]; then
            get_page_options__954_v0 options[@] "${current_page_267}" "${page_size}"
            page_options_270=("${ret_get_page_options954_v0[@]}")
            if [ "${up_paged_280}" != 0 ]; then
                __length_185=("${page_options_270[@]}")
                selected_268="$(( ${#__length_185[@]} - 1 ))"
            fi
            go_up__891_v0 1
            remove_line__887_v0 "$(( ${display_count_269} - 1 ))"
            remove_current_line__888_v0 
            array_186=("")
            eprintf__883_v0 "\\x1b[9999D" array_186[@]
            render_choose_page__956_v0 page_options_270[@] "${selected_268}" "${cursor}" "${display_count_269}" "${term_width_263}"
            render_page_indicator__958_v0 "${current_page_267}" "${total_pages_266}"
        elif [ "$(( ${prev_selected_278} != ${selected_268} ))" != 0 ]; then
            go_up__891_v0 "$(( ${display_count_269} - ${prev_selected_278} ))"
            array_187=("")
            eprintf__883_v0 "\\x1b[K" array_187[@]
            __length_188="${cursor}"
            print_blank__889_v0 "${#__length_188}"
            cutoff_text__903_v0 "${page_options_270[${prev_selected_278}]}" "${max_option_width_281}"
            ret_cutoff_text903_v0__218_25="${ret_cutoff_text903_v0}"
            array_189=("")
            eprintf__883_v0 "${ret_cutoff_text903_v0__218_25}" array_189[@]
            diff_282="$(( ${selected_268} - ${prev_selected_278} ))"
            go_up_or_down__893_v0 "${diff_282}"
            array_190=("")
            eprintf__883_v0 "\\x1b[9999D" array_190[@]
            array_191=("")
            eprintf__883_v0 "\\x1b[K" array_191[@]
            cutoff_text__903_v0 "${page_options_270[${selected_268}]}" "${max_option_width_281}"
            ret_cutoff_text903_v0__224_52="${ret_cutoff_text903_v0}"
            colored_secondary__866_v0 "${cursor}""${ret_cutoff_text903_v0__224_52}"
            ret_colored_secondary866_v0__224_25="${ret_colored_secondary866_v0}"
            array_192=("")
            eprintf__883_v0 "${ret_colored_secondary866_v0__224_25}" array_192[@]
            go_down__892_v0 "$(( ${display_count_269} - ${selected_268} ))"
            array_193=("")
            eprintf__883_v0 "\\x1b[9999D" array_193[@]
        fi
    done
    total_lines_283="$(( ${display_count_269} + 2 ))"
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_283="$(( ${total_lines_283} + 1 ))"
    fi
    go_down__892_v0 1
    remove_line__887_v0 "$(( ${total_lines_283} - 1 ))"
    remove_current_line__888_v0 
    stty_unlock__843_v0 
    show_cursor__895_v0 
    global_selected_284="$(( $(( ${current_page_267} * ${page_size} )) + ${selected_268} ))"
    ret_xyl_choose959_v0="${options[${global_selected_284}]}"
    return 0
}

count_checked__960_v0() {
    local checked=("${!1}")
    count_244=0
    for c_245 in "${checked[@]}"; do
        if [ "${c_245}" != 0 ]; then
            count_244="$(( ${count_244} + 1 ))"
        fi
    done
    ret_count_checked960_v0="${count_244}"
    return 0
}

xyl_multi_choose__961_v0() {
    local options=("${!1}")
    local cursor=$2
    local header=$3
    local limit=$4
    local page_size=$5
    __length_194=("${options[@]}")
    if [ "$(( ${#__length_194[@]} == 0 ))" != 0 ]; then
        eprintf_colored__884_v0 "ERROR: No options provided.
" 31
        ret_xyl_multi_choose961_v0=()
        return 0
    fi
    stty_lock__842_v0 
    hide_cursor__894_v0 
    term_width__849_v0 
    term_width_181="${ret_term_width849_v0}"
    term_height__850_v0 
    term_height_182="${ret_term_height850_v0}"
    max_page_size_183="$(( ${term_height_182} - $(if [ "$([ "_${header}" != "_" ]; echo $?)" != 0 ]; then echo 2; else echo 3; fi) ))"
    if [ "$(( ${page_size} > ${max_page_size_183} ))" != 0 ]; then
        page_size="${max_page_size_183}"
    fi
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__903_v0 "${header}" "${term_width_181}"
        ret_cutoff_text903_v0__288_17="${ret_cutoff_text903_v0}"
        array_196=("")
        eprintf__883_v0 "${ret_cutoff_text903_v0__288_17}""
" array_196[@]
    fi
    __length_197=("${options[@]}")
    math_floor__420_v0 "$(( $(( $(( ${#__length_197[@]} + ${page_size} )) - 1 )) / ${page_size} ))"
    total_pages_206="${ret_math_floor420_v0}"
    current_page_207=0
    selected_208=0
    display_count_209="${page_size}"
    __length_198=("${options[@]}")
    if [ "$(( ${#__length_198[@]} < ${page_size} ))" != 0 ]; then
        __length_199=("${options[@]}")
        display_count_209="${#__length_199[@]}"
    fi
    new_line__890_v0 "${display_count_209}"
    array_200=("")
    eprintf__883_v0 "\\x1b[9999D" array_200[@]
    if [ "$(( ${total_pages_206} > 1 ))" != 0 ]; then
        eprintf_colored__884_v0 "Page $(( ${current_page_207} + 1 ))/${total_pages_206}" 90
    fi
    new_line__890_v0 1
    # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
    # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
    # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
    if [ "$(( $(( ${total_pages_206} > 1 )) && $(( ${limit} < 0 )) ))" != 0 ]; then
        array_201=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
        render_tooltip__904_v0 array_201[@] 55 "${term_width_181}"
    elif [ "$(( ${total_pages_206} > 1 ))" != 0 ]; then
        array_202=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
        render_tooltip__904_v0 array_202[@] 47 "${term_width_181}"
    elif [ "$(( ${limit} < 0 ))" != 0 ]; then
        array_203=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
        render_tooltip__904_v0 array_203[@] 44 "${term_width_181}"
    else
        array_204=("↑↓" "select" "x" "toggle" "enter" "confirm")
        render_tooltip__904_v0 array_204[@] 36 "${term_width_181}"
    fi
    go_up__891_v0 "$(( ${display_count_209} + 1 ))"
    array_205=("")
    eprintf__883_v0 "\\x1b[9999D" array_205[@]
    checked_221=()
    from=0
    __length_207=("${options[@]}")
    to="${#__length_207[@]}"
    for ____222 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        checked_221+=(0)
    done
    get_page_options__954_v0 options[@] "${current_page_207}" "${page_size}"
    page_options_227=("${ret_get_page_options954_v0[@]}")
    get_page_start__955_v0 "${current_page_207}" "${page_size}"
    page_start_228="${ret_get_page_start955_v0}"
    render_multi_choose_page__957_v0 page_options_227[@] checked_221[@] "${page_start_228}" "${selected_208}" "${cursor}" "${display_count_209}" "${term_width_181}"
    while :
    do
        get_key__881_v0 
        key_239="${ret_get_key881_v0}"
        prev_selected_240="${selected_208}"
        prev_page_241="${current_page_207}"
        global_selected_242="$(( ${page_start_228} + ${selected_208} ))"
        up_paged_243=0
        if [ "$(( $([ "_${key_239}" != "_UP" ]; echo $?) || $([ "_${key_239}" != "_k" ]; echo $?) ))" != 0 ]; then
            if [ "$(( $(( ${selected_208} == 0 )) && $(( ${total_pages_206} > 1 )) ))" != 0 ]; then
                if [ "$(( ${current_page_207} > 0 ))" != 0 ]; then
                    current_page_207="$(( ${current_page_207} - 1 ))"
                else
                    current_page_207="$(( ${total_pages_206} - 1 ))"
                fi
                up_paged_243=1
            elif [ "$(( ${selected_208} == 0 ))" != 0 ]; then
                __length_209=("${page_options_227[@]}")
                selected_208="$(( ${#__length_209[@]} - 1 ))"
            else
                selected_208="$(( ${selected_208} - 1 ))"
            fi
        elif [ "$(( $([ "_${key_239}" != "_DOWN" ]; echo $?) || $([ "_${key_239}" != "_j" ]; echo $?) ))" != 0 ]; then
            __length_210=("${page_options_227[@]}")
            if [ "$(( ${selected_208} == $(( ${#__length_210[@]} - 1 )) ))" != 0 ]; then
                if [ "$(( ${current_page_207} < $(( ${total_pages_206} - 1 )) ))" != 0 ]; then
                    current_page_207="$(( ${current_page_207} + 1 ))"
                    selected_208=0
                else
                    current_page_207=0
                    selected_208=0
                fi
            else
                selected_208="$(( ${selected_208} + 1 ))"
            fi
        elif [ "$(( $([ "_${key_239}" != "_LEFT" ]; echo $?) || $([ "_${key_239}" != "_h" ]; echo $?) ))" != 0 ]; then
            if [ "$(( ${current_page_207} > 0 ))" != 0 ]; then
                current_page_207="$(( ${current_page_207} - 1 ))"
                selected_208=0
            else
                selected_208=0
            fi
        elif [ "$(( $([ "_${key_239}" != "_RIGHT" ]; echo $?) || $([ "_${key_239}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "$(( ${current_page_207} < $(( ${total_pages_206} - 1 )) ))" != 0 ]; then
                current_page_207="$(( ${current_page_207} + 1 ))"
                selected_208=0
            else
                __length_211=("${page_options_227[@]}")
                selected_208="$(( ${#__length_211[@]} - 1 ))"
            fi
        elif [ "$(( $([ "_${key_239}" != "_x" ]; echo $?) || $([ "_${key_239}" != "_X" ]; echo $?) ))" != 0 ]; then
            count_checked__960_v0 checked_221[@]
            ret_count_checked960_v0__390_34="${ret_count_checked960_v0}"
            if [ "${checked_221[${global_selected_242}]}" != 0 ]; then
                checked_221["${global_selected_242}"]=0
            elif [ "$(( $(( ${limit} < 0 )) || $(( ${ret_count_checked960_v0__390_34} < ${limit} )) ))" != 0 ]; then
                checked_221["${global_selected_242}"]=1
            else
                continue
            fi
            __length_212="${cursor}"
            max_option_width_246="$(( $(( $(( ${term_width_181} - ${#__length_212} )) - 2 )) - 1 ))"
            # 2 for check mark
            go_up__891_v0 "$(( ${display_count_209} - ${selected_208} ))"
            array_213=("")
            eprintf__883_v0 "\\x1b[9999D" array_213[@]
            array_214=("")
            eprintf__883_v0 "\\x1b[K" array_214[@]
            check_mark_247="$(if [ "${checked_221[${global_selected_242}]}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
            cutoff_text__903_v0 "${page_options_227[${selected_208}]}" "${max_option_width_246}"
            ret_cutoff_text903_v0__400_65="${ret_cutoff_text903_v0}"
            colored_secondary__866_v0 "${cursor}""${check_mark_247}""${ret_cutoff_text903_v0__400_65}"
            ret_colored_secondary866_v0__400_25="${ret_colored_secondary866_v0}"
            array_215=("")
            eprintf__883_v0 "${ret_colored_secondary866_v0__400_25}" array_215[@]
            go_down__892_v0 "$(( ${display_count_209} - ${selected_208} ))"
            array_216=("")
            eprintf__883_v0 "\\x1b[9999D" array_216[@]
            continue
        elif [ "$(( $(( $([ "_${key_239}" != "_a" ]; echo $?) || $([ "_${key_239}" != "_A" ]; echo $?) )) && $(( ${limit} < 0 )) ))" != 0 ]; then
            count_checked__960_v0 checked_221[@]
            ret_count_checked960_v0__406_35="${ret_count_checked960_v0}"
            __length_217=("${options[@]}")
            all_checked_248="$(( ${ret_count_checked960_v0__406_35} == ${#__length_217[@]} ))"
            from=0
            __length_218=("${checked_221[@]}")
            to="${#__length_218[@]}"
            for i_249 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
                checked_221["${i_249}"]="$(( ! ${all_checked_248} ))"
            done
            go_up__891_v0 "${display_count_209}"
            array_219=("")
            eprintf__883_v0 "\\x1b[9999D" array_219[@]
            render_multi_choose_page__957_v0 page_options_227[@] checked_221[@] "${page_start_228}" "${selected_208}" "${cursor}" "${display_count_209}" "${term_width_181}"
            continue
        elif [ "$([ "_${key_239}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
        __length_220="${cursor}"
        max_option_width_250="$(( $(( $(( ${term_width_181} - ${#__length_220} )) - 2 )) - 1 ))"
        # 2 for check mark
        if [ "$(( ${prev_page_241} != ${current_page_207} ))" != 0 ]; then
            get_page_options__954_v0 options[@] "${current_page_207}" "${page_size}"
            page_options_227=("${ret_get_page_options954_v0[@]}")
            get_page_start__955_v0 "${current_page_207}" "${page_size}"
            page_start_228="${ret_get_page_start955_v0}"
            if [ "${up_paged_243}" != 0 ]; then
                __length_221=("${page_options_227[@]}")
                selected_208="$(( ${#__length_221[@]} - 1 ))"
            fi
            go_up__891_v0 1
            remove_line__887_v0 "$(( ${display_count_209} - 1 ))"
            remove_current_line__888_v0 
            array_222=("")
            eprintf__883_v0 "\\x1b[9999D" array_222[@]
            render_multi_choose_page__957_v0 page_options_227[@] checked_221[@] "${page_start_228}" "${selected_208}" "${cursor}" "${display_count_209}" "${term_width_181}"
            render_page_indicator__958_v0 "${current_page_207}" "${total_pages_206}"
        elif [ "$(( ${prev_selected_240} != ${selected_208} ))" != 0 ]; then
            prev_global_253="$(( ${page_start_228} + ${prev_selected_240} ))"
            go_up__891_v0 "$(( ${display_count_209} - ${prev_selected_240} ))"
            array_223=("")
            eprintf__883_v0 "\\x1b[K" array_223[@]
            __length_224="${cursor}"
            print_blank__889_v0 "${#__length_224}"
            if [ "${checked_221[${prev_global_253}]}" != 0 ]; then
                cutoff_text__903_v0 "${page_options_227[${prev_selected_240}]}" "${max_option_width_250}"
                ret_cutoff_text903_v0__442_54="${ret_cutoff_text903_v0}"
                colored_secondary__866_v0 "✓ ""${ret_cutoff_text903_v0__442_54}"
                ret_colored_secondary866_v0__442_29="${ret_colored_secondary866_v0}"
                array_225=("")
                eprintf__883_v0 "${ret_colored_secondary866_v0__442_29}" array_225[@]
            else
                cutoff_text__903_v0 "${page_options_227[${prev_selected_240}]}" "${max_option_width_250}"
                ret_cutoff_text903_v0__444_36="${ret_cutoff_text903_v0}"
                array_226=("")
                eprintf__883_v0 "• ""${ret_cutoff_text903_v0__444_36}" array_226[@]
            fi
            diff_254="$(( ${selected_208} - ${prev_selected_240} ))"
            go_up_or_down__893_v0 "${diff_254}"
            array_227=("")
            eprintf__883_v0 "\\x1b[9999D" array_227[@]
            array_228=("")
            eprintf__883_v0 "\\x1b[K" array_228[@]
            new_global_255="$(( ${page_start_228} + ${selected_208} ))"
            check_mark_256="$(if [ "${checked_221[${new_global_255}]}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
            cutoff_text__903_v0 "${page_options_227[${selected_208}]}" "${max_option_width_250}"
            ret_cutoff_text903_v0__453_65="${ret_cutoff_text903_v0}"
            colored_secondary__866_v0 "${cursor}""${check_mark_256}""${ret_cutoff_text903_v0__453_65}"
            ret_colored_secondary866_v0__453_25="${ret_colored_secondary866_v0}"
            array_229=("")
            eprintf__883_v0 "${ret_colored_secondary866_v0__453_25}" array_229[@]
            go_down__892_v0 "$(( ${display_count_209} - ${selected_208} ))"
            array_230=("")
            eprintf__883_v0 "\\x1b[9999D" array_230[@]
        fi
    done
    total_lines_257="$(( ${display_count_209} + 2 ))"
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_257="$(( ${total_lines_257} + 1 ))"
    fi
    go_down__892_v0 1
    remove_line__887_v0 "$(( ${total_lines_257} - 1 ))"
    remove_current_line__888_v0 
    result_258=()
    from=0
    __length_232=("${options[@]}")
    to="${#__length_232[@]}"
    for i_259 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        if [ "${checked_221[${i_259}]}" != 0 ]; then
            result_258+=("${options[${i_259}]}")
        fi
    done
    stty_unlock__843_v0 
    show_cursor__895_v0 
    ret_xyl_multi_choose961_v0=("${result_258[@]}")
    return 0
}

print_choose_help__1038_v0() {
    echo "Usage: ./xylitol.sh choose [<options> ...] [flags]"
    echo ""
    colored_primary__865_v0 "choose"
    ret_colored_primary865_v0__7_12="${ret_colored_primary865_v0}"
    array_234=("")
    printf__106_v0 "${ret_colored_primary865_v0__7_12}" array_234[@]
    array_235=("")
    printf__106_v0 " - Choose from a list of options." array_235[@]
    echo ""
    echo ""
    colored_secondary__866_v0 "Arguments: "
    ret_colored_secondary866_v0__11_12="${ret_colored_secondary866_v0}"
    array_236=("")
    printf__106_v0 "${ret_colored_secondary866_v0__11_12}""
" array_236[@]
    echo "  [<options> ...]        List of options to choose from"
    echo ""
    colored_secondary__866_v0 "Flags: "
    ret_colored_secondary866_v0__14_12="${ret_colored_secondary866_v0}"
    array_237=("")
    printf__106_v0 "${ret_colored_secondary866_v0__14_12}""
" array_237[@]
    echo "  -h, --help             Show this help message"
    echo "  --limit=<number>       Enable multi-selection mode with a limit of selections"
    echo "  --no-limit             Enable multi-selection mode with no limit"
    echo "  --cursor=\"<text>\"      Set the cursor text (default: '> ')"
    echo "  --header=\"<text>\"      Set a header text to display above the options (ANSI escape supported)"
    echo "  --page-size=<number>   Set the number of options per page (default: 10)"
    echo ""
}

read_stdin_options__1089_v0() {
    options_157=()
    command_239="$([ -t 0 ] && echo "true" || echo "false")"
    __status=$?
    is_tty_158="${command_239}"
    if [ "$([ "_${is_tty_158}" != "_false" ]; echo $?)" != 0 ]; then
        while IFS= read -r line || [[ -n "$line" ]]; do options_157+=("$line"); done
        __status=$?
    fi
    ret_read_stdin_options1089_v0=("${options_157[@]}")
    return 0
}

execute_choose__1090_v0() {
    local parameters=("${!1}")
    cursor_147="> "
    colored_primary__865_v0 "Choose: "
    ret_colored_primary865_v0__17_30="${ret_colored_primary865_v0}"
    header_156="\\x1b[1m""${ret_colored_primary865_v0__17_30}"
    read_stdin_options__1089_v0 
    options_159=("${ret_read_stdin_options1089_v0[@]}")
    multi_160=0
    limit_161=-1
    page_size_162=10
    for param_163 in "${parameters[@]:2:9997}"; do
        match_regex__20_v0 "${param_163}" "^-h\$" 0
        ret_match_regex20_v0__25_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_163}" "^--help\$" 0
        ret_match_regex20_v0__25_43="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_163}" "^--cursor=.*\$" 0
        ret_match_regex20_v0__29_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_163}" "^--header=.*\$" 0
        ret_match_regex20_v0__33_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_163}" "^--limit=.*\$" 0
        ret_match_regex20_v0__37_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_163}" "^--no-limit\$" 0
        ret_match_regex20_v0__45_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_163}" "^--page-size=.*\$" 0
        ret_match_regex20_v0__48_13="${ret_match_regex20_v0}"
        if [ "$(( ${ret_match_regex20_v0__25_13} || ${ret_match_regex20_v0__25_43} ))" != 0 ]; then
            print_choose_help__1038_v0 
            exit 0
        elif [ "${ret_match_regex20_v0__29_13}" != 0 ]; then
            split__5_v0 "${param_163}" "="
            result_164=("${ret_split5_v0[@]}")
            cursor_147="${result_164[1]}"
        elif [ "${ret_match_regex20_v0__33_13}" != 0 ]; then
            split__5_v0 "${param_163}" "="
            result_165=("${ret_split5_v0[@]}")
            header_156="${result_165[1]}"
        elif [ "${ret_match_regex20_v0__37_13}" != 0 ]; then
            split__5_v0 "${param_163}" "="
            result_166=("${ret_split5_v0[@]}")
            parse_int__14_v0 "${result_166[1]}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__884_v0 "ERROR: Invalid limit value: ""${result_166[1]}""
" 31
                exit 1
            fi
            limit_161="${ret_parse_int14_v0}"
            multi_160=1
        elif [ "${ret_match_regex20_v0__45_13}" != 0 ]; then
            multi_160=1
        elif [ "${ret_match_regex20_v0__48_13}" != 0 ]; then
            split__5_v0 "${param_163}" "="
            result_167=("${ret_split5_v0[@]}")
            parse_int__14_v0 "${result_167[1]}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__884_v0 "ERROR: Invalid page-size value: ""${result_167[1]}""
" 31
                exit 1
            fi
            page_size_162="${ret_parse_int14_v0}"
        else
            options_159+=("${param_163}")
        fi
    done
    has_ansi_escape__896_v0 "${header_156}"
    ret_has_ansi_escape896_v0__61_42="${ret_has_ansi_escape896_v0}"
    escape_ansi__897_v0 "${header_156}"
    ret_escape_ansi897_v0__61_71="${ret_escape_ansi897_v0}"
    colored_primary__865_v0 "${header_156}"
    ret_colored_primary865_v0__61_109="${ret_colored_primary865_v0}"
    display_header_169="$(if [ "$(( $([ "_${header_156}" != "_" ]; echo $?) || ${ret_has_ansi_escape896_v0__61_42} ))" != 0 ]; then echo "${ret_escape_ansi897_v0__61_71}"; else echo "\\x1b[1m""${ret_colored_primary865_v0__61_109}"; fi)"
    if [ "${multi_160}" != 0 ]; then
        xyl_multi_choose__961_v0 options_159[@] "${cursor_147}" "${display_header_169}" "${limit_161}" "${page_size_162}"
        results_262=("${ret_xyl_multi_choose961_v0[@]}")
        join__8_v0 results_262[@] "
"
        ret_execute_choose1090_v0="${ret_join8_v0}"
        return 0
    fi
    xyl_choose__959_v0 options_159[@] "${cursor_147}" "${display_header_169}" "${page_size_162}"
    ret_execute_choose1090_v0="${ret_xyl_choose959_v0}"
    return 0
}

# Perl Extensions Utilities
command_241="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_30="$([ "_${command_241}" != "_No" ]; echo $?)"
command_242="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_31="$(( $(( ! ${_perl_disabled_30} )) && $([ "_${command_242}" != "_0" ]; echo $?) ))"
perl_get_cjk_width__1219_v0() {
    local text=$1
    if [ "$(( ! ${_perl_available_31} ))" != 0 ]; then
        ret_perl_get_cjk_width1219_v0=''
        return 1
    fi
    command_243="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1219_v0=''
        return "${__status}"
    fi
    width_str_314="${command_243}"
    parse_int__14_v0 "${width_str_314}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1219_v0=''
        return "${__status}"
    fi
    width_315="${ret_parse_int14_v0}"
    ret_perl_get_cjk_width1219_v0="${width_315}"
    return 0
}

perl_truncate_cjk__1220_v0() {
    local text=$1
    local max_width=$2
    if [ "$(( ! ${_perl_available_31} ))" != 0 ]; then
        ret_perl_truncate_cjk1220_v0=''
        return 1
    fi
    command_244="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text}" ${max_width} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1220_v0=''
        return "${__status}"
    fi
    result_318="${command_244}"
    ret_perl_truncate_cjk1220_v0="${result_318}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_32=0
_term_size_33=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
stty_lock__1228_v0() {
    command_246="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_300="${command_246}"
    parse_int__14_v0 "${count_300}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_301="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_301} == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_301="$(( ${count_num_301} + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_301}
    __status=$?
}

stty_unlock__1229_v0() {
    command_247="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_355="${command_247}"
    parse_int__14_v0 "${count_355}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_356="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_356} > 0 ))" != 0 ]; then
        count_num_356="$(( ${count_num_356} - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_356}
        __status=$?
        if [ "$(( ${count_num_356} == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

parse_size__1230_v0() {
    local text=$1
    # `match_regex` uses BRE by default, where `+` is a literal character
    match_regex__20_v0 "${text}" "^[0-9][0-9]*\$" 0
    ret_match_regex20_v0__38_12="${ret_match_regex20_v0}"
    if [ "$(( ! ${ret_match_regex20_v0__38_12} ))" != 0 ]; then
        ret_parse_size1230_v0=0
        return 0
    fi
    parse_int__14_v0 "${text}"
    __status=$?
    ret_parse_size1230_v0="${ret_parse_int14_v0}"
    return 0
}

query_term_size__1231_v0() {
    command_248="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; echo "$height; $width")"
    __status=$?
    result_302="${command_248}"
    split__5_v0 "${result_302}" ";"
    parts_303=("${ret_split5_v0[@]}")
    __length_249=("${parts_303[@]}")
    if [ "$(( ${#__length_249[@]} != 2 ))" != 0 ]; then
        ret_query_term_size1231_v0=0
        return 0
    fi
    parse_size__1230_v0 "${parts_303[0]}"
    rows_304="${ret_parse_size1230_v0}"
    parse_size__1230_v0 "${parts_303[1]}"
    cols_305="${ret_parse_size1230_v0}"
    if [ "$(( $(( ${rows_304} <= 0 )) || $(( ${cols_305} <= 0 )) ))" != 0 ]; then
        ret_query_term_size1231_v0=0
        return 0
    fi
    _term_size_33=("${cols_305}" "${rows_304}")
    ret_query_term_size1231_v0=1
    return 0
}

stty_term_size__1232_v0() {
    command_251="$(stty size < /dev/tty 2>/dev/null)"
    __status=$?
    result_307="${command_251}"
    split__5_v0 "${result_307}" " "
    parts_308=("${ret_split5_v0[@]}")
    __length_252=("${parts_308[@]}")
    if [ "$(( ${#__length_252[@]} != 2 ))" != 0 ]; then
        ret_stty_term_size1232_v0=0
        return 0
    fi
    parse_size__1230_v0 "${parts_308[0]}"
    rows_309="${ret_parse_size1230_v0}"
    parse_size__1230_v0 "${parts_308[1]}"
    cols_310="${ret_parse_size1230_v0}"
    if [ "$(( $(( ${rows_309} <= 0 )) || $(( ${cols_310} <= 0 )) ))" != 0 ]; then
        ret_stty_term_size1232_v0=0
        return 0
    fi
    _term_size_33=("${cols_310}" "${rows_309}")
    ret_stty_term_size1232_v0=1
    return 0
}

get_term_size__1233_v0() {
    query_term_size__1231_v0 
    detected_306="${ret_query_term_size1231_v0}"
    if [ "$(( ! ${detected_306} ))" != 0 ]; then
        stty_term_size__1232_v0 
        detected_306="${ret_stty_term_size1232_v0__84_20}"
    fi
    _got_term_size_32=1
}

term_width__1235_v0() {
    if [ "$(( ! ${_got_term_size_32} ))" != 0 ]; then
        get_term_size__1233_v0 
    fi
    ret_term_width1235_v0="${_term_size_33[0]}"
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
get_supports_truecolor__1246_v0() {
    env_var_get__98_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    config_291="${ret_env_var_get98_v0}"
    if [ "$([ "_${config_291}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_34="No"
        ret_get_supports_truecolor1246_v0=0
        return 0
    fi
    env_var_get__98_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_34="No"
        ret_get_supports_truecolor1246_v0=0
        return 0
    fi
    colorterm_292="${ret_env_var_get98_v0}"
    _supports_truecolor_34="$(if [ "$(( $([ "_${colorterm_292}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_292}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1246_v0="$([ "_${_supports_truecolor_34}" != "_Yes" ]; echo $?)"
    return 0
}

colored_rgb__1247_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    if [ "$([ "_${_supports_truecolor_34}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1247_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_34}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1246_v0 
        ret_get_supports_truecolor1246_v0__50_17="${ret_get_supports_truecolor1246_v0}"
        if [ "${ret_get_supports_truecolor1246_v0__50_17}" != 0 ]; then
            ret_colored_rgb1247_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
            return 0
        elif [ "$(( ${fallback} == 0 ))" != 0 ]; then
            ret_colored_rgb1247_v0="${message}"
            return 0
        else
            ret_colored_rgb1247_v0="\\x1b[${fallback}m""${message}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( ${fallback} == 0 ))" != 0 ]; then
            ret_colored_rgb1247_v0="${message}"
            return 0
        fi
        ret_colored_rgb1247_v0="\\x1b[${fallback}m""${message}""\\x1b[0m"
        return 0
    fi
}

background_rgb__1248_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    # Convert foreground color code to background color code
    # 30-37 -> 40-47, 90-97 -> 100-107
    bg_fallback_339="${fallback}"
    if [ "$(( $(( ${fallback} >= 30 )) && $(( ${fallback} <= 37 )) ))" != 0 ]; then
        bg_fallback_339="$(( ${fallback} + 10 ))"
    fi
    if [ "$(( $(( ${fallback} >= 90 )) && $(( ${fallback} <= 97 )) ))" != 0 ]; then
        bg_fallback_339="$(( ${fallback} + 10 ))"
    fi
    if [ "$([ "_${_supports_truecolor_34}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_background_rgb1248_v0="\\x1b[48;2;${r};${g};${b}m""${message}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_34}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1246_v0 
        ret_get_supports_truecolor1246_v0__92_17="${ret_get_supports_truecolor1246_v0}"
        if [ "${ret_get_supports_truecolor1246_v0__92_17}" != 0 ]; then
            ret_background_rgb1248_v0="\\x1b[48;2;${r};${g};${b}m""${message}""\\x1b[0m"
            return 0
        elif [ "$(( ${bg_fallback_339} == 0 ))" != 0 ]; then
            ret_background_rgb1248_v0="${message}"
            return 0
        else
            ret_background_rgb1248_v0="\\x1b[${bg_fallback_339}m""${message}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( ${bg_fallback_339} == 0 ))" != 0 ]; then
            ret_background_rgb1248_v0="${message}"
            return 0
        fi
        ret_background_rgb1248_v0="\\x1b[${bg_fallback_339}m""${message}""\\x1b[0m"
        return 0
    fi
}

inner_get_xylitol_colors__1249_v0() {
    if [ "$(( ! ${_got_xylitol_colors_35} ))" != 0 ]; then
        env_var_get__98_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        primary_env_285="${ret_env_var_get98_v0}"
        if [ "$([ "_${primary_env_285}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${primary_env_285}" ";"
            parts_286=("${ret_split5_v0[@]}")
            __length_257=("${parts_286[@]}")
            if [ "$(( ${#__length_257[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_286[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1249_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__115_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_286[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1249_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__116_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_286[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1249_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__117_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_286[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1249_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__118_21="${ret_parse_int14_v0}"
                _primary_color_36=("${ret_parse_int14_v0__115_21}" "${ret_parse_int14_v0__116_21}" "${ret_parse_int14_v0__117_21}" "${ret_parse_int14_v0__118_21}")
            fi
        fi
        env_var_get__98_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        secondary_env_287="${ret_env_var_get98_v0}"
        if [ "$([ "_${secondary_env_287}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${secondary_env_287}" ";"
            parts_288=("${ret_split5_v0[@]}")
            __length_259=("${parts_288[@]}")
            if [ "$(( ${#__length_259[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_288[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1249_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__128_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_288[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1249_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__129_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_288[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1249_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__130_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_288[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1249_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__131_21="${ret_parse_int14_v0}"
                _secondary_color_37=("${ret_parse_int14_v0__128_21}" "${ret_parse_int14_v0__129_21}" "${ret_parse_int14_v0__130_21}" "${ret_parse_int14_v0__131_21}")
            fi
        fi
        env_var_get__98_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        accent_env_289="${ret_env_var_get98_v0}"
        if [ "$([ "_${accent_env_289}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${accent_env_289}" ";"
            parts_290=("${ret_split5_v0[@]}")
            __length_261=("${parts_290[@]}")
            if [ "$(( ${#__length_261[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_290[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1249_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__141_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_290[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1249_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__142_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_290[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1249_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__143_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_290[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1249_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__144_21="${ret_parse_int14_v0}"
            fi
        fi
        _got_xylitol_colors_35=1
    fi
}

get_xylitol_colors__1250_v0() {
    inner_get_xylitol_colors__1249_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__112_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_35=1
}

colored_primary__1251_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_35} ))" != 0 ]; then
        get_xylitol_colors__1250_v0 
    fi
    colored_rgb__1247_v0 "${message}" "${_primary_color_36[0]}" "${_primary_color_36[1]}" "${_primary_color_36[2]}" "${_primary_color_36[3]}"
    ret_colored_primary1251_v0="${ret_colored_rgb1247_v0}"
    return 0
}

colored_secondary__1252_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_35} ))" != 0 ]; then
        get_xylitol_colors__1250_v0 
    fi
    colored_rgb__1247_v0 "${message}" "${_secondary_color_37[0]}" "${_secondary_color_37[1]}" "${_secondary_color_37[2]}" "${_secondary_color_37[3]}"
    ret_colored_secondary1252_v0="${ret_colored_rgb1247_v0}"
    return 0
}

background_secondary__1255_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_35} ))" != 0 ]; then
        get_xylitol_colors__1250_v0 
    fi
    background_rgb__1248_v0 "${message}" "${_secondary_color_37[0]}" "${_secondary_color_37[1]}" "${_secondary_color_37[2]}" "${_secondary_color_37[3]}"
    ret_background_secondary1255_v0="${ret_background_rgb1248_v0}"
    return 0
}

# // IO Functions /////
get_key__1267_v0() {
    command_263="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    var_350="${command_263}"
    if [ "$([ "_${var_350}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1267_v0="UP"
        return 0
    elif [ "$([ "_${var_350}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1267_v0="DOWN"
        return 0
    elif [ "$([ "_${var_350}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1267_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_350}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1267_v0="LEFT"
        return 0
    elif [ "$([ "_${var_350}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1267_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_350}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1267_v0="INPUT"
        return 0
    else
        ret_get_key1267_v0="${var_350}"
        return 0
    fi
}

eprintf__1269_v0() {
    local format=$1
    local args=("${!2}")
    args=("${format}" "${args[@]}")
    __status=$?
    printf "${args[@]}" >&2
    __status=$?
}

eprintf_colored__1270_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    array_264=("${message}")
    eprintf__1269_v0 "\\x1b[${color}m%s\\x1b[0m" array_264[@]
}

colored__1271_v0() {
    local message=$1
    local color=$2
    # Returns a text wrapped in color codes.
    ret_colored1271_v0="\\x1b[${color}m""${message}""\\x1b[0m"
    return 0
}

remove_line__1273_v0() {
    local cnt=$1
    if [ "$(( ${cnt} > 0 ))" != 0 ]; then
        sequence_353=""
        from=0
        to="${cnt}"
        for ____354 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
            sequence_353+="\\x1b[2K\\x1b[1A"
        done
        array_265=("")
        eprintf__1269_v0 "${sequence_353}" array_265[@]
    fi
    array_266=("")
    eprintf__1269_v0 "\\x1b[9999D" array_266[@]
}

remove_current_line__1274_v0() {
    array_267=("")
    eprintf__1269_v0 "\\x1b[2K\\x1b[9999D" array_267[@]
}

go_up__1277_v0() {
    local cnt=$1
    array_268=("")
    eprintf__1269_v0 "\\x1b[${cnt}A" array_268[@]
}

go_down__1278_v0() {
    local cnt=$1
    array_269=("")
    eprintf__1269_v0 "\\x1b[${cnt}B" array_269[@]
}

# move the cursor up or down `cnt` lines.
hide_cursor__1280_v0() {
    array_270=("")
    eprintf__1269_v0 "\\x1b[?25l" array_270[@]
}

show_cursor__1281_v0() {
    array_271=("")
    eprintf__1269_v0 "\\x1b[?25h" array_271[@]
}

# / Text Utilities /////
has_ansi_escape__1282_v0() {
    local text=$1
    # Check for ESC character (0x1B = 27) or literal \x1b[
    command_272="$([[ "${text}" == *$'\x1b'* || "${text}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    has_escape_298="${command_272}"
    ret_has_ansi_escape1282_v0="$([ "_${has_escape_298}" != "_1" ]; echo $?)"
    return 0
}

escape_ansi__1283_v0() {
    local text=$1
    command_273="$(printf '%s' "${text}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1283_v0="${command_273}"
    return 0
}

strip_ansi__1284_v0() {
    local text=$1
    command_274="$(printf "%s" "${text}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1284_v0="${command_274}"
    return 0
}

is_all_ascii__1285_v0() {
    local text=$1
    command_275="$(printf "%s" "${text}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    result_313="${command_275}"
    ret_is_all_ascii1285_v0="$([ "_${result_313}" != "_0" ]; echo $?)"
    return 0
}

get_visible_len__1286_v0() {
    local text=$1
    strip_ansi__1284_v0 "${text}"
    stripped_312="${ret_strip_ansi1284_v0}"
    # Check if text is all ASCII
    is_all_ascii__1285_v0 "${stripped_312}"
    ret_is_all_ascii1285_v0__150_12="${ret_is_all_ascii1285_v0}"
    if [ "$(( ! ${ret_is_all_ascii1285_v0__150_12} ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1219_v0 "${stripped_312}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            __length_276="${stripped_312}"
            ret_get_visible_len1286_v0="${#__length_276}"
            return 0
        fi
        ret_get_visible_len1286_v0="${ret_perl_get_cjk_width1219_v0}"
        return 0
    else
        __length_277="${stripped_312}"
        ret_get_visible_len1286_v0="${#__length_277}"
        return 0
    fi
}

truncate_text__1287_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__1286_v0 "${text}"
    visible_len_317="${ret_get_visible_len1286_v0}"
    if [ "$(( ${visible_len_317} <= ${max_width} ))" != 0 ]; then
        ret_truncate_text1287_v0="${text}"
        return 0
    fi
    is_all_ascii__1285_v0 "${text}"
    ret_is_all_ascii1285_v0__167_12="${ret_is_all_ascii1285_v0}"
    if [ "$(( ! ${ret_is_all_ascii1285_v0__167_12} ))" != 0 ]; then
        perl_truncate_cjk__1220_v0 "${text}" "${max_width}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text}" | cut -c1-${max_width}
            __status=$?
        fi
        ret_truncate_text1287_v0="${ret_perl_truncate_cjk1220_v0}"
        return 0
    fi
    command_278="$(printf "%s" "${text}" | cut -c1-${max_width})"
    __status=$?
    ret_truncate_text1287_v0="${command_278}"
    return 0
}

truncate_ansi__1288_v0() {
    local text=$1
    local max_width=$2
    has_ansi_escape__1282_v0 "${text}"
    ret_has_ansi_escape1282_v0__179_12="${ret_has_ansi_escape1282_v0}"
    if [ "$(( ! ${ret_has_ansi_escape1282_v0__179_12} ))" != 0 ]; then
        truncate_text__1287_v0 "${text}" "${max_width}"
        ret_truncate_ansi1288_v0="${ret_truncate_text1287_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    command_279="$([[ "${text}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    starts_with_ansi_319="${command_279}"
    # Replace \x1b[ with newline, then split
    command_280="$(t="${text}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    replaced_320="${command_280}"
    split__5_v0 "${replaced_320}" "
"
    parts_321=("${ret_split5_v0[@]}")
    result_322=""
    remaining_width_323="${max_width}"
    from=0
    __length_281=("${parts_321[@]}")
    to="${#__length_281[@]}"
    for idx_324 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        part_325="${parts_321[${idx_324}]}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( ${idx_324} == 0 )) && $([ "_${starts_with_ansi_319}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_325}" == "_" ]; echo $?) && $(( ${remaining_width_323} > 0 )) ))" != 0 ]; then
                truncate_text__1287_v0 "${part_325}" "${remaining_width_323}"
                truncated_326="${ret_truncate_text1287_v0}"
                result_322+="${truncated_326}"
                get_visible_len__1286_v0 "${truncated_326}"
                ret_get_visible_len1286_v0__203_36="${ret_get_visible_len1286_v0}"
                remaining_width_323="$(( ${remaining_width_323} - ${ret_get_visible_len1286_v0__203_36} ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            command_282="$(__p="${part_325}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            m_idx_327="${command_282}"
            if [ "$([ "_${m_idx_327}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                command_283="$(__p="${part_325}"; printf "%s" "${__p:0:${m_idx_327}}")"
                __status=$?
                ansi_params_328="${command_283}"
                result_322+="\\x1b[""${ansi_params_328}""m"
                # Rest is text content
                parse_int__14_v0 "${m_idx_327}"
                __status=$?
                m_idx_num_329="${ret_parse_int14_v0}"
                text_start_330="$(( ${m_idx_num_329} + 1 ))"
                command_284="$(__p="${part_325}"; printf "%s" "${__p:${text_start_330}}")"
                __status=$?
                text_part_331="${command_284}"
                if [ "$(( $([ "_${text_part_331}" == "_" ]; echo $?) && $(( ${remaining_width_323} > 0 )) ))" != 0 ]; then
                    truncate_text__1287_v0 "${text_part_331}" "${remaining_width_323}"
                    truncated_332="${ret_truncate_text1287_v0}"
                    result_322+="${truncated_332}"
                    get_visible_len__1286_v0 "${truncated_332}"
                    ret_get_visible_len1286_v0__220_40="${ret_get_visible_len1286_v0}"
                    remaining_width_323="$(( ${remaining_width_323} - ${ret_get_visible_len1286_v0__220_40} ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_325}" == "_" ]; echo $?) && $(( ${remaining_width_323} > 0 )) ))" != 0 ]; then
                    truncate_text__1287_v0 "${part_325}" "${remaining_width_323}"
                    truncated_333="${ret_truncate_text1287_v0}"
                    result_322+="${truncated_333}"
                    get_visible_len__1286_v0 "${truncated_333}"
                    remaining_width_323="$(( ${remaining_width_323} - ${ret_get_visible_len1286_v0__227_40} ))"
                fi
            fi
        fi
    done
    ret_truncate_ansi1288_v0="${result_322}"
    return 0
}

cutoff_text__1289_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__1286_v0 "${text}"
    visible_len_316="${ret_get_visible_len1286_v0}"
    if [ "$(( ${visible_len_316} <= ${max_width} ))" != 0 ]; then
        ret_cutoff_text1289_v0="${text}"
        return 0
    fi
    truncate_ansi__1288_v0 "${text}" "$(( ${max_width} - 3 ))"
    ret_truncate_ansi1288_v0__243_12="${ret_truncate_ansi1288_v0}"
    ret_cutoff_text1289_v0="${ret_truncate_ansi1288_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
render_tooltip__1290_v0() {
    local items=("${!1}")
    local total_len=$2
    local term_width=$3
    separator_340=" • "
    separator_len_341=3
    # Fast path: no truncation needed
    if [ "$(( ${total_len} <= ${term_width} ))" != 0 ]; then
        iter_342=0
        while :
        do
            __length_285=("${items[@]}")
            if [ "$(( ${iter_342} >= ${#__length_285[@]} ))" != 0 ]; then
                break
            elif [ "$(( ${iter_342} > 0 ))" != 0 ]; then
                eprintf_colored__1270_v0 "${separator_340}" 90
            fi
            colored__1271_v0 "${items[$(( ${iter_342} + 1 ))]}" 2
            ret_colored1271_v0__268_41="${ret_colored1271_v0}"
            array_286=("")
            eprintf__1269_v0 "${items[${iter_342}]}"" ""${ret_colored1271_v0__268_41}" array_286[@]
            iter_342="$(( ${iter_342} + 2 ))"
        done
    else
        # Slow path: truncate
        current_len_343=0
        first_344=1
        iter_345=0
        while :
        do
            __length_287=("${items[@]}")
            if [ "$(( ${iter_345} >= ${#__length_287[@]} ))" != 0 ]; then
                break
            fi
            key_346="${items[${iter_345}]}"
            action_347="${items[$(( ${iter_345} + 1 ))]}"
            __length_288="${key_346}"
            __length_289="${action_347}"
            part_len_348="$(( $(( ${#__length_288} + 1 )) + ${#__length_289} ))"
            needed_349="${part_len_348}"
            if [ "$(( ! ${first_344} ))" != 0 ]; then
                needed_349="$(( ${needed_349} + ${separator_len_341} ))"
            fi
            if [ "$(( $(( ${current_len_343} + ${needed_349} )) > ${term_width} ))" != 0 ]; then
                break
            fi
            if [ "$(( ! ${first_344} ))" != 0 ]; then
                eprintf_colored__1270_v0 "${separator_340}" 90
            fi
            colored__1271_v0 "${action_347}" 2
            ret_colored1271_v0__296_33="${ret_colored1271_v0}"
            array_290=("")
            eprintf__1269_v0 "${key_346}"" ""${ret_colored1271_v0__296_33}" array_290[@]
            current_len_343="$(( ${current_len_343} + ${needed_349} ))"
            first_344=0
            iter_345="$(( ${iter_345} + 2 ))"
        done
    fi
}

render_confirm_options__1340_v0() {
    local selected=$1
    local term_width=$2
    small_335="$(( ${term_width} < 30 ))"
    yes_label_336="$(if [ "${small_335}" != 0 ]; then echo " Yes "; else echo "    Yes    "; fi)"
    no_label_337="$(if [ "${small_335}" != 0 ]; then echo " No "; else echo "    No    "; fi)"
    gap_338="$(if [ "${small_335}" != 0 ]; then echo " "; else echo "  "; fi)"
    array_291=("")
    eprintf__1269_v0 " " array_291[@]
    if [ "${selected}" != 0 ]; then
        # Yes selected
        background_secondary__1255_v0 "${yes_label_336}"
        ret_background_secondary1255_v0__15_30="${ret_background_secondary1255_v0}"
        array_292=("")
        eprintf__1269_v0 "\\x1b[97m""${ret_background_secondary1255_v0__15_30}" array_292[@]
        array_293=("")
        eprintf__1269_v0 "${gap_338}" array_293[@]
        # No not selected (dim)
        array_294=("")
        eprintf__1269_v0 "\\x1b[49;37m""${no_label_337}""\\x1b[0m" array_294[@]
    else
        # No selected
        array_295=("")
        eprintf__1269_v0 "\\x1b[49;37m""${yes_label_336}""\\x1b[0m" array_295[@]
        array_296=("")
        eprintf__1269_v0 "${gap_338}" array_296[@]
        background_secondary__1255_v0 "${no_label_337}"
        ret_background_secondary1255_v0__23_30="${ret_background_secondary1255_v0}"
        array_297=("")
        eprintf__1269_v0 "\\x1b[97m""${ret_background_secondary1255_v0__23_30}" array_297[@]
    fi
}

xyl_confirm__1341_v0() {
    local header=$1
    local default_yes=$2
    stty_lock__1228_v0 
    hide_cursor__1280_v0 
    term_width__1235_v0 
    term_width_311="${ret_term_width1235_v0}"
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__1289_v0 "${header}" "${term_width_311}"
        ret_cutoff_text1289_v0__45_17="${ret_cutoff_text1289_v0}"
        array_298=("")
        eprintf__1269_v0 "${ret_cutoff_text1289_v0__45_17}""

" array_298[@]
    fi
    selected_334="${default_yes}"
    # Render initial options
    render_confirm_options__1340_v0 "${selected_334}" "${term_width_311}"
    array_299=("")
    eprintf__1269_v0 "

" array_299[@]
    # "←→ select • enter confirm • y yes • n no" = 9 + 3 + 13 + 3 + 5 + 3 + 4 = 40
    array_300=("←→" "select" "enter" "confirm" "y" "yes" "n" "no")
    render_tooltip__1290_v0 array_300[@] 40 "${term_width_311}"
    go_up__1277_v0 2
    while :
    do
        get_key__1267_v0 
        key_351="${ret_get_key1267_v0}"
        if [ "$(( $(( $(( $([ "_${key_351}" != "_LEFT" ]; echo $?) || $([ "_${key_351}" != "_h" ]; echo $?) )) || $([ "_${key_351}" != "_RIGHT" ]; echo $?) )) || $([ "_${key_351}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "${selected_334}" != 0 ]; then
                selected_334=0
                array_301=("")
                eprintf__1269_v0 "\\x1b[9999D\\x1b[K" array_301[@]
                render_confirm_options__1340_v0 "${selected_334}" "${term_width_311}"
            elif [ "$(( ! ${selected_334} ))" != 0 ]; then
                selected_334=1
                array_302=("")
                eprintf__1269_v0 "\\x1b[9999D\\x1b[K" array_302[@]
                render_confirm_options__1340_v0 "${selected_334}" "${term_width_311}"
            fi
        elif [ "$(( $([ "_${key_351}" != "_y" ]; echo $?) || $([ "_${key_351}" != "_Y" ]; echo $?) ))" != 0 ]; then
            selected_334=1
            break
        elif [ "$(( $([ "_${key_351}" != "_n" ]; echo $?) || $([ "_${key_351}" != "_N" ]; echo $?) ))" != 0 ]; then
            selected_334=0
            break
        elif [ "$([ "_${key_351}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
    done
    # Clean up: remove options line and hint line
    total_lines_352=4
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_352="$(( ${total_lines_352} + 1 ))"
    fi
    go_down__1278_v0 2
    remove_line__1273_v0 "$(( ${total_lines_352} - 1 ))"
    remove_current_line__1274_v0 
    stty_unlock__1229_v0 
    show_cursor__1281_v0 
    ret_xyl_confirm1341_v0="${selected_334}"
    return 0
}

print_confirm_help__1417_v0() {
    echo "Usage: ./xylitol.sh confirm [flags]"
    echo ""
    colored_primary__1251_v0 "confirm"
    ret_colored_primary1251_v0__7_12="${ret_colored_primary1251_v0}"
    array_303=("")
    printf__106_v0 "${ret_colored_primary1251_v0__7_12}" array_303[@]
    array_304=("")
    printf__106_v0 " - Display a Yes/No confirmation dialog." array_304[@]
    echo ""
    echo ""
    colored_secondary__1252_v0 "Flags: "
    ret_colored_secondary1252_v0__11_12="${ret_colored_secondary1252_v0}"
    array_305=("")
    printf__106_v0 "${ret_colored_secondary1252_v0__11_12}""
" array_305[@]
    echo "  -h, --help             Show this help message"
    echo "  --header=\"<text>\"      Set a header text to display above the options (ANSI escape supported)"
    echo "  --default=<yes|no>     Set the default selection (default: yes)"
    echo ""
}

execute_confirm__1468_v0() {
    local parameters=("${!1}")
    colored_primary__1251_v0 "Are you sure?"
    ret_colored_primary1251_v0__9_30="${ret_colored_primary1251_v0}"
    header_293="\\x1b[1m""${ret_colored_primary1251_v0__9_30}"
    default_yes_294=1
    for param_295 in "${parameters[@]}"; do
        match_regex__20_v0 "${param_295}" "^-h\$" 0
        ret_match_regex20_v0__14_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_295}" "^--help\$" 0
        ret_match_regex20_v0__14_43="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_295}" "^--header=.*\$" 0
        ret_match_regex20_v0__18_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_295}" "^--default=.*\$" 0
        ret_match_regex20_v0__22_13="${ret_match_regex20_v0}"
        if [ "$(( ${ret_match_regex20_v0__14_13} || ${ret_match_regex20_v0__14_43} ))" != 0 ]; then
            print_confirm_help__1417_v0 
            exit 0
        elif [ "${ret_match_regex20_v0__18_13}" != 0 ]; then
            split__5_v0 "${param_295}" "="
            result_296=("${ret_split5_v0[@]}")
            header_293="${result_296[1]}"
        elif [ "${ret_match_regex20_v0__22_13}" != 0 ]; then
            split__5_v0 "${param_295}" "="
            result_297=("${ret_split5_v0[@]}")
            if [ "$(( $([ "_${result_297[1]}" != "_yes" ]; echo $?) || $([ "_${result_297[1]}" != "_y" ]; echo $?) ))" != 0 ]; then
                default_yes_294=1
            elif [ "$(( $([ "_${result_297[1]}" != "_no" ]; echo $?) || $([ "_${result_297[1]}" != "_n" ]; echo $?) ))" != 0 ]; then
                default_yes_294=0
            else
                eprintf_colored__1270_v0 "ERROR: Invalid default value: ""${result_297[1]}"". Use 'yes' or 'no'.
" 31
                exit 1
            fi
        fi
    done
    has_ansi_escape__1282_v0 "${header_293}"
    ret_has_ansi_escape1282_v0__36_42="${ret_has_ansi_escape1282_v0}"
    escape_ansi__1283_v0 "${header_293}"
    ret_escape_ansi1283_v0__36_71="${ret_escape_ansi1283_v0}"
    colored_primary__1251_v0 "${header_293}"
    ret_colored_primary1251_v0__36_109="${ret_colored_primary1251_v0}"
    display_header_299="$(if [ "$(( $([ "_${header_293}" != "_" ]; echo $?) || ${ret_has_ansi_escape1282_v0__36_42} ))" != 0 ]; then echo "${ret_escape_ansi1283_v0__36_71}"; else echo "\\x1b[1m""${ret_colored_primary1251_v0__36_109}"; fi)"
    xyl_confirm__1341_v0 "${display_header_299}" "${default_yes_294}"
    result_357="${ret_xyl_confirm1341_v0}"
    ret_execute_confirm1468_v0="$(if [ "${result_357}" != 0 ]; then echo "yes"; else echo "no"; fi)"
    return 0
}

get_directory_entries__1586_v0() {
    local path=$1
    command_306="$(ls -lA "${path}" 2>/dev/null | tail -n +2)"
    __status=$?
    raw_390="${command_306}"
    command_307="$(ls -lA "${path}" | tail -n +2 | sed -E 's/^(.).*/\1/')"
    __status=$?
    types_391="${command_307}"
    command_308="$(ls -1A "${path}")"
    __status=$?
    names_392="${command_308}"
    split__5_v0 "${types_391}" "
"
    types_393=("${ret_split5_v0[@]}")
    split__5_v0 "${raw_390}" "
"
    raw_394=("${ret_split5_v0[@]}")
    split__5_v0 "${names_392}" "
"
    names_395=("${ret_split5_v0[@]}")
    entries_396=()
    from=0
    __length_310=("${raw_394[@]}")
    to="${#__length_310[@]}"
    for i_397 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        file_type_398="f"
        target_399=""
        if [ "$([ "_${types_393[${i_397}]}" != "_-" ]; echo $?)" != 0 ]; then
            file_type_398="f"
        elif [ "$([ "_${types_393[${i_397}]}" != "_d" ]; echo $?)" != 0 ]; then
            file_type_398="d"
        elif [ "$([ "_${types_393[${i_397}]}" != "_l" ]; echo $?)" != 0 ]; then
            command_311="$(echo ${raw_394[${i_397}]} | sed 's/.*-> //')"
            __status=$?
            target_399="${command_311}"
            file_type_398="l"
        fi
        if [ "$([ "_${file_type_398}" != "_l" ]; echo $?)" != 0 ]; then
            entries_396+=("${names_395[${i_397}]}	${types_393[${i_397}]}	${target_399}")
        else
            entries_396+=("${names_395[${i_397}]}	${types_393[${i_397}]}")
        fi
    done
    ret_get_directory_entries1586_v0=("${entries_396[@]}")
    return 0
}

parse_entry__1587_v0() {
    local entry=$1
    split__5_v0 "${entry}" "	"
    ret_parse_entry1587_v0=("${ret_split5_v0[@]}")
    return 0
}

get_cwd__1588_v0() {
    command_314="$(pwd)"
    __status=$?
    ret_get_cwd1588_v0="${command_314}"
    return 0
}

normalize_path__1589_v0() {
    local path=$1
    command_315="$(cd "${path}" 2>/dev/null && pwd)"
    __status=$?
    normalized_389="${command_315}"
    if [ "$([ "_${normalized_389}" != "_" ]; echo $?)" != 0 ]; then
        ret_normalize_path1589_v0="${path}"
        return 0
    fi
    ret_normalize_path1589_v0="${normalized_389}"
    return 0
}

is_directory__1590_v0() {
    local path=$1
    command_316="$([ -d "${path}" ] && echo "1" || echo "0")"
    __status=$?
    result_506="${command_316}"
    ret_is_directory1590_v0="$([ "_${result_506}" != "_1" ]; echo $?)"
    return 0
}

path_join__1591_v0() {
    local base=$1
    local child=$2
    if [ "$([ "_${base}" != "_/" ]; echo $?)" != 0 ]; then
        ret_path_join1591_v0="/""${child}"
        return 0
    fi
    ret_path_join1591_v0="${base}""/""${child}"
    return 0
}

get_parent_dir__1592_v0() {
    local path=$1
    command_317="$(dirname "${path}")"
    __status=$?
    parent_502="${command_317}"
    ret_get_parent_dir1592_v0="${parent_502}"
    return 0
}

# Perl Extensions Utilities
command_318="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_39="$([ "_${command_318}" != "_No" ]; echo $?)"
command_319="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_40="$(( $(( ! ${_perl_disabled_39} )) && $([ "_${command_319}" != "_0" ]; echo $?) ))"
# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_41=0
_term_size_42=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
stty_lock__1610_v0() {
    command_321="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_375="${command_321}"
    parse_int__14_v0 "${count_375}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_376="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_376} == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_376="$(( ${count_num_376} + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_376}
    __status=$?
}

stty_unlock__1611_v0() {
    command_322="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_409="${command_322}"
    parse_int__14_v0 "${count_409}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_410="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_410} > 0 ))" != 0 ]; then
        count_num_410="$(( ${count_num_410} - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_410}
        __status=$?
        if [ "$(( ${count_num_410} == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

parse_size__1612_v0() {
    local text=$1
    # `match_regex` uses BRE by default, where `+` is a literal character
    match_regex__20_v0 "${text}" "^[0-9][0-9]*\$" 0
    ret_match_regex20_v0__38_12="${ret_match_regex20_v0}"
    if [ "$(( ! ${ret_match_regex20_v0__38_12} ))" != 0 ]; then
        ret_parse_size1612_v0=0
        return 0
    fi
    parse_int__14_v0 "${text}"
    __status=$?
    ret_parse_size1612_v0="${ret_parse_int14_v0}"
    return 0
}

query_term_size__1613_v0() {
    command_323="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; echo "$height; $width")"
    __status=$?
    result_377="${command_323}"
    split__5_v0 "${result_377}" ";"
    parts_378=("${ret_split5_v0[@]}")
    __length_324=("${parts_378[@]}")
    if [ "$(( ${#__length_324[@]} != 2 ))" != 0 ]; then
        ret_query_term_size1613_v0=0
        return 0
    fi
    parse_size__1612_v0 "${parts_378[0]}"
    rows_379="${ret_parse_size1612_v0}"
    parse_size__1612_v0 "${parts_378[1]}"
    cols_380="${ret_parse_size1612_v0}"
    if [ "$(( $(( ${rows_379} <= 0 )) || $(( ${cols_380} <= 0 )) ))" != 0 ]; then
        ret_query_term_size1613_v0=0
        return 0
    fi
    _term_size_42=("${cols_380}" "${rows_379}")
    ret_query_term_size1613_v0=1
    return 0
}

stty_term_size__1614_v0() {
    command_326="$(stty size < /dev/tty 2>/dev/null)"
    __status=$?
    result_382="${command_326}"
    split__5_v0 "${result_382}" " "
    parts_383=("${ret_split5_v0[@]}")
    __length_327=("${parts_383[@]}")
    if [ "$(( ${#__length_327[@]} != 2 ))" != 0 ]; then
        ret_stty_term_size1614_v0=0
        return 0
    fi
    parse_size__1612_v0 "${parts_383[0]}"
    rows_384="${ret_parse_size1612_v0}"
    parse_size__1612_v0 "${parts_383[1]}"
    cols_385="${ret_parse_size1612_v0}"
    if [ "$(( $(( ${rows_384} <= 0 )) || $(( ${cols_385} <= 0 )) ))" != 0 ]; then
        ret_stty_term_size1614_v0=0
        return 0
    fi
    _term_size_42=("${cols_385}" "${rows_384}")
    ret_stty_term_size1614_v0=1
    return 0
}

get_term_size__1615_v0() {
    query_term_size__1613_v0 
    detected_381="${ret_query_term_size1613_v0}"
    if [ "$(( ! ${detected_381} ))" != 0 ]; then
        stty_term_size__1614_v0 
        detected_381="${ret_stty_term_size1614_v0__84_20}"
    fi
    _got_term_size_41=1
}

term_width__1617_v0() {
    if [ "$(( ! ${_got_term_size_41} ))" != 0 ]; then
        get_term_size__1615_v0 
    fi
    ret_term_width1617_v0="${_term_size_42[0]}"
    return 0
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
get_supports_truecolor__1628_v0() {
    env_var_get__98_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    config_370="${ret_env_var_get98_v0}"
    if [ "$([ "_${config_370}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_43="No"
        ret_get_supports_truecolor1628_v0=0
        return 0
    fi
    env_var_get__98_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_43="No"
        ret_get_supports_truecolor1628_v0=0
        return 0
    fi
    colorterm_371="${ret_env_var_get98_v0}"
    _supports_truecolor_43="$(if [ "$(( $([ "_${colorterm_371}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_371}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1628_v0="$([ "_${_supports_truecolor_43}" != "_Yes" ]; echo $?)"
    return 0
}

colored_rgb__1629_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    if [ "$([ "_${_supports_truecolor_43}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1629_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_43}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1628_v0 
        ret_get_supports_truecolor1628_v0__50_17="${ret_get_supports_truecolor1628_v0}"
        if [ "${ret_get_supports_truecolor1628_v0__50_17}" != 0 ]; then
            ret_colored_rgb1629_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
            return 0
        elif [ "$(( ${fallback} == 0 ))" != 0 ]; then
            ret_colored_rgb1629_v0="${message}"
            return 0
        else
            ret_colored_rgb1629_v0="\\x1b[${fallback}m""${message}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( ${fallback} == 0 ))" != 0 ]; then
            ret_colored_rgb1629_v0="${message}"
            return 0
        fi
        ret_colored_rgb1629_v0="\\x1b[${fallback}m""${message}""\\x1b[0m"
        return 0
    fi
}

inner_get_xylitol_colors__1631_v0() {
    if [ "$(( ! ${_got_xylitol_colors_44} ))" != 0 ]; then
        env_var_get__98_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        primary_env_364="${ret_env_var_get98_v0}"
        if [ "$([ "_${primary_env_364}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${primary_env_364}" ";"
            parts_365=("${ret_split5_v0[@]}")
            __length_332=("${parts_365[@]}")
            if [ "$(( ${#__length_332[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_365[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1631_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__115_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_365[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1631_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__116_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_365[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1631_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__117_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_365[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1631_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__118_21="${ret_parse_int14_v0}"
                _primary_color_45=("${ret_parse_int14_v0__115_21}" "${ret_parse_int14_v0__116_21}" "${ret_parse_int14_v0__117_21}" "${ret_parse_int14_v0__118_21}")
            fi
        fi
        env_var_get__98_v0 "XYLITOL_SECONDARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        secondary_env_366="${ret_env_var_get98_v0}"
        if [ "$([ "_${secondary_env_366}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${secondary_env_366}" ";"
            parts_367=("${ret_split5_v0[@]}")
            __length_334=("${parts_367[@]}")
            if [ "$(( ${#__length_334[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_367[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1631_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__128_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_367[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1631_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__129_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_367[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1631_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__130_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_367[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1631_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__131_21="${ret_parse_int14_v0}"
                _secondary_color_46=("${ret_parse_int14_v0__128_21}" "${ret_parse_int14_v0__129_21}" "${ret_parse_int14_v0__130_21}" "${ret_parse_int14_v0__131_21}")
            fi
        fi
        env_var_get__98_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        accent_env_368="${ret_env_var_get98_v0}"
        if [ "$([ "_${accent_env_368}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${accent_env_368}" ";"
            parts_369=("${ret_split5_v0[@]}")
            __length_336=("${parts_369[@]}")
            if [ "$(( ${#__length_336[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_369[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1631_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__141_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_369[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1631_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__142_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_369[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1631_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__143_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_369[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1631_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__144_21="${ret_parse_int14_v0}"
                _accent_color_47=("${ret_parse_int14_v0__141_21}" "${ret_parse_int14_v0__142_21}" "${ret_parse_int14_v0__143_21}" "${ret_parse_int14_v0__144_21}")
            fi
        fi
        _got_xylitol_colors_44=1
    fi
}

get_xylitol_colors__1632_v0() {
    inner_get_xylitol_colors__1631_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__112_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_44=1
}

colored_primary__1633_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_44} ))" != 0 ]; then
        get_xylitol_colors__1632_v0 
    fi
    colored_rgb__1629_v0 "${message}" "${_primary_color_45[0]}" "${_primary_color_45[1]}" "${_primary_color_45[2]}" "${_primary_color_45[3]}"
    ret_colored_primary1633_v0="${ret_colored_rgb1629_v0}"
    return 0
}

colored_secondary__1634_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_44} ))" != 0 ]; then
        get_xylitol_colors__1632_v0 
    fi
    colored_rgb__1629_v0 "${message}" "${_secondary_color_46[0]}" "${_secondary_color_46[1]}" "${_secondary_color_46[2]}" "${_secondary_color_46[3]}"
    ret_colored_secondary1634_v0="${ret_colored_rgb1629_v0}"
    return 0
}

colored_accent__1635_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_44} ))" != 0 ]; then
        get_xylitol_colors__1632_v0 
    fi
    colored_rgb__1629_v0 "${message}" "${_accent_color_47[0]}" "${_accent_color_47[1]}" "${_accent_color_47[2]}" "${_accent_color_47[3]}"
    ret_colored_accent1635_v0="${ret_colored_rgb1629_v0}"
    return 0
}

# // IO Functions /////
eprintf__1651_v0() {
    local format=$1
    local args=("${!2}")
    args=("${format}" "${args[@]}")
    __status=$?
    printf "${args[@]}" >&2
    __status=$?
}

eprintf_colored__1652_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    array_338=("${message}")
    eprintf__1651_v0 "\\x1b[${color}m%s\\x1b[0m" array_338[@]
}

remove_current_line__1656_v0() {
    array_339=("")
    eprintf__1651_v0 "\\x1b[2K\\x1b[9999D" array_339[@]
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# // Application Utilities /////
# Perl Extensions Utilities
command_340="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_48="$([ "_${command_340}" != "_No" ]; echo $?)"
command_341="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_49="$(( $(( ! ${_perl_disabled_48} )) && $([ "_${command_341}" != "_0" ]; echo $?) ))"
perl_get_cjk_width__1800_v0() {
    local text=$1
    if [ "$(( ! ${_perl_available_49} ))" != 0 ]; then
        ret_perl_get_cjk_width1800_v0=''
        return 1
    fi
    command_342="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1800_v0=''
        return "${__status}"
    fi
    width_str_428="${command_342}"
    parse_int__14_v0 "${width_str_428}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1800_v0=''
        return "${__status}"
    fi
    width_429="${ret_parse_int14_v0}"
    ret_perl_get_cjk_width1800_v0="${width_429}"
    return 0
}

perl_truncate_cjk__1801_v0() {
    local text=$1
    local max_width=$2
    if [ "$(( ! ${_perl_available_49} ))" != 0 ]; then
        ret_perl_truncate_cjk1801_v0=''
        return 1
    fi
    command_343="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text}" ${max_width} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1801_v0=''
        return "${__status}"
    fi
    result_433="${command_343}"
    ret_perl_truncate_cjk1801_v0="${result_433}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_50=0
_term_size_51=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
stty_lock__1809_v0() {
    command_345="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_412="${command_345}"
    parse_int__14_v0 "${count_412}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_413="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_413} == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_413="$(( ${count_num_413} + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_413}
    __status=$?
}

stty_unlock__1810_v0() {
    command_346="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_493="${command_346}"
    parse_int__14_v0 "${count_493}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_494="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_494} > 0 ))" != 0 ]; then
        count_num_494="$(( ${count_num_494} - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_494}
        __status=$?
        if [ "$(( ${count_num_494} == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

parse_size__1811_v0() {
    local text=$1
    # `match_regex` uses BRE by default, where `+` is a literal character
    match_regex__20_v0 "${text}" "^[0-9][0-9]*\$" 0
    ret_match_regex20_v0__38_12="${ret_match_regex20_v0}"
    if [ "$(( ! ${ret_match_regex20_v0__38_12} ))" != 0 ]; then
        ret_parse_size1811_v0=0
        return 0
    fi
    parse_int__14_v0 "${text}"
    __status=$?
    ret_parse_size1811_v0="${ret_parse_int14_v0}"
    return 0
}

query_term_size__1812_v0() {
    command_347="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -t 0.5 -rsd t _ignore height width < /dev/tty 2>/dev/null; echo "$height; $width")"
    __status=$?
    result_414="${command_347}"
    split__5_v0 "${result_414}" ";"
    parts_415=("${ret_split5_v0[@]}")
    __length_348=("${parts_415[@]}")
    if [ "$(( ${#__length_348[@]} != 2 ))" != 0 ]; then
        ret_query_term_size1812_v0=0
        return 0
    fi
    parse_size__1811_v0 "${parts_415[0]}"
    rows_416="${ret_parse_size1811_v0}"
    parse_size__1811_v0 "${parts_415[1]}"
    cols_417="${ret_parse_size1811_v0}"
    if [ "$(( $(( ${rows_416} <= 0 )) || $(( ${cols_417} <= 0 )) ))" != 0 ]; then
        ret_query_term_size1812_v0=0
        return 0
    fi
    _term_size_51=("${cols_417}" "${rows_416}")
    ret_query_term_size1812_v0=1
    return 0
}

stty_term_size__1813_v0() {
    command_350="$(stty size < /dev/tty 2>/dev/null)"
    __status=$?
    result_419="${command_350}"
    split__5_v0 "${result_419}" " "
    parts_420=("${ret_split5_v0[@]}")
    __length_351=("${parts_420[@]}")
    if [ "$(( ${#__length_351[@]} != 2 ))" != 0 ]; then
        ret_stty_term_size1813_v0=0
        return 0
    fi
    parse_size__1811_v0 "${parts_420[0]}"
    rows_421="${ret_parse_size1811_v0}"
    parse_size__1811_v0 "${parts_420[1]}"
    cols_422="${ret_parse_size1811_v0}"
    if [ "$(( $(( ${rows_421} <= 0 )) || $(( ${cols_422} <= 0 )) ))" != 0 ]; then
        ret_stty_term_size1813_v0=0
        return 0
    fi
    _term_size_51=("${cols_422}" "${rows_421}")
    ret_stty_term_size1813_v0=1
    return 0
}

get_term_size__1814_v0() {
    query_term_size__1812_v0 
    detected_418="${ret_query_term_size1812_v0}"
    if [ "$(( ! ${detected_418} ))" != 0 ]; then
        stty_term_size__1813_v0 
        detected_418="${ret_stty_term_size1813_v0__84_20}"
    fi
    _got_term_size_50=1
}

term_width__1816_v0() {
    if [ "$(( ! ${_got_term_size_50} ))" != 0 ]; then
        get_term_size__1814_v0 
    fi
    ret_term_width1816_v0="${_term_size_51[0]}"
    return 0
}

term_height__1817_v0() {
    if [ "$(( ! ${_got_term_size_50} ))" != 0 ]; then
        get_term_size__1814_v0 
    fi
    ret_term_height1817_v0="${_term_size_51[1]}"
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
get_supports_truecolor__1827_v0() {
    env_var_get__98_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    config_479="${ret_env_var_get98_v0}"
    if [ "$([ "_${config_479}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_52="No"
        ret_get_supports_truecolor1827_v0=0
        return 0
    fi
    env_var_get__98_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_52="No"
        ret_get_supports_truecolor1827_v0=0
        return 0
    fi
    colorterm_480="${ret_env_var_get98_v0}"
    _supports_truecolor_52="$(if [ "$(( $([ "_${colorterm_480}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_480}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1827_v0="$([ "_${_supports_truecolor_52}" != "_Yes" ]; echo $?)"
    return 0
}

colored_rgb__1828_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    if [ "$([ "_${_supports_truecolor_52}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1828_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_52}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1827_v0 
        ret_get_supports_truecolor1827_v0__50_17="${ret_get_supports_truecolor1827_v0}"
        if [ "${ret_get_supports_truecolor1827_v0__50_17}" != 0 ]; then
            ret_colored_rgb1828_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
            return 0
        elif [ "$(( ${fallback} == 0 ))" != 0 ]; then
            ret_colored_rgb1828_v0="${message}"
            return 0
        else
            ret_colored_rgb1828_v0="\\x1b[${fallback}m""${message}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( ${fallback} == 0 ))" != 0 ]; then
            ret_colored_rgb1828_v0="${message}"
            return 0
        fi
        ret_colored_rgb1828_v0="\\x1b[${fallback}m""${message}""\\x1b[0m"
        return 0
    fi
}

inner_get_xylitol_colors__1830_v0() {
    if [ "$(( ! ${_got_xylitol_colors_53} ))" != 0 ]; then
        env_var_get__98_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        primary_env_473="${ret_env_var_get98_v0}"
        if [ "$([ "_${primary_env_473}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${primary_env_473}" ";"
            parts_474=("${ret_split5_v0[@]}")
            __length_356=("${parts_474[@]}")
            if [ "$(( ${#__length_356[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_474[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1830_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__115_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_474[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1830_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__116_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_474[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1830_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__117_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_474[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1830_v0=''
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
        secondary_env_475="${ret_env_var_get98_v0}"
        if [ "$([ "_${secondary_env_475}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${secondary_env_475}" ";"
            parts_476=("${ret_split5_v0[@]}")
            __length_358=("${parts_476[@]}")
            if [ "$(( ${#__length_358[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_476[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1830_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__128_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_476[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1830_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__129_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_476[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1830_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__130_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_476[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1830_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__131_21="${ret_parse_int14_v0}"
                _secondary_color_55=("${ret_parse_int14_v0__128_21}" "${ret_parse_int14_v0__129_21}" "${ret_parse_int14_v0__130_21}" "${ret_parse_int14_v0__131_21}")
            fi
        fi
        env_var_get__98_v0 "XYLITOL_ACCENT_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        accent_env_477="${ret_env_var_get98_v0}"
        if [ "$([ "_${accent_env_477}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${accent_env_477}" ";"
            parts_478=("${ret_split5_v0[@]}")
            __length_360=("${parts_478[@]}")
            if [ "$(( ${#__length_360[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_478[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1830_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__141_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_478[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1830_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__142_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_478[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1830_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__143_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_478[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1830_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__144_21="${ret_parse_int14_v0}"
            fi
        fi
        _got_xylitol_colors_53=1
    fi
}

get_xylitol_colors__1831_v0() {
    inner_get_xylitol_colors__1830_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__112_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_53=1
}

colored_secondary__1833_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_53} ))" != 0 ]; then
        get_xylitol_colors__1831_v0 
    fi
    colored_rgb__1828_v0 "${message}" "${_secondary_color_55[0]}" "${_secondary_color_55[1]}" "${_secondary_color_55[2]}" "${_secondary_color_55[3]}"
    ret_colored_secondary1833_v0="${ret_colored_rgb1828_v0}"
    return 0
}

# // IO Functions /////
get_key__1848_v0() {
    command_362="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    var_483="${command_362}"
    if [ "$([ "_${var_483}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1848_v0="UP"
        return 0
    elif [ "$([ "_${var_483}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1848_v0="DOWN"
        return 0
    elif [ "$([ "_${var_483}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1848_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_483}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1848_v0="LEFT"
        return 0
    elif [ "$([ "_${var_483}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1848_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_483}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1848_v0="INPUT"
        return 0
    else
        ret_get_key1848_v0="${var_483}"
        return 0
    fi
}

eprintf__1850_v0() {
    local format=$1
    local args=("${!2}")
    args=("${format}" "${args[@]}")
    __status=$?
    printf "${args[@]}" >&2
    __status=$?
}

eprintf_colored__1851_v0() {
    local message=$1
    local color=$2
    # Prints an error message with a specified color.
    array_363=("${message}")
    eprintf__1850_v0 "\\x1b[${color}m%s\\x1b[0m" array_363[@]
}

colored__1852_v0() {
    local message=$1
    local color=$2
    # Returns a text wrapped in color codes.
    ret_colored1852_v0="\\x1b[${color}m""${message}""\\x1b[0m"
    return 0
}

remove_line__1854_v0() {
    local cnt=$1
    if [ "$(( ${cnt} > 0 ))" != 0 ]; then
        sequence_489=""
        from=0
        to="${cnt}"
        for ____490 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
            sequence_489+="\\x1b[2K\\x1b[1A"
        done
        array_364=("")
        eprintf__1850_v0 "${sequence_489}" array_364[@]
    fi
    array_365=("")
    eprintf__1850_v0 "\\x1b[9999D" array_365[@]
}

remove_current_line__1855_v0() {
    array_366=("")
    eprintf__1850_v0 "\\x1b[2K\\x1b[9999D" array_366[@]
}

print_blank__1856_v0() {
    local cnt=$1
    printf '%*s' "${cnt}" ' ' >&2
    __status=$?
}

new_line__1857_v0() {
    local cnt=$1
    from=0
    to="${cnt}"
    for i_453 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        array_367=("")
        eprintf__1850_v0 "
" array_367[@]
    done
}

go_up__1858_v0() {
    local cnt=$1
    array_368=("")
    eprintf__1850_v0 "\\x1b[${cnt}A" array_368[@]
}

go_down__1859_v0() {
    local cnt=$1
    array_369=("")
    eprintf__1850_v0 "\\x1b[${cnt}B" array_369[@]
}

# move the cursor up or down `cnt` lines.
go_up_or_down__1860_v0() {
    local cnt=$1
    if [ "$(( ${cnt} > 0 ))" != 0 ]; then
        go_down__1859_v0 "${cnt}"
    else
        go_up__1858_v0 "$(( - ${cnt} ))"
    fi
}

hide_cursor__1861_v0() {
    array_370=("")
    eprintf__1850_v0 "\\x1b[?25l" array_370[@]
}

show_cursor__1862_v0() {
    array_371=("")
    eprintf__1850_v0 "\\x1b[?25h" array_371[@]
}

# / Text Utilities /////
has_ansi_escape__1863_v0() {
    local text=$1
    # Check for ESC character (0x1B = 27) or literal \x1b[
    command_372="$([[ "${text}" == *$'\x1b'* || "${text}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    has_escape_431="${command_372}"
    ret_has_ansi_escape1863_v0="$([ "_${has_escape_431}" != "_1" ]; echo $?)"
    return 0
}

strip_ansi__1865_v0() {
    local text=$1
    command_373="$(printf "%s" "${text}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1865_v0="${command_373}"
    return 0
}

is_all_ascii__1866_v0() {
    local text=$1
    command_374="$(printf "%s" "${text}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    result_427="${command_374}"
    ret_is_all_ascii1866_v0="$([ "_${result_427}" != "_0" ]; echo $?)"
    return 0
}

get_visible_len__1867_v0() {
    local text=$1
    strip_ansi__1865_v0 "${text}"
    stripped_426="${ret_strip_ansi1865_v0}"
    # Check if text is all ASCII
    is_all_ascii__1866_v0 "${stripped_426}"
    ret_is_all_ascii1866_v0__150_12="${ret_is_all_ascii1866_v0}"
    if [ "$(( ! ${ret_is_all_ascii1866_v0__150_12} ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1800_v0 "${stripped_426}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            __length_375="${stripped_426}"
            ret_get_visible_len1867_v0="${#__length_375}"
            return 0
        fi
        ret_get_visible_len1867_v0="${ret_perl_get_cjk_width1800_v0}"
        return 0
    else
        __length_376="${stripped_426}"
        ret_get_visible_len1867_v0="${#__length_376}"
        return 0
    fi
}

truncate_text__1868_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__1867_v0 "${text}"
    visible_len_432="${ret_get_visible_len1867_v0}"
    if [ "$(( ${visible_len_432} <= ${max_width} ))" != 0 ]; then
        ret_truncate_text1868_v0="${text}"
        return 0
    fi
    is_all_ascii__1866_v0 "${text}"
    ret_is_all_ascii1866_v0__167_12="${ret_is_all_ascii1866_v0}"
    if [ "$(( ! ${ret_is_all_ascii1866_v0__167_12} ))" != 0 ]; then
        perl_truncate_cjk__1801_v0 "${text}" "${max_width}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text}" | cut -c1-${max_width}
            __status=$?
        fi
        ret_truncate_text1868_v0="${ret_perl_truncate_cjk1801_v0}"
        return 0
    fi
    command_377="$(printf "%s" "${text}" | cut -c1-${max_width})"
    __status=$?
    ret_truncate_text1868_v0="${command_377}"
    return 0
}

truncate_ansi__1869_v0() {
    local text=$1
    local max_width=$2
    has_ansi_escape__1863_v0 "${text}"
    ret_has_ansi_escape1863_v0__179_12="${ret_has_ansi_escape1863_v0}"
    if [ "$(( ! ${ret_has_ansi_escape1863_v0__179_12} ))" != 0 ]; then
        truncate_text__1868_v0 "${text}" "${max_width}"
        ret_truncate_ansi1869_v0="${ret_truncate_text1868_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    command_378="$([[ "${text}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    starts_with_ansi_434="${command_378}"
    # Replace \x1b[ with newline, then split
    command_379="$(t="${text}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    replaced_435="${command_379}"
    split__5_v0 "${replaced_435}" "
"
    parts_436=("${ret_split5_v0[@]}")
    result_437=""
    remaining_width_438="${max_width}"
    from=0
    __length_380=("${parts_436[@]}")
    to="${#__length_380[@]}"
    for idx_439 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        part_440="${parts_436[${idx_439}]}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( ${idx_439} == 0 )) && $([ "_${starts_with_ansi_434}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_440}" == "_" ]; echo $?) && $(( ${remaining_width_438} > 0 )) ))" != 0 ]; then
                truncate_text__1868_v0 "${part_440}" "${remaining_width_438}"
                truncated_441="${ret_truncate_text1868_v0}"
                result_437+="${truncated_441}"
                get_visible_len__1867_v0 "${truncated_441}"
                ret_get_visible_len1867_v0__203_36="${ret_get_visible_len1867_v0}"
                remaining_width_438="$(( ${remaining_width_438} - ${ret_get_visible_len1867_v0__203_36} ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            command_381="$(__p="${part_440}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            m_idx_442="${command_381}"
            if [ "$([ "_${m_idx_442}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                command_382="$(__p="${part_440}"; printf "%s" "${__p:0:${m_idx_442}}")"
                __status=$?
                ansi_params_443="${command_382}"
                result_437+="\\x1b[""${ansi_params_443}""m"
                # Rest is text content
                parse_int__14_v0 "${m_idx_442}"
                __status=$?
                m_idx_num_444="${ret_parse_int14_v0}"
                text_start_445="$(( ${m_idx_num_444} + 1 ))"
                command_383="$(__p="${part_440}"; printf "%s" "${__p:${text_start_445}}")"
                __status=$?
                text_part_446="${command_383}"
                if [ "$(( $([ "_${text_part_446}" == "_" ]; echo $?) && $(( ${remaining_width_438} > 0 )) ))" != 0 ]; then
                    truncate_text__1868_v0 "${text_part_446}" "${remaining_width_438}"
                    truncated_447="${ret_truncate_text1868_v0}"
                    result_437+="${truncated_447}"
                    get_visible_len__1867_v0 "${truncated_447}"
                    ret_get_visible_len1867_v0__220_40="${ret_get_visible_len1867_v0}"
                    remaining_width_438="$(( ${remaining_width_438} - ${ret_get_visible_len1867_v0__220_40} ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_440}" == "_" ]; echo $?) && $(( ${remaining_width_438} > 0 )) ))" != 0 ]; then
                    truncate_text__1868_v0 "${part_440}" "${remaining_width_438}"
                    truncated_448="${ret_truncate_text1868_v0}"
                    result_437+="${truncated_448}"
                    get_visible_len__1867_v0 "${truncated_448}"
                    remaining_width_438="$(( ${remaining_width_438} - ${ret_get_visible_len1867_v0__227_40} ))"
                fi
            fi
        fi
    done
    ret_truncate_ansi1869_v0="${result_437}"
    return 0
}

cutoff_text__1870_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__1867_v0 "${text}"
    visible_len_430="${ret_get_visible_len1867_v0}"
    if [ "$(( ${visible_len_430} <= ${max_width} ))" != 0 ]; then
        ret_cutoff_text1870_v0="${text}"
        return 0
    fi
    truncate_ansi__1869_v0 "${text}" "$(( ${max_width} - 3 ))"
    ret_truncate_ansi1869_v0__243_12="${ret_truncate_ansi1869_v0}"
    ret_cutoff_text1870_v0="${ret_truncate_ansi1869_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
render_tooltip__1871_v0() {
    local items=("${!1}")
    local total_len=$2
    local term_width=$3
    separator_454=" • "
    separator_len_455=3
    # Fast path: no truncation needed
    if [ "$(( ${total_len} <= ${term_width} ))" != 0 ]; then
        iter_456=0
        while :
        do
            __length_384=("${items[@]}")
            if [ "$(( ${iter_456} >= ${#__length_384[@]} ))" != 0 ]; then
                break
            elif [ "$(( ${iter_456} > 0 ))" != 0 ]; then
                eprintf_colored__1851_v0 "${separator_454}" 90
            fi
            colored__1852_v0 "${items[$(( ${iter_456} + 1 ))]}" 2
            ret_colored1852_v0__268_41="${ret_colored1852_v0}"
            array_385=("")
            eprintf__1850_v0 "${items[${iter_456}]}"" ""${ret_colored1852_v0__268_41}" array_385[@]
            iter_456="$(( ${iter_456} + 2 ))"
        done
    else
        # Slow path: truncate
        current_len_457=0
        first_458=1
        iter_459=0
        while :
        do
            __length_386=("${items[@]}")
            if [ "$(( ${iter_459} >= ${#__length_386[@]} ))" != 0 ]; then
                break
            fi
            key_460="${items[${iter_459}]}"
            action_461="${items[$(( ${iter_459} + 1 ))]}"
            __length_387="${key_460}"
            __length_388="${action_461}"
            part_len_462="$(( $(( ${#__length_387} + 1 )) + ${#__length_388} ))"
            needed_463="${part_len_462}"
            if [ "$(( ! ${first_458} ))" != 0 ]; then
                needed_463="$(( ${needed_463} + ${separator_len_455} ))"
            fi
            if [ "$(( $(( ${current_len_457} + ${needed_463} )) > ${term_width} ))" != 0 ]; then
                break
            fi
            if [ "$(( ! ${first_458} ))" != 0 ]; then
                eprintf_colored__1851_v0 "${separator_454}" 90
            fi
            colored__1852_v0 "${action_461}" 2
            ret_colored1852_v0__296_33="${ret_colored1852_v0}"
            array_389=("")
            eprintf__1850_v0 "${key_460}"" ""${ret_colored1852_v0__296_33}" array_389[@]
            current_len_457="$(( ${current_len_457} + ${needed_463} ))"
            first_458=0
            iter_459="$(( ${iter_459} + 2 ))"
        done
    fi
}

get_page_options__1921_v0() {
    local options=("${!1}")
    local page=$2
    local page_size=$3
    start_464="$(( ${page} * ${page_size} ))"
    end_465="$(( ${start_464} + ${page_size} ))"
    __length_390=("${options[@]}")
    if [ "$(( ${end_465} > ${#__length_390[@]} ))" != 0 ]; then
        __length_391=("${options[@]}")
        end_465="${#__length_391[@]}"
    fi
    result_466=()
    from="${start_464}"
    to="${end_465}"
    for i_467 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        result_466+=("${options[${i_467}]}")
    done
    ret_get_page_options1921_v0=("${result_466[@]}")
    return 0
}

render_choose_page__1923_v0() {
    local page_options=("${!1}")
    local sel=$2
    local cursor=$3
    local display_count=$4
    local term_width=$5
    __length_394="${cursor}"
    cursor_len_469="${#__length_394}"
    max_option_width_470="$(( $(( ${term_width} - ${cursor_len_469} )) - 1 ))"
    from=0
    __length_395=("${page_options[@]}")
    to="${#__length_395[@]}"
    for i_471 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        cutoff_text__1870_v0 "${page_options[${i_471}]}" "${max_option_width_470}"
        truncated_option_472="${ret_cutoff_text1870_v0}"
        if [ "$(( ${i_471} == ${sel} ))" != 0 ]; then
            colored_secondary__1833_v0 "${cursor}""${truncated_option_472}""
"
            ret_colored_secondary1833_v0__28_21="${ret_colored_secondary1833_v0}"
            array_396=("")
            eprintf__1850_v0 "${ret_colored_secondary1833_v0__28_21}" array_396[@]
        else
            print_blank__1856_v0 "${cursor_len_469}"
            array_397=("")
            eprintf__1850_v0 "${truncated_option_472}""
" array_397[@]
        fi
    done
    __length_398=("${page_options[@]}")
    remaining_slots_481="$(( ${display_count} - ${#__length_398[@]} ))"
    if [ "$(( ${remaining_slots_481} > 0 ))" != 0 ]; then
        # Amber bug gaurd
        from=0
        to="${remaining_slots_481}"
        for ____482 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
            array_399=("")
            eprintf__1850_v0 "\\x1b[K
" array_399[@]
        done
    fi
}

render_page_indicator__1925_v0() {
    local page=$1
    local total_pages=$2
    if [ "$(( ${total_pages} > 1 ))" != 0 ]; then
        array_400=("")
        eprintf__1850_v0 "\\x1b[9999D\\x1b[K" array_400[@]
        eprintf_colored__1851_v0 "Page $(( ${page} + 1 ))/${total_pages}" 90
        array_401=("")
        eprintf__1850_v0 "\\x1b[9999D" array_401[@]
    fi
}

xyl_choose__1926_v0() {
    local options=("${!1}")
    local cursor=$2
    local header=$3
    local page_size=$4
    __length_402=("${options[@]}")
    if [ "$(( ${#__length_402[@]} == 0 ))" != 0 ]; then
        eprintf_colored__1851_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    stty_lock__1809_v0 
    hide_cursor__1861_v0 
    term_width__1816_v0 
    term_width_423="${ret_term_width1816_v0}"
    term_height__1817_v0 
    term_height_424="${ret_term_height1817_v0}"
    max_page_size_425="$(( ${term_height_424} - $(if [ "$([ "_${header}" != "_" ]; echo $?)" != 0 ]; then echo 2; else echo 3; fi) ))"
    if [ "$(( ${page_size} > ${max_page_size_425} ))" != 0 ]; then
        page_size="${max_page_size_425}"
    fi
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__1870_v0 "${header}" "${term_width_423}"
        ret_cutoff_text1870_v0__107_17="${ret_cutoff_text1870_v0}"
        array_403=("")
        eprintf__1850_v0 "${ret_cutoff_text1870_v0__107_17}""
" array_403[@]
    fi
    __length_404=("${options[@]}")
    math_floor__420_v0 "$(( $(( $(( ${#__length_404[@]} + ${page_size} )) - 1 )) / ${page_size} ))"
    total_pages_449="${ret_math_floor420_v0}"
    current_page_450=0
    selected_451=0
    display_count_452="${page_size}"
    __length_405=("${options[@]}")
    if [ "$(( ${#__length_405[@]} < ${page_size} ))" != 0 ]; then
        __length_406=("${options[@]}")
        display_count_452="${#__length_406[@]}"
    fi
    new_line__1857_v0 "${display_count_452}"
    array_407=("")
    eprintf__1850_v0 "\\x1b[9999D" array_407[@]
    if [ "$(( ${total_pages_449} > 1 ))" != 0 ]; then
        eprintf_colored__1851_v0 "Page $(( ${current_page_450} + 1 ))/${total_pages_449}" 90
    fi
    new_line__1857_v0 1
    # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
    # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    if [ "$(( ${total_pages_449} > 1 ))" != 0 ]; then
        array_408=("↑↓" "select" "←→" "page" "enter" "confirm")
        render_tooltip__1871_v0 array_408[@] 36 "${term_width_423}"
    else
        array_409=("↑↓" "select" "enter" "confirm")
        render_tooltip__1871_v0 array_409[@] 25 "${term_width_423}"
    fi
    go_up__1858_v0 "$(( ${display_count_452} + 1 ))"
    array_410=("")
    eprintf__1850_v0 "\\x1b[9999D" array_410[@]
    get_page_options__1921_v0 options[@] "${current_page_450}" "${page_size}"
    page_options_468=("${ret_get_page_options1921_v0[@]}")
    render_choose_page__1923_v0 page_options_468[@] "${selected_451}" "${cursor}" "${display_count_452}" "${term_width_423}"
    while :
    do
        get_key__1848_v0 
        key_484="${ret_get_key1848_v0}"
        prev_selected_485="${selected_451}"
        prev_page_486="${current_page_450}"
        up_paged_487=0
        if [ "$(( $([ "_${key_484}" != "_UP" ]; echo $?) || $([ "_${key_484}" != "_k" ]; echo $?) ))" != 0 ]; then
            if [ "$(( $(( ${selected_451} == 0 )) && $(( ${total_pages_449} > 1 )) ))" != 0 ]; then
                if [ "$(( ${current_page_450} > 0 ))" != 0 ]; then
                    current_page_450="$(( ${current_page_450} - 1 ))"
                else
                    current_page_450="$(( ${total_pages_449} - 1 ))"
                fi
                up_paged_487=1
            elif [ "$(( ${selected_451} == 0 ))" != 0 ]; then
                __length_411=("${page_options_468[@]}")
                selected_451="$(( ${#__length_411[@]} - 1 ))"
            else
                selected_451="$(( ${selected_451} - 1 ))"
            fi
        elif [ "$(( $([ "_${key_484}" != "_DOWN" ]; echo $?) || $([ "_${key_484}" != "_j" ]; echo $?) ))" != 0 ]; then
            __length_412=("${page_options_468[@]}")
            if [ "$(( ${selected_451} == $(( ${#__length_412[@]} - 1 )) ))" != 0 ]; then
                if [ "$(( ${current_page_450} < $(( ${total_pages_449} - 1 )) ))" != 0 ]; then
                    current_page_450="$(( ${current_page_450} + 1 ))"
                    selected_451=0
                else
                    current_page_450=0
                    selected_451=0
                fi
            else
                selected_451="$(( ${selected_451} + 1 ))"
            fi
        elif [ "$(( $([ "_${key_484}" != "_LEFT" ]; echo $?) || $([ "_${key_484}" != "_h" ]; echo $?) ))" != 0 ]; then
            if [ "$(( ${current_page_450} > 0 ))" != 0 ]; then
                current_page_450="$(( ${current_page_450} - 1 ))"
                selected_451=0
            else
                selected_451=0
            fi
        elif [ "$(( $([ "_${key_484}" != "_RIGHT" ]; echo $?) || $([ "_${key_484}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "$(( ${current_page_450} < $(( ${total_pages_449} - 1 )) ))" != 0 ]; then
                current_page_450="$(( ${current_page_450} + 1 ))"
                selected_451=0
            else
                __length_413=("${page_options_468[@]}")
                selected_451="$(( ${#__length_413[@]} - 1 ))"
            fi
        elif [ "$([ "_${key_484}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
        __length_414="${cursor}"
        max_option_width_488="$(( $(( ${term_width_423} - ${#__length_414} )) - 1 ))"
        if [ "$(( ${prev_page_486} != ${current_page_450} ))" != 0 ]; then
            get_page_options__1921_v0 options[@] "${current_page_450}" "${page_size}"
            page_options_468=("${ret_get_page_options1921_v0[@]}")
            if [ "${up_paged_487}" != 0 ]; then
                __length_415=("${page_options_468[@]}")
                selected_451="$(( ${#__length_415[@]} - 1 ))"
            fi
            go_up__1858_v0 1
            remove_line__1854_v0 "$(( ${display_count_452} - 1 ))"
            remove_current_line__1855_v0 
            array_416=("")
            eprintf__1850_v0 "\\x1b[9999D" array_416[@]
            render_choose_page__1923_v0 page_options_468[@] "${selected_451}" "${cursor}" "${display_count_452}" "${term_width_423}"
            render_page_indicator__1925_v0 "${current_page_450}" "${total_pages_449}"
        elif [ "$(( ${prev_selected_485} != ${selected_451} ))" != 0 ]; then
            go_up__1858_v0 "$(( ${display_count_452} - ${prev_selected_485} ))"
            array_417=("")
            eprintf__1850_v0 "\\x1b[K" array_417[@]
            __length_418="${cursor}"
            print_blank__1856_v0 "${#__length_418}"
            cutoff_text__1870_v0 "${page_options_468[${prev_selected_485}]}" "${max_option_width_488}"
            ret_cutoff_text1870_v0__218_25="${ret_cutoff_text1870_v0}"
            array_419=("")
            eprintf__1850_v0 "${ret_cutoff_text1870_v0__218_25}" array_419[@]
            diff_491="$(( ${selected_451} - ${prev_selected_485} ))"
            go_up_or_down__1860_v0 "${diff_491}"
            array_420=("")
            eprintf__1850_v0 "\\x1b[9999D" array_420[@]
            array_421=("")
            eprintf__1850_v0 "\\x1b[K" array_421[@]
            cutoff_text__1870_v0 "${page_options_468[${selected_451}]}" "${max_option_width_488}"
            ret_cutoff_text1870_v0__224_52="${ret_cutoff_text1870_v0}"
            colored_secondary__1833_v0 "${cursor}""${ret_cutoff_text1870_v0__224_52}"
            ret_colored_secondary1833_v0__224_25="${ret_colored_secondary1833_v0}"
            array_422=("")
            eprintf__1850_v0 "${ret_colored_secondary1833_v0__224_25}" array_422[@]
            go_down__1859_v0 "$(( ${display_count_452} - ${selected_451} ))"
            array_423=("")
            eprintf__1850_v0 "\\x1b[9999D" array_423[@]
        fi
    done
    total_lines_492="$(( ${display_count_452} + 2 ))"
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_492="$(( ${total_lines_492} + 1 ))"
    fi
    go_down__1859_v0 1
    remove_line__1854_v0 "$(( ${total_lines_492} - 1 ))"
    remove_current_line__1855_v0 
    stty_unlock__1810_v0 
    show_cursor__1862_v0 
    global_selected_495="$(( $(( ${current_page_450} * ${page_size} )) + ${selected_451} ))"
    ret_xyl_choose1926_v0="${options[${global_selected_495}]}"
    return 0
}

format_entry_display__1930_v0() {
    local entry=("${!1}")
    name_407="${entry[0]}"
    file_type_408="${entry[1]}"
    if [ "$([ "_${file_type_408}" != "_d" ]; echo $?)" != 0 ]; then
        colored_primary__1633_v0 "/"
        ret_colored_primary1633_v0__13_23="${ret_colored_primary1633_v0}"
        ret_format_entry_display1930_v0="${name_407}""${ret_colored_primary1633_v0__13_23}"
        return 0
    fi
    if [ "$([ "_${file_type_408}" != "_l" ]; echo $?)" != 0 ]; then
        colored_accent__1635_v0 " > "
        ret_colored_accent1635_v0__16_23="${ret_colored_accent1635_v0}"
        colored_primary__1633_v0 "${entry[2]}"
        ret_colored_primary1633_v0__16_47="${ret_colored_primary1633_v0}"
        ret_format_entry_display1930_v0="${name_407}""${ret_colored_accent1635_v0__16_23}""${ret_colored_primary1633_v0__16_47}"
        return 0
    fi
    ret_format_entry_display1930_v0="${name_407}"
    return 0
}

xyl_file__1931_v0() {
    local start_path=$1
    local cursor=$2
    local show_hidden=$3
    local page_size=$4
    stty_lock__1610_v0 
    term_width__1617_v0 
    # Initialize current path
    current_path_388="${start_path}"
    if [ "$([ "_${current_path_388}" != "_" ]; echo $?)" != 0 ]; then
        get_cwd__1588_v0 
        current_path_388="${ret_get_cwd1588_v0}"
    fi
    normalize_path__1589_v0 "${current_path_388}"
    current_path_388="${ret_normalize_path1589_v0}"
    while :
    do
        colored_primary__1633_v0 "Loading files..."
        ret_colored_primary1633_v0__47_17="${ret_colored_primary1633_v0}"
        array_425=("")
        eprintf__1651_v0 "${ret_colored_primary1633_v0__47_17}" array_425[@]
        # Get directory entries
        get_directory_entries__1586_v0 "${current_path_388}"
        raw_entries_400=("${ret_get_directory_entries1586_v0[@]}")
        # Build options list and parallel entries list
        options_401=()
        entries_402=()
        # Add parent directory entry (..)
        if [ "$([ "_${current_path_388}" == "_/" ]; echo $?)" != 0 ]; then
            options_401+=("..")
            entries_402+=("..	d")
        fi
        for raw_entry_403 in "${raw_entries_400[@]}"; do
            parse_entry__1587_v0 "${raw_entry_403}"
            entry_404=("${ret_parse_entry1587_v0[@]}")
            name_405="${entry_404[0]}"
            # Skip hidden files if not showing them
            command_430="$(echo "${name_405}" | cut -c1)"
            __status=$?
            first_char_406="${command_430}"
            if [ "$(( $(( ! ${show_hidden} )) && $([ "_${first_char_406}" != "_." ]; echo $?) ))" != 0 ]; then
                continue
            fi
            format_entry_display__1930_v0 entry_404[@]
            ret_format_entry_display1930_v0__70_25="${ret_format_entry_display1930_v0}"
            options_401+=("${ret_format_entry_display1930_v0__70_25}")
            entries_402+=("${raw_entry_403}")
        done
        __length_433=("${entries_402[@]}")
        if [ "$(( ${#__length_433[@]} == 0 ))" != 0 ]; then
            eprintf_colored__1652_v0 "ERROR: Directory is empty or inaccessible.
" 31
            stty_unlock__1611_v0 
            ret_xyl_file1931_v0=""
            return 0
        fi
        # Use xyl_choose with current path as header
        colored_primary__1633_v0 "${current_path_388}"
        header_411="${ret_colored_primary1633_v0}"
        remove_current_line__1656_v0 
        xyl_choose__1926_v0 options_401[@] "${cursor}" "${header_411}" "${page_size}"
        selected_option_496="${ret_xyl_choose1926_v0}"
        # Find selected entry index
        selected_idx_497=-1
        from=0
        __length_434=("${options_401[@]}")
        to="${#__length_434[@]}"
        for i_498 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
            if [ "$([ "_${options_401[${i_498}]}" != "_${selected_option_496}" ]; echo $?)" != 0 ]; then
                selected_idx_497="${i_498}"
                break
            fi
        done
        if [ "$(( ${selected_idx_497} < 0 ))" != 0 ]; then
            ret_xyl_file1931_v0=""
            return 0
        fi
        parse_entry__1587_v0 "${entries_402[${selected_idx_497}]}"
        entry_499=("${ret_parse_entry1587_v0[@]}")
        name_500="${entry_499[0]}"
        file_type_501="${entry_499[1]}"
        if [ "$([ "_${name_500}" != "_.." ]; echo $?)" != 0 ]; then
            get_parent_dir__1592_v0 "${current_path_388}"
            current_path_388="${ret_get_parent_dir1592_v0}"
        elif [ "$([ "_${file_type_501}" != "_d" ]; echo $?)" != 0 ]; then
            path_join__1591_v0 "${current_path_388}" "${name_500}"
            current_path_388="${ret_path_join1591_v0}"
            normalize_path__1589_v0 "${current_path_388}"
            current_path_388="${ret_normalize_path1589_v0}"
        elif [ "$([ "_${file_type_501}" != "_l" ]; echo $?)" != 0 ]; then
            # Resolve symlink target path
            target_503="${entry_499[2]}"
            target_path_504="${target_503}"
            starts_with__23_v0 "${target_503}" "/"
            ret_starts_with23_v0__115_24="${ret_starts_with23_v0}"
            if [ "$(( ! ${ret_starts_with23_v0__115_24} ))" != 0 ]; then
                path_join__1591_v0 "${current_path_388}" "${target_503}"
                target_path_504="${ret_path_join1591_v0}"
            fi
            # Follow symlink if it points to a directory, otherwise return path
            is_directory__1590_v0 "${target_path_504}"
            ret_is_directory1590_v0__119_20="${ret_is_directory1590_v0}"
            if [ "${ret_is_directory1590_v0__119_20}" != 0 ]; then
                current_path_388="${target_path_504}"
                normalize_path__1589_v0 "${current_path_388}"
                current_path_388="${ret_normalize_path1589_v0}"
            else
                stty_unlock__1611_v0 
                path_join__1591_v0 "${current_path_388}" "${name_500}"
                ret_xyl_file1931_v0="${ret_path_join1591_v0}"
                return 0
            fi
        else
            stty_unlock__1611_v0 
            path_join__1591_v0 "${current_path_388}" "${name_500}"
            ret_xyl_file1931_v0="${ret_path_join1591_v0}"
            return 0
        fi
    done
    stty_unlock__1611_v0 
    ret_xyl_file1931_v0=""
    return 0
}

print_file_help__2007_v0() {
    echo "Usage: ./xylitol.sh file [<path>] [flags]"
    echo ""
    colored_primary__1633_v0 "file"
    ret_colored_primary1633_v0__7_12="${ret_colored_primary1633_v0}"
    array_435=("")
    printf__106_v0 "${ret_colored_primary1633_v0__7_12}" array_435[@]
    array_436=("")
    printf__106_v0 " - Browse filesystem and select a file." array_436[@]
    echo ""
    echo ""
    colored_secondary__1634_v0 "Arguments: "
    ret_colored_secondary1634_v0__11_12="${ret_colored_secondary1634_v0}"
    array_437=("")
    printf__106_v0 "${ret_colored_secondary1634_v0__11_12}""
" array_437[@]
    echo "  [<path>]               Starting directory path (default: current directory)"
    echo ""
    colored_secondary__1634_v0 "Flags: "
    ret_colored_secondary1634_v0__14_12="${ret_colored_secondary1634_v0}"
    array_438=("")
    printf__106_v0 "${ret_colored_secondary1634_v0__14_12}""
" array_438[@]
    echo "  -h, --help             Show this help message"
    echo "  -a, --all              Show hidden files"
    echo "  --cursor=\"<text>\"      Set the cursor text (default: '> ')"
    echo "  --path=\"<path>\"        Set the starting directory path"
    echo "  --page-size=<number>   Set the number of entries per page (default: 10)"
    echo ""
}

execute_file__2058_v0() {
    local parameters=("${!1}")
    cursor_359="> "
    start_path_360=""
    show_hidden_361=0
    page_size_362=10
    for param_363 in "${parameters[@]:2:9997}"; do
        match_regex__20_v0 "${param_363}" "^-h\$" 0
        ret_match_regex20_v0__14_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_363}" "^--help\$" 0
        ret_match_regex20_v0__14_43="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_363}" "^--cursor=.*\$" 0
        ret_match_regex20_v0__18_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_363}" "^--path=.*\$" 0
        ret_match_regex20_v0__22_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_363}" "^-a\$" 0
        ret_match_regex20_v0__26_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_363}" "^--all\$" 0
        ret_match_regex20_v0__26_43="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_363}" "^--page-size=.*\$" 0
        ret_match_regex20_v0__29_13="${ret_match_regex20_v0}"
        if [ "$(( ${ret_match_regex20_v0__14_13} || ${ret_match_regex20_v0__14_43} ))" != 0 ]; then
            print_file_help__2007_v0 
            exit 0
        elif [ "${ret_match_regex20_v0__18_13}" != 0 ]; then
            split__5_v0 "${param_363}" "="
            result_372=("${ret_split5_v0[@]}")
            cursor_359="${result_372[1]}"
        elif [ "${ret_match_regex20_v0__22_13}" != 0 ]; then
            split__5_v0 "${param_363}" "="
            result_373=("${ret_split5_v0[@]}")
            start_path_360="${result_373[1]}"
        elif [ "$(( ${ret_match_regex20_v0__26_13} || ${ret_match_regex20_v0__26_43} ))" != 0 ]; then
            show_hidden_361=1
        elif [ "${ret_match_regex20_v0__29_13}" != 0 ]; then
            split__5_v0 "${param_363}" "="
            result_374=("${ret_split5_v0[@]}")
            parse_int__14_v0 "${result_374[1]}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1652_v0 "ERROR: Invalid page-size value: ""${result_374[1]}""
" 31
                exit 1
            fi
            page_size_362="${ret_parse_int14_v0}"
        else
            # Treat as start path if not a flag
            start_path_360="${param_363}"
        fi
    done
    xyl_file__1931_v0 "${start_path_360}" "${cursor_359}" "${show_hidden_361}" "${page_size_362}"
    ret_execute_file2058_v0="${ret_xyl_file1931_v0}"
    return 0
}

# #!/usr/bin/env amber
__VERSION_57="0.1.0"
__AMBER_VERSION_58="0.5.1-alpha"
check_prerequirements__2060_v0() {
    echo "0" | bc -l > /dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        eprintf_colored__217_v0 "Error: " 91
        array_439=("")
        eprintf__216_v0 "bc is not installed. Please install bc to use xylitol.
" array_439[@]
        array_440=("")
        eprintf__216_v0 "  For Debian/Ubuntu: sudo apt install bc
" array_440[@]
        array_441=("")
        eprintf__216_v0 "  For Fedora: sudo dnf install bc
" array_441[@]
        array_442=("")
        eprintf__216_v0 "  For Arch Linux: sudo pacman -S bc
" array_442[@]
        ret_check_prerequirements2060_v0=0
        return 0
    fi
    ret_check_prerequirements2060_v0=1
    return 0
}

trap_cleanup__2061_v0() {
    trap 'printf "\x1b[?25h\x1b[0m" >&2; 
            stty echo < /dev/tty' EXIT
    __status=$?
}

declare -r args_59=("$0" "$@")
trap_cleanup__2061_v0 
check_prerequirements__2060_v0 
ret_check_prerequirements2060_v0__32_12="${ret_check_prerequirements2060_v0}"
if [ "$(( ! ${ret_check_prerequirements2060_v0__32_12} ))" != 0 ]; then
    exit 1
fi
__length_444=("${args_59[@]}")
if [ "$(( $(( $(( $(( ${#__length_444[@]} < 2 )) || $([ "_${args_59[1]}" != "_help" ]; echo $?) )) || $([ "_${args_59[1]}" != "_--help" ]; echo $?) )) || $([ "_${args_59[1]}" != "_-h" ]; echo $?) ))" != 0 ]; then
    print_help__362_v0 
elif [ "$([ "_${args_59[1]}" != "_input" ]; echo $?)" != 0 ]; then
    execute_input__724_v0 args_59[@]
    ret_execute_input724_v0__39_18="${ret_execute_input724_v0}"
    echo "${ret_execute_input724_v0__39_18}"
elif [ "$([ "_${args_59[1]}" != "_choose" ]; echo $?)" != 0 ]; then
    execute_choose__1090_v0 args_59[@]
    ret_execute_choose1090_v0__42_18="${ret_execute_choose1090_v0}"
    echo "${ret_execute_choose1090_v0__42_18}"
elif [ "$([ "_${args_59[1]}" != "_confirm" ]; echo $?)" != 0 ]; then
    execute_confirm__1468_v0 args_59[@]
    result_358="${ret_execute_confirm1468_v0}"
    if [ "$([ "_${result_358}" != "_yes" ]; echo $?)" != 0 ]; then
        exit 0
    else
        exit 1
    fi
elif [ "$([ "_${args_59[1]}" != "_file" ]; echo $?)" != 0 ]; then
    execute_file__2058_v0 args_59[@]
    ret_execute_file2058_v0__52_18="${ret_execute_file2058_v0}"
    echo "${ret_execute_file2058_v0__52_18}"
elif [ "$(( $(( $([ "_${args_59[1]}" != "_version" ]; echo $?) || $([ "_${args_59[1]}" != "_--version" ]; echo $?) )) || $([ "_${args_59[1]}" != "_-v" ]; echo $?) ))" != 0 ]; then
    colored_primary__198_v0 "xylitol.sh"
    ret_colored_primary198_v0__55_20="${ret_colored_primary198_v0}"
    array_445=("")
    printf__106_v0 "${ret_colored_primary198_v0__55_20}" array_445[@]
    array_446=("")
    printf__106_v0 " version: " array_446[@]
    colored_accent__200_v0 "${__VERSION_57}"
    ret_colored_accent200_v0__57_20="${ret_colored_accent200_v0}"
    array_447=("")
    printf__106_v0 "${ret_colored_accent200_v0__57_20}" array_447[@]
    echo ""
    printf_colored__215_v0 "written in Amber: " 90
    printf_colored__215_v0 "  ""${__AMBER_VERSION_58}" 90
else
    print_help__362_v0 
    printf_colored__215_v0 "ERROR: Unknown command '""${args_59[1]}""'" 91
fi
