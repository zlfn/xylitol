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
    result_470="${command_10}"
    ret_starts_with23_v0="$([ "_${result_470}" != "_1" ]; echo $?)"
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
get_supports_truecolor__189_v0() {
    env_var_get__98_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    config_67="${ret_env_var_get98_v0}"
    if [ "$([ "_${config_67}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_7="No"
        ret_get_supports_truecolor189_v0=0
        return 0
    fi
    env_var_get__98_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_7="No"
        ret_get_supports_truecolor189_v0=0
        return 0
    fi
    colorterm_68="${ret_env_var_get98_v0}"
    _supports_truecolor_7="$(if [ "$(( $([ "_${colorterm_68}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_68}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor189_v0="$([ "_${_supports_truecolor_7}" != "_Yes" ]; echo $?)"
    return 0
}

colored_rgb__190_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    if [ "$([ "_${_supports_truecolor_7}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb190_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_7}" != "_None" ]; echo $?)" != 0 ]; then
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
                    ret_inner_get_xylitol_colors192_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__115_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_62[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors192_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__116_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_62[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors192_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__117_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_62[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors192_v0=''
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
                    ret_inner_get_xylitol_colors192_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__128_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_64[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors192_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__129_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_64[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors192_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__130_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_64[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors192_v0=''
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
                    ret_inner_get_xylitol_colors192_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__141_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_66[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors192_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__142_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_66[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors192_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__143_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_66[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors192_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__144_21="${ret_parse_int14_v0}"
                _accent_color_11=("${ret_parse_int14_v0__141_21}" "${ret_parse_int14_v0__142_21}" "${ret_parse_int14_v0__143_21}" "${ret_parse_int14_v0__144_21}")
            fi
        fi
        _got_xylitol_colors_8=1
    fi
}

get_xylitol_colors__193_v0() {
    inner_get_xylitol_colors__192_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__112_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_8=1
}

colored_primary__194_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_8} ))" != 0 ]; then
        get_xylitol_colors__193_v0 
    fi
    colored_rgb__190_v0 "${message}" "${_primary_color_9[0]}" "${_primary_color_9[1]}" "${_primary_color_9[2]}" "${_primary_color_9[3]}"
    ret_colored_primary194_v0="${ret_colored_rgb190_v0}"
    return 0
}

colored_secondary__195_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_8} ))" != 0 ]; then
        get_xylitol_colors__193_v0 
    fi
    colored_rgb__190_v0 "${message}" "${_secondary_color_10[0]}" "${_secondary_color_10[1]}" "${_secondary_color_10[2]}" "${_secondary_color_10[3]}"
    ret_colored_secondary195_v0="${ret_colored_rgb190_v0}"
    return 0
}

colored_accent__196_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_8} ))" != 0 ]; then
        get_xylitol_colors__193_v0 
    fi
    colored_rgb__190_v0 "${message}" "${_accent_color_11[0]}" "${_accent_color_11[1]}" "${_accent_color_11[2]}" "${_accent_color_11[3]}"
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
_perl_disabled_12="$([ "_${command_41}" != "_No" ]; echo $?)"
command_42="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_13="$(( $(( ! ${_perl_disabled_12} )) && $([ "_${command_42}" != "_0" ]; echo $?) ))"
perl_get_cjk_width__472_v0() {
    local text=$1
    if [ "$(( ! ${_perl_available_13} ))" != 0 ]; then
        ret_perl_get_cjk_width472_v0=''
        return 1
    fi
    command_43="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width472_v0=''
        return "${__status}"
    fi
    width_str_102="${command_43}"
    parse_int__14_v0 "${width_str_102}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width472_v0=''
        return "${__status}"
    fi
    width_103="${ret_parse_int14_v0}"
    ret_perl_get_cjk_width472_v0="${width_103}"
    return 0
}

perl_truncate_cjk__473_v0() {
    local text=$1
    local max_width=$2
    if [ "$(( ! ${_perl_available_13} ))" != 0 ]; then
        ret_perl_truncate_cjk473_v0=''
        return 1
    fi
    command_44="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text}" ${max_width} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk473_v0=''
        return "${__status}"
    fi
    result_106="${command_44}"
    ret_perl_truncate_cjk473_v0="${result_106}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_14=0
_term_size_15=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
stty_lock__480_v0() {
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

stty_unlock__481_v0() {
    command_47="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_136="${command_47}"
    parse_int__14_v0 "${count_136}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_137="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_137} > 0 ))" != 0 ]; then
        count_num_137="$(( ${count_num_137} - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_137}
        __status=$?
        if [ "$(( ${count_num_137} == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

get_term_size__482_v0() {
    # Query terminal size with \x1b[18t, response format: \x1b[8;rows;colst
    command_48="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -rsd t _ignore height width < /dev/tty; echo "$height; $width")"
    __status=$?
    result_95="${command_48}"
    split__5_v0 "${result_95}" ";"
    parts_96=("${ret_split5_v0[@]}")
    __length_49=("${parts_96[@]}")
    if [ "$(( ${#__length_49[@]} != 2 ))" != 0 ]; then
        ret_get_term_size482_v0=''
        return 1
    fi
    parse_int__14_v0 "${parts_96[0]}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_term_size482_v0=''
        return "${__status}"
    fi
    rows_97="${ret_parse_int14_v0}"
    parse_int__14_v0 "${parts_96[1]}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_term_size482_v0=''
        return "${__status}"
    fi
    cols_98="${ret_parse_int14_v0}"
    _term_size_15=("${cols_98}" "${rows_97}")
    _got_term_size_14=1
}

term_width__484_v0() {
    if [ "$(( ! ${_got_term_size_14} ))" != 0 ]; then
        get_term_size__482_v0 
        __status=$?
    fi
    ret_term_width484_v0="${_term_size_15[0]}"
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
get_supports_truecolor__495_v0() {
    env_var_get__98_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    config_86="${ret_env_var_get98_v0}"
    if [ "$([ "_${config_86}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_16="No"
        ret_get_supports_truecolor495_v0=0
        return 0
    fi
    env_var_get__98_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_16="No"
        ret_get_supports_truecolor495_v0=0
        return 0
    fi
    colorterm_87="${ret_env_var_get98_v0}"
    _supports_truecolor_16="$(if [ "$(( $([ "_${colorterm_87}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_87}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor495_v0="$([ "_${_supports_truecolor_16}" != "_Yes" ]; echo $?)"
    return 0
}

colored_rgb__496_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    if [ "$([ "_${_supports_truecolor_16}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb496_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_16}" != "_None" ]; echo $?)" != 0 ]; then
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
            __length_54=("${parts_81[@]}")
            if [ "$(( ${#__length_54[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_81[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors498_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__115_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_81[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors498_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__116_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_81[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors498_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__117_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_81[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors498_v0=''
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
            __length_56=("${parts_83[@]}")
            if [ "$(( ${#__length_56[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_83[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors498_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__128_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_83[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors498_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__129_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_83[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors498_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__130_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_83[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors498_v0=''
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
            __length_58=("${parts_85[@]}")
            if [ "$(( ${#__length_58[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_85[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors498_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__141_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_85[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors498_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__142_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_85[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors498_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__143_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_85[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors498_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__144_21="${ret_parse_int14_v0}"
            fi
        fi
        _got_xylitol_colors_17=1
    fi
}

get_xylitol_colors__499_v0() {
    inner_get_xylitol_colors__498_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__112_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_17=1
}

colored_primary__500_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_17} ))" != 0 ]; then
        get_xylitol_colors__499_v0 
    fi
    colored_rgb__496_v0 "${message}" "${_primary_color_18[0]}" "${_primary_color_18[1]}" "${_primary_color_18[2]}" "${_primary_color_18[3]}"
    ret_colored_primary500_v0="${ret_colored_rgb496_v0}"
    return 0
}

colored_secondary__501_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_17} ))" != 0 ]; then
        get_xylitol_colors__499_v0 
    fi
    colored_rgb__496_v0 "${message}" "${_secondary_color_19[0]}" "${_secondary_color_19[1]}" "${_secondary_color_19[2]}" "${_secondary_color_19[3]}"
    ret_colored_secondary501_v0="${ret_colored_rgb496_v0}"
    return 0
}

# // IO Functions /////
get_char__515_v0() {
    command_60="$(read -n 1 key < /dev/tty; printf "%s" "$key")"
    __status=$?
    char_133="${command_60}"
    ret_get_char515_v0="${char_133}"
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
    for i_122 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
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
    has_escape_91="${command_67}"
    ret_has_ansi_escape531_v0="$([ "_${has_escape_91}" != "_1" ]; echo $?)"
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
    result_101="${command_70}"
    ret_is_all_ascii534_v0="$([ "_${result_101}" != "_0" ]; echo $?)"
    return 0
}

get_visible_len__535_v0() {
    local text=$1
    strip_ansi__533_v0 "${text}"
    stripped_100="${ret_strip_ansi533_v0}"
    # Check if text is all ASCII
    is_all_ascii__534_v0 "${stripped_100}"
    ret_is_all_ascii534_v0__140_12="${ret_is_all_ascii534_v0}"
    if [ "$(( ! ${ret_is_all_ascii534_v0__140_12} ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__472_v0 "${stripped_100}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            __length_71="${stripped_100}"
            ret_get_visible_len535_v0="${#__length_71}"
            return 0
        fi
        ret_get_visible_len535_v0="${ret_perl_get_cjk_width472_v0}"
        return 0
    else
        __length_72="${stripped_100}"
        ret_get_visible_len535_v0="${#__length_72}"
        return 0
    fi
}

truncate_text__536_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__535_v0 "${text}"
    visible_len_105="${ret_get_visible_len535_v0}"
    if [ "$(( ${visible_len_105} <= ${max_width} ))" != 0 ]; then
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
    starts_with_ansi_107="${command_74}"
    # Replace \x1b[ with newline, then split
    command_75="$(t="${text}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    replaced_108="${command_75}"
    split__5_v0 "${replaced_108}" "
"
    parts_109=("${ret_split5_v0[@]}")
    result_110=""
    remaining_width_111="${max_width}"
    from=0
    __length_76=("${parts_109[@]}")
    to="${#__length_76[@]}"
    for idx_112 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        part_113="${parts_109[${idx_112}]}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( ${idx_112} == 0 )) && $([ "_${starts_with_ansi_107}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_113}" == "_" ]; echo $?) && $(( ${remaining_width_111} > 0 )) ))" != 0 ]; then
                truncate_text__536_v0 "${part_113}" "${remaining_width_111}"
                truncated_114="${ret_truncate_text536_v0}"
                result_110+="${truncated_114}"
                get_visible_len__535_v0 "${truncated_114}"
                ret_get_visible_len535_v0__193_36="${ret_get_visible_len535_v0}"
                remaining_width_111="$(( ${remaining_width_111} - ${ret_get_visible_len535_v0__193_36} ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            command_77="$(__p="${part_113}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            m_idx_115="${command_77}"
            if [ "$([ "_${m_idx_115}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                command_78="$(__p="${part_113}"; printf "%s" "${__p:0:${m_idx_115}}")"
                __status=$?
                ansi_params_116="${command_78}"
                result_110+="\\x1b[""${ansi_params_116}""m"
                # Rest is text content
                parse_int__14_v0 "${m_idx_115}"
                __status=$?
                m_idx_num_117="${ret_parse_int14_v0}"
                text_start_118="$(( ${m_idx_num_117} + 1 ))"
                command_79="$(__p="${part_113}"; printf "%s" "${__p:${text_start_118}}")"
                __status=$?
                text_part_119="${command_79}"
                if [ "$(( $([ "_${text_part_119}" == "_" ]; echo $?) && $(( ${remaining_width_111} > 0 )) ))" != 0 ]; then
                    truncate_text__536_v0 "${text_part_119}" "${remaining_width_111}"
                    truncated_120="${ret_truncate_text536_v0}"
                    result_110+="${truncated_120}"
                    get_visible_len__535_v0 "${truncated_120}"
                    ret_get_visible_len535_v0__210_40="${ret_get_visible_len535_v0}"
                    remaining_width_111="$(( ${remaining_width_111} - ${ret_get_visible_len535_v0__210_40} ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_113}" == "_" ]; echo $?) && $(( ${remaining_width_111} > 0 )) ))" != 0 ]; then
                    truncate_text__536_v0 "${part_113}" "${remaining_width_111}"
                    truncated_121="${ret_truncate_text536_v0}"
                    result_110+="${truncated_121}"
                    get_visible_len__535_v0 "${truncated_121}"
                    remaining_width_111="$(( ${remaining_width_111} - ${ret_get_visible_len535_v0__217_40} ))"
                fi
            fi
        fi
    done
    ret_truncate_ansi537_v0="${result_110}"
    return 0
}

cutoff_text__538_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__535_v0 "${text}"
    visible_len_104="${ret_get_visible_len535_v0}"
    if [ "$(( ${visible_len_104} <= ${max_width} ))" != 0 ]; then
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
    separator_123=" • "
    separator_len_124=3
    # Fast path: no truncation needed
    if [ "$(( ${total_len} <= ${term_width} ))" != 0 ]; then
        iter_125=0
        while :
        do
            __length_80=("${items[@]}")
            if [ "$(( ${iter_125} >= ${#__length_80[@]} ))" != 0 ]; then
                break
            elif [ "$(( ${iter_125} > 0 ))" != 0 ]; then
                eprintf_colored__519_v0 "${separator_123}" 90
            fi
            colored__520_v0 "${items[$(( ${iter_125} + 1 ))]}" 2
            ret_colored520_v0__258_41="${ret_colored520_v0}"
            array_81=("")
            eprintf__518_v0 "${items[${iter_125}]}"" ""${ret_colored520_v0__258_41}" array_81[@]
            iter_125="$(( ${iter_125} + 2 ))"
        done
    else
        # Slow path: truncate
        current_len_126=0
        first_127=1
        iter_128=0
        while :
        do
            __length_82=("${items[@]}")
            if [ "$(( ${iter_128} >= ${#__length_82[@]} ))" != 0 ]; then
                break
            fi
            key_129="${items[${iter_128}]}"
            action_130="${items[$(( ${iter_128} + 1 ))]}"
            __length_83="${key_129}"
            __length_84="${action_130}"
            part_len_131="$(( $(( ${#__length_83} + 1 )) + ${#__length_84} ))"
            needed_132="${part_len_131}"
            if [ "$(( ! ${first_127} ))" != 0 ]; then
                needed_132="$(( ${needed_132} + ${separator_len_124} ))"
            fi
            if [ "$(( $(( ${current_len_126} + ${needed_132} )) > ${term_width} ))" != 0 ]; then
                break
            fi
            if [ "$(( ! ${first_127} ))" != 0 ]; then
                eprintf_colored__519_v0 "${separator_123}" 90
            fi
            colored__520_v0 "${action_130}" 2
            ret_colored520_v0__286_33="${ret_colored520_v0}"
            array_85=("")
            eprintf__518_v0 "${key_129}"" ""${ret_colored520_v0__286_33}" array_85[@]
            current_len_126="$(( ${current_len_126} + ${needed_132} ))"
            first_127=0
            iter_128="$(( ${iter_128} + 2 ))"
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
    term_width_99="${ret_term_width484_v0}"
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__538_v0 "${header}" "${term_width_99}"
        ret_cutoff_text538_v0__23_17="${ret_cutoff_text538_v0}"
        array_86=("")
        eprintf__518_v0 "${ret_cutoff_text538_v0__23_17}""
" array_86[@]
    fi
    new_line__525_v0 2
    # "enter submit" = 12
    array_87=("enter" "submit")
    render_tooltip__539_v0 array_87[@] 12 "${term_width_99}"
    go_up__526_v0 2
    array_88=("")
    eprintf__518_v0 "\\x1b[99999D" array_88[@]
    array_89=("")
    eprintf__518_v0 "${prompt}" array_89[@]
    eprintf_colored__519_v0 "${placeholder}" 90
    get_char__515_v0 
    char_134="${ret_get_char515_v0}"
    __length_90="${prompt}"
    remove__521_v0 "${#__length_90}"
    __length_91="${placeholder}"
    remove__521_v0 "$(( ${#__length_91} + 1 ))"
    text_135=""
    if [ "$(( ! ${password} ))" != 0 ]; then
        stty_unlock__481_v0 
        command_92="$(read -e -i ${char_134} -p "${prompt}" text < /dev/tty; printf "%s" "$text")"
        __status=$?
        text_135="${command_92}"
    else
        stty_unlock__481_v0 
        command_93="$(read -es -i ${char_134} -p "${prompt}" text < /dev/tty; printf "%s" "$text")"
        __status=$?
        text_135="${command_93}"
    fi
    stty_lock__480_v0 
    # Calculate how many lines the input takes up (prompt + text may wrap)
    get_visible_len__535_v0 "${prompt}""${text_135}"
    input_display_len_138="${ret_get_visible_len535_v0}"
    math_ceil__417_v0 "$(( ${input_display_len_138} / ${term_width_99} ))"
    input_lines_139="${ret_math_ceil417_v0}"
    if [ "$(( ${input_lines_139} < 3 ))" != 0 ]; then
        go_down__527_v0 "$(( 2 - ${input_lines_139} ))"
        remove_line__522_v0 2
        remove_current_line__523_v0 
    fi
    if [ "$(( ${input_lines_139} >= 3 ))" != 0 ]; then
        remove_line__522_v0 "${input_lines_139}"
    fi
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        remove_line__522_v0 1
        remove_current_line__523_v0 
    fi
    stty_unlock__481_v0 
    ret_xyl_input589_v0="${text_135}"
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
            print_input_help__665_v0 
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
    has_ansi_escape__531_v0 "${header_71}"
    ret_has_ansi_escape531_v0__34_42="${ret_has_ansi_escape531_v0}"
    escape_ansi__532_v0 "${header_71}"
    ret_escape_ansi532_v0__34_71="${ret_escape_ansi532_v0}"
    colored_primary__500_v0 "${header_71}"
    ret_colored_primary500_v0__34_109="${ret_colored_primary500_v0}"
    display_header_92="$(if [ "$(( $([ "_${header_71}" != "_" ]; echo $?) || ${ret_has_ansi_escape531_v0__34_42} ))" != 0 ]; then echo "${ret_escape_ansi532_v0__34_71}"; else echo "\\x1b[1m""${ret_colored_primary500_v0__34_109}"; fi)"
    xyl_input__589_v0 "${prompt_69}" "${placeholder_70}" "${display_header_92}" "${password_72}"
    ret_execute_input716_v0="${ret_xyl_input589_v0}"
    return 0
}

# Perl Extensions Utilities
command_97="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_21="$([ "_${command_97}" != "_No" ]; echo $?)"
command_98="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_22="$(( $(( ! ${_perl_disabled_21} )) && $([ "_${command_98}" != "_0" ]; echo $?) ))"
perl_get_cjk_width__825_v0() {
    local text=$1
    if [ "$(( ! ${_perl_available_22} ))" != 0 ]; then
        ret_perl_get_cjk_width825_v0=''
        return 1
    fi
    command_99="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width825_v0=''
        return "${__status}"
    fi
    width_str_174="${command_99}"
    parse_int__14_v0 "${width_str_174}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width825_v0=''
        return "${__status}"
    fi
    width_175="${ret_parse_int14_v0}"
    ret_perl_get_cjk_width825_v0="${width_175}"
    return 0
}

perl_truncate_cjk__826_v0() {
    local text=$1
    local max_width=$2
    if [ "$(( ! ${_perl_available_22} ))" != 0 ]; then
        ret_perl_truncate_cjk826_v0=''
        return 1
    fi
    command_100="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text}" ${max_width} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk826_v0=''
        return "${__status}"
    fi
    result_178="${command_100}"
    ret_perl_truncate_cjk826_v0="${result_178}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_23=0
_term_size_24=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
stty_lock__833_v0() {
    command_102="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_163="${command_102}"
    parse_int__14_v0 "${count_163}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_164="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_164} == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_164="$(( ${count_num_164} + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_164}
    __status=$?
}

stty_unlock__834_v0() {
    command_103="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_246="${command_103}"
    parse_int__14_v0 "${count_246}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_247="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_247} > 0 ))" != 0 ]; then
        count_num_247="$(( ${count_num_247} - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_247}
        __status=$?
        if [ "$(( ${count_num_247} == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

get_term_size__835_v0() {
    # Query terminal size with \x1b[18t, response format: \x1b[8;rows;colst
    command_104="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -rsd t _ignore height width < /dev/tty; echo "$height; $width")"
    __status=$?
    result_165="${command_104}"
    split__5_v0 "${result_165}" ";"
    parts_166=("${ret_split5_v0[@]}")
    __length_105=("${parts_166[@]}")
    if [ "$(( ${#__length_105[@]} != 2 ))" != 0 ]; then
        ret_get_term_size835_v0=''
        return 1
    fi
    parse_int__14_v0 "${parts_166[0]}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_term_size835_v0=''
        return "${__status}"
    fi
    rows_167="${ret_parse_int14_v0}"
    parse_int__14_v0 "${parts_166[1]}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_term_size835_v0=''
        return "${__status}"
    fi
    cols_168="${ret_parse_int14_v0}"
    _term_size_24=("${cols_168}" "${rows_167}")
    _got_term_size_23=1
}

term_width__837_v0() {
    if [ "$(( ! ${_got_term_size_23} ))" != 0 ]; then
        get_term_size__835_v0 
        __status=$?
    fi
    ret_term_width837_v0="${_term_size_24[0]}"
    return 0
}

term_height__838_v0() {
    if [ "$(( ! ${_got_term_size_23} ))" != 0 ]; then
        get_term_size__835_v0 
        __status=$?
    fi
    ret_term_height838_v0="${_term_size_24[1]}"
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
get_supports_truecolor__848_v0() {
    env_var_get__98_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    config_147="${ret_env_var_get98_v0}"
    if [ "$([ "_${config_147}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_25="No"
        ret_get_supports_truecolor848_v0=0
        return 0
    fi
    env_var_get__98_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_25="No"
        ret_get_supports_truecolor848_v0=0
        return 0
    fi
    colorterm_148="${ret_env_var_get98_v0}"
    _supports_truecolor_25="$(if [ "$(( $([ "_${colorterm_148}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_148}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor848_v0="$([ "_${_supports_truecolor_25}" != "_Yes" ]; echo $?)"
    return 0
}

colored_rgb__849_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    if [ "$([ "_${_supports_truecolor_25}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb849_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_25}" != "_None" ]; echo $?)" != 0 ]; then
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
    if [ "$(( ! ${_got_xylitol_colors_26} ))" != 0 ]; then
        env_var_get__98_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        primary_env_141="${ret_env_var_get98_v0}"
        if [ "$([ "_${primary_env_141}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${primary_env_141}" ";"
            parts_142=("${ret_split5_v0[@]}")
            __length_110=("${parts_142[@]}")
            if [ "$(( ${#__length_110[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_142[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__115_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_142[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__116_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_142[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__117_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_142[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
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
        secondary_env_143="${ret_env_var_get98_v0}"
        if [ "$([ "_${secondary_env_143}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${secondary_env_143}" ";"
            parts_144=("${ret_split5_v0[@]}")
            __length_112=("${parts_144[@]}")
            if [ "$(( ${#__length_112[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_144[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__128_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_144[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__129_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_144[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__130_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_144[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
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
        accent_env_145="${ret_env_var_get98_v0}"
        if [ "$([ "_${accent_env_145}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${accent_env_145}" ";"
            parts_146=("${ret_split5_v0[@]}")
            __length_114=("${parts_146[@]}")
            if [ "$(( ${#__length_114[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_146[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__141_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_146[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__142_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_146[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__143_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_146[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__144_21="${ret_parse_int14_v0}"
            fi
        fi
        _got_xylitol_colors_26=1
    fi
}

get_xylitol_colors__852_v0() {
    inner_get_xylitol_colors__851_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__112_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_26=1
}

colored_primary__853_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_26} ))" != 0 ]; then
        get_xylitol_colors__852_v0 
    fi
    colored_rgb__849_v0 "${message}" "${_primary_color_27[0]}" "${_primary_color_27[1]}" "${_primary_color_27[2]}" "${_primary_color_27[3]}"
    ret_colored_primary853_v0="${ret_colored_rgb849_v0}"
    return 0
}

colored_secondary__854_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_26} ))" != 0 ]; then
        get_xylitol_colors__852_v0 
    fi
    colored_rgb__849_v0 "${message}" "${_secondary_color_28[0]}" "${_secondary_color_28[1]}" "${_secondary_color_28[2]}" "${_secondary_color_28[3]}"
    ret_colored_secondary854_v0="${ret_colored_rgb849_v0}"
    return 0
}

# // IO Functions /////
get_key__869_v0() {
    command_116="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    var_226="${command_116}"
    if [ "$([ "_${var_226}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key869_v0="UP"
        return 0
    elif [ "$([ "_${var_226}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key869_v0="DOWN"
        return 0
    elif [ "$([ "_${var_226}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key869_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_226}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key869_v0="LEFT"
        return 0
    elif [ "$([ "_${var_226}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key869_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_226}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key869_v0="INPUT"
        return 0
    else
        ret_get_key869_v0="${var_226}"
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
    for i_198 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
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
    has_escape_161="${command_125}"
    ret_has_ansi_escape884_v0="$([ "_${has_escape_161}" != "_1" ]; echo $?)"
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
    result_173="${command_128}"
    ret_is_all_ascii887_v0="$([ "_${result_173}" != "_0" ]; echo $?)"
    return 0
}

get_visible_len__888_v0() {
    local text=$1
    strip_ansi__886_v0 "${text}"
    stripped_172="${ret_strip_ansi886_v0}"
    # Check if text is all ASCII
    is_all_ascii__887_v0 "${stripped_172}"
    ret_is_all_ascii887_v0__140_12="${ret_is_all_ascii887_v0}"
    if [ "$(( ! ${ret_is_all_ascii887_v0__140_12} ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__825_v0 "${stripped_172}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            __length_129="${stripped_172}"
            ret_get_visible_len888_v0="${#__length_129}"
            return 0
        fi
        ret_get_visible_len888_v0="${ret_perl_get_cjk_width825_v0}"
        return 0
    else
        __length_130="${stripped_172}"
        ret_get_visible_len888_v0="${#__length_130}"
        return 0
    fi
}

truncate_text__889_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__888_v0 "${text}"
    visible_len_177="${ret_get_visible_len888_v0}"
    if [ "$(( ${visible_len_177} <= ${max_width} ))" != 0 ]; then
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
    starts_with_ansi_179="${command_132}"
    # Replace \x1b[ with newline, then split
    command_133="$(t="${text}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    replaced_180="${command_133}"
    split__5_v0 "${replaced_180}" "
"
    parts_181=("${ret_split5_v0[@]}")
    result_182=""
    remaining_width_183="${max_width}"
    from=0
    __length_134=("${parts_181[@]}")
    to="${#__length_134[@]}"
    for idx_184 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        part_185="${parts_181[${idx_184}]}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( ${idx_184} == 0 )) && $([ "_${starts_with_ansi_179}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_185}" == "_" ]; echo $?) && $(( ${remaining_width_183} > 0 )) ))" != 0 ]; then
                truncate_text__889_v0 "${part_185}" "${remaining_width_183}"
                truncated_186="${ret_truncate_text889_v0}"
                result_182+="${truncated_186}"
                get_visible_len__888_v0 "${truncated_186}"
                ret_get_visible_len888_v0__193_36="${ret_get_visible_len888_v0}"
                remaining_width_183="$(( ${remaining_width_183} - ${ret_get_visible_len888_v0__193_36} ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            command_135="$(__p="${part_185}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            m_idx_187="${command_135}"
            if [ "$([ "_${m_idx_187}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                command_136="$(__p="${part_185}"; printf "%s" "${__p:0:${m_idx_187}}")"
                __status=$?
                ansi_params_188="${command_136}"
                result_182+="\\x1b[""${ansi_params_188}""m"
                # Rest is text content
                parse_int__14_v0 "${m_idx_187}"
                __status=$?
                m_idx_num_189="${ret_parse_int14_v0}"
                text_start_190="$(( ${m_idx_num_189} + 1 ))"
                command_137="$(__p="${part_185}"; printf "%s" "${__p:${text_start_190}}")"
                __status=$?
                text_part_191="${command_137}"
                if [ "$(( $([ "_${text_part_191}" == "_" ]; echo $?) && $(( ${remaining_width_183} > 0 )) ))" != 0 ]; then
                    truncate_text__889_v0 "${text_part_191}" "${remaining_width_183}"
                    truncated_192="${ret_truncate_text889_v0}"
                    result_182+="${truncated_192}"
                    get_visible_len__888_v0 "${truncated_192}"
                    ret_get_visible_len888_v0__210_40="${ret_get_visible_len888_v0}"
                    remaining_width_183="$(( ${remaining_width_183} - ${ret_get_visible_len888_v0__210_40} ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_185}" == "_" ]; echo $?) && $(( ${remaining_width_183} > 0 )) ))" != 0 ]; then
                    truncate_text__889_v0 "${part_185}" "${remaining_width_183}"
                    truncated_193="${ret_truncate_text889_v0}"
                    result_182+="${truncated_193}"
                    get_visible_len__888_v0 "${truncated_193}"
                    remaining_width_183="$(( ${remaining_width_183} - ${ret_get_visible_len888_v0__217_40} ))"
                fi
            fi
        fi
    done
    ret_truncate_ansi890_v0="${result_182}"
    return 0
}

cutoff_text__891_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__888_v0 "${text}"
    visible_len_176="${ret_get_visible_len888_v0}"
    if [ "$(( ${visible_len_176} <= ${max_width} ))" != 0 ]; then
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
    separator_199=" • "
    separator_len_200=3
    # Fast path: no truncation needed
    if [ "$(( ${total_len} <= ${term_width} ))" != 0 ]; then
        iter_201=0
        while :
        do
            __length_138=("${items[@]}")
            if [ "$(( ${iter_201} >= ${#__length_138[@]} ))" != 0 ]; then
                break
            elif [ "$(( ${iter_201} > 0 ))" != 0 ]; then
                eprintf_colored__872_v0 "${separator_199}" 90
            fi
            colored__873_v0 "${items[$(( ${iter_201} + 1 ))]}" 2
            ret_colored873_v0__258_41="${ret_colored873_v0}"
            array_139=("")
            eprintf__871_v0 "${items[${iter_201}]}"" ""${ret_colored873_v0__258_41}" array_139[@]
            iter_201="$(( ${iter_201} + 2 ))"
        done
    else
        # Slow path: truncate
        current_len_202=0
        first_203=1
        iter_204=0
        while :
        do
            __length_140=("${items[@]}")
            if [ "$(( ${iter_204} >= ${#__length_140[@]} ))" != 0 ]; then
                break
            fi
            key_205="${items[${iter_204}]}"
            action_206="${items[$(( ${iter_204} + 1 ))]}"
            __length_141="${key_205}"
            __length_142="${action_206}"
            part_len_207="$(( $(( ${#__length_141} + 1 )) + ${#__length_142} ))"
            needed_208="${part_len_207}"
            if [ "$(( ! ${first_203} ))" != 0 ]; then
                needed_208="$(( ${needed_208} + ${separator_len_200} ))"
            fi
            if [ "$(( $(( ${current_len_202} + ${needed_208} )) > ${term_width} ))" != 0 ]; then
                break
            fi
            if [ "$(( ! ${first_203} ))" != 0 ]; then
                eprintf_colored__872_v0 "${separator_199}" 90
            fi
            colored__873_v0 "${action_206}" 2
            ret_colored873_v0__286_33="${ret_colored873_v0}"
            array_143=("")
            eprintf__871_v0 "${key_205}"" ""${ret_colored873_v0__286_33}" array_143[@]
            current_len_202="$(( ${current_len_202} + ${needed_208} ))"
            first_203=0
            iter_204="$(( ${iter_204} + 2 ))"
        done
    fi
}

get_page_options__942_v0() {
    local options=("${!1}")
    local page=$2
    local page_size=$3
    start_211="$(( ${page} * ${page_size} ))"
    end_212="$(( ${start_211} + ${page_size} ))"
    __length_144=("${options[@]}")
    if [ "$(( ${end_212} > ${#__length_144[@]} ))" != 0 ]; then
        __length_145=("${options[@]}")
        end_212="${#__length_145[@]}"
    fi
    result_213=()
    from="${start_211}"
    to="${end_212}"
    for i_214 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        result_213+=("${options[${i_214}]}")
    done
    ret_get_page_options942_v0=("${result_213[@]}")
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
    cursor_len_257="${#__length_148}"
    max_option_width_258="$(( $(( ${term_width} - ${cursor_len_257} )) - 1 ))"
    from=0
    __length_149=("${page_options[@]}")
    to="${#__length_149[@]}"
    for i_259 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        cutoff_text__891_v0 "${page_options[${i_259}]}" "${max_option_width_258}"
        truncated_option_260="${ret_cutoff_text891_v0}"
        if [ "$(( ${i_259} == ${sel} ))" != 0 ]; then
            colored_secondary__854_v0 "${cursor}""${truncated_option_260}""
"
            ret_colored_secondary854_v0__28_21="${ret_colored_secondary854_v0}"
            array_150=("")
            eprintf__871_v0 "${ret_colored_secondary854_v0__28_21}" array_150[@]
        else
            print_blank__877_v0 "${cursor_len_257}"
            array_151=("")
            eprintf__871_v0 "${truncated_option_260}""
" array_151[@]
        fi
    done
    __length_152=("${page_options[@]}")
    remaining_slots_261="$(( ${display_count} - ${#__length_152[@]} ))"
    if [ "$(( ${remaining_slots_261} > 0 ))" != 0 ]; then
        # Amber bug gaurd
        from=0
        to="${remaining_slots_261}"
        for ____262 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
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
    cursor_len_217="${#__length_154}"
    check_mark_len_218=2
    # "✓ " or "• "
    max_option_width_219="$(( $(( $(( ${term_width} - ${cursor_len_217} )) - ${check_mark_len_218} )) - 1 ))"
    from=0
    __length_155=("${page_options[@]}")
    to="${#__length_155[@]}"
    for i_220 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        global_idx_221="$(( ${page_start} + ${i_220} ))"
        check_mark_222="$(if [ "${checked[${global_idx_221}]}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__891_v0 "${page_options[${i_220}]}" "${max_option_width_219}"
        truncated_option_223="${ret_cutoff_text891_v0}"
        if [ "$(( ${i_220} == ${sel} ))" != 0 ]; then
            colored_secondary__854_v0 "${cursor}""${check_mark_222}""${truncated_option_223}""
"
            ret_colored_secondary854_v0__51_31="${ret_colored_secondary854_v0}"
            array_156=("")
            eprintf__871_v0 "${ret_colored_secondary854_v0__51_31}" array_156[@]
        elif [ "${checked[${global_idx_221}]}" != 0 ]; then
            print_blank__877_v0 "${cursor_len_217}"
            colored_secondary__854_v0 "${check_mark_222}""${truncated_option_223}""
"
            ret_colored_secondary854_v0__54_25="${ret_colored_secondary854_v0}"
            array_157=("")
            eprintf__871_v0 "${ret_colored_secondary854_v0__54_25}" array_157[@]
        else
            print_blank__877_v0 "${cursor_len_217}"
            array_158=("")
            eprintf__871_v0 "${check_mark_222}""${truncated_option_223}""
" array_158[@]
        fi
    done
    __length_159=("${page_options[@]}")
    remaining_slots_224="$(( ${display_count} - ${#__length_159[@]} ))"
    if [ "$(( ${remaining_slots_224} > 0 ))" != 0 ]; then
        # Amber bug guard
        from=0
        to="${remaining_slots_224}"
        for ____225 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
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
    term_width_249="${ret_term_width837_v0}"
    term_height__838_v0 
    term_height_250="${ret_term_height838_v0}"
    max_page_size_251="$(( ${term_height_250} - $(if [ "$([ "_${header}" != "_" ]; echo $?)" != 0 ]; then echo 2; else echo 3; fi) ))"
    if [ "$(( ${page_size} > ${max_page_size_251} ))" != 0 ]; then
        page_size="${max_page_size_251}"
    fi
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__891_v0 "${header}" "${term_width_249}"
        ret_cutoff_text891_v0__107_17="${ret_cutoff_text891_v0}"
        array_164=("")
        eprintf__871_v0 "${ret_cutoff_text891_v0__107_17}""
" array_164[@]
    fi
    __length_165=("${options[@]}")
    math_floor__416_v0 "$(( $(( $(( ${#__length_165[@]} + ${page_size} )) - 1 )) / ${page_size} ))"
    total_pages_252="${ret_math_floor416_v0}"
    current_page_253=0
    selected_254=0
    display_count_255="${page_size}"
    __length_166=("${options[@]}")
    if [ "$(( ${#__length_166[@]} < ${page_size} ))" != 0 ]; then
        __length_167=("${options[@]}")
        display_count_255="${#__length_167[@]}"
    fi
    new_line__878_v0 "${display_count_255}"
    array_168=("")
    eprintf__871_v0 "\\x1b[9999D" array_168[@]
    if [ "$(( ${total_pages_252} > 1 ))" != 0 ]; then
        eprintf_colored__872_v0 "Page $(( ${current_page_253} + 1 ))/${total_pages_252}" 90
    fi
    new_line__878_v0 1
    # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
    # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    if [ "$(( ${total_pages_252} > 1 ))" != 0 ]; then
        array_169=("↑↓" "select" "←→" "page" "enter" "confirm")
        render_tooltip__892_v0 array_169[@] 36 "${term_width_249}"
    else
        array_170=("↑↓" "select" "enter" "confirm")
        render_tooltip__892_v0 array_170[@] 25 "${term_width_249}"
    fi
    go_up__879_v0 "$(( ${display_count_255} + 1 ))"
    array_171=("")
    eprintf__871_v0 "\\x1b[9999D" array_171[@]
    get_page_options__942_v0 options[@] "${current_page_253}" "${page_size}"
    page_options_256=("${ret_get_page_options942_v0[@]}")
    render_choose_page__944_v0 page_options_256[@] "${selected_254}" "${cursor}" "${display_count_255}" "${term_width_249}"
    while :
    do
        get_key__869_v0 
        key_263="${ret_get_key869_v0}"
        prev_selected_264="${selected_254}"
        prev_page_265="${current_page_253}"
        up_paged_266=0
        if [ "$(( $([ "_${key_263}" != "_UP" ]; echo $?) || $([ "_${key_263}" != "_k" ]; echo $?) ))" != 0 ]; then
            if [ "$(( $(( ${selected_254} == 0 )) && $(( ${total_pages_252} > 1 )) ))" != 0 ]; then
                if [ "$(( ${current_page_253} > 0 ))" != 0 ]; then
                    current_page_253="$(( ${current_page_253} - 1 ))"
                else
                    current_page_253="$(( ${total_pages_252} - 1 ))"
                fi
                up_paged_266=1
            elif [ "$(( ${selected_254} == 0 ))" != 0 ]; then
                __length_172=("${page_options_256[@]}")
                selected_254="$(( ${#__length_172[@]} - 1 ))"
            else
                selected_254="$(( ${selected_254} - 1 ))"
            fi
        elif [ "$(( $([ "_${key_263}" != "_DOWN" ]; echo $?) || $([ "_${key_263}" != "_j" ]; echo $?) ))" != 0 ]; then
            __length_173=("${page_options_256[@]}")
            if [ "$(( ${selected_254} == $(( ${#__length_173[@]} - 1 )) ))" != 0 ]; then
                if [ "$(( ${current_page_253} < $(( ${total_pages_252} - 1 )) ))" != 0 ]; then
                    current_page_253="$(( ${current_page_253} + 1 ))"
                    selected_254=0
                else
                    current_page_253=0
                    selected_254=0
                fi
            else
                selected_254="$(( ${selected_254} + 1 ))"
            fi
        elif [ "$(( $([ "_${key_263}" != "_LEFT" ]; echo $?) || $([ "_${key_263}" != "_h" ]; echo $?) ))" != 0 ]; then
            if [ "$(( ${current_page_253} > 0 ))" != 0 ]; then
                current_page_253="$(( ${current_page_253} - 1 ))"
                selected_254=0
            else
                selected_254=0
            fi
        elif [ "$(( $([ "_${key_263}" != "_RIGHT" ]; echo $?) || $([ "_${key_263}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "$(( ${current_page_253} < $(( ${total_pages_252} - 1 )) ))" != 0 ]; then
                current_page_253="$(( ${current_page_253} + 1 ))"
                selected_254=0
            else
                __length_174=("${page_options_256[@]}")
                selected_254="$(( ${#__length_174[@]} - 1 ))"
            fi
        elif [ "$([ "_${key_263}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
        __length_175="${cursor}"
        max_option_width_267="$(( $(( ${term_width_249} - ${#__length_175} )) - 1 ))"
        if [ "$(( ${prev_page_265} != ${current_page_253} ))" != 0 ]; then
            get_page_options__942_v0 options[@] "${current_page_253}" "${page_size}"
            page_options_256=("${ret_get_page_options942_v0[@]}")
            if [ "${up_paged_266}" != 0 ]; then
                __length_176=("${page_options_256[@]}")
                selected_254="$(( ${#__length_176[@]} - 1 ))"
            fi
            go_up__879_v0 1
            remove_line__875_v0 "$(( ${display_count_255} - 1 ))"
            remove_current_line__876_v0 
            array_177=("")
            eprintf__871_v0 "\\x1b[9999D" array_177[@]
            render_choose_page__944_v0 page_options_256[@] "${selected_254}" "${cursor}" "${display_count_255}" "${term_width_249}"
            render_page_indicator__946_v0 "${current_page_253}" "${total_pages_252}"
        elif [ "$(( ${prev_selected_264} != ${selected_254} ))" != 0 ]; then
            go_up__879_v0 "$(( ${display_count_255} - ${prev_selected_264} ))"
            array_178=("")
            eprintf__871_v0 "\\x1b[K" array_178[@]
            __length_179="${cursor}"
            print_blank__877_v0 "${#__length_179}"
            cutoff_text__891_v0 "${page_options_256[${prev_selected_264}]}" "${max_option_width_267}"
            ret_cutoff_text891_v0__218_25="${ret_cutoff_text891_v0}"
            array_180=("")
            eprintf__871_v0 "${ret_cutoff_text891_v0__218_25}" array_180[@]
            diff_268="$(( ${selected_254} - ${prev_selected_264} ))"
            go_up_or_down__881_v0 "${diff_268}"
            array_181=("")
            eprintf__871_v0 "\\x1b[9999D" array_181[@]
            array_182=("")
            eprintf__871_v0 "\\x1b[K" array_182[@]
            cutoff_text__891_v0 "${page_options_256[${selected_254}]}" "${max_option_width_267}"
            ret_cutoff_text891_v0__224_52="${ret_cutoff_text891_v0}"
            colored_secondary__854_v0 "${cursor}""${ret_cutoff_text891_v0__224_52}"
            ret_colored_secondary854_v0__224_25="${ret_colored_secondary854_v0}"
            array_183=("")
            eprintf__871_v0 "${ret_colored_secondary854_v0__224_25}" array_183[@]
            go_down__880_v0 "$(( ${display_count_255} - ${selected_254} ))"
            array_184=("")
            eprintf__871_v0 "\\x1b[9999D" array_184[@]
        fi
    done
    total_lines_269="$(( ${display_count_255} + 2 ))"
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_269="$(( ${total_lines_269} + 1 ))"
    fi
    go_down__880_v0 1
    remove_line__875_v0 "$(( ${total_lines_269} - 1 ))"
    remove_current_line__876_v0 
    stty_unlock__834_v0 
    show_cursor__883_v0 
    global_selected_270="$(( $(( ${current_page_253} * ${page_size} )) + ${selected_254} ))"
    ret_xyl_choose947_v0="${options[${global_selected_270}]}"
    return 0
}

count_checked__948_v0() {
    local checked=("${!1}")
    count_232=0
    for c_233 in "${checked[@]}"; do
        if [ "${c_233}" != 0 ]; then
            count_232="$(( ${count_232} + 1 ))"
        fi
    done
    ret_count_checked948_v0="${count_232}"
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
    term_width_169="${ret_term_width837_v0}"
    term_height__838_v0 
    term_height_170="${ret_term_height838_v0}"
    max_page_size_171="$(( ${term_height_170} - $(if [ "$([ "_${header}" != "_" ]; echo $?)" != 0 ]; then echo 2; else echo 3; fi) ))"
    if [ "$(( ${page_size} > ${max_page_size_171} ))" != 0 ]; then
        page_size="${max_page_size_171}"
    fi
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__891_v0 "${header}" "${term_width_169}"
        ret_cutoff_text891_v0__288_17="${ret_cutoff_text891_v0}"
        array_187=("")
        eprintf__871_v0 "${ret_cutoff_text891_v0__288_17}""
" array_187[@]
    fi
    __length_188=("${options[@]}")
    math_floor__416_v0 "$(( $(( $(( ${#__length_188[@]} + ${page_size} )) - 1 )) / ${page_size} ))"
    total_pages_194="${ret_math_floor416_v0}"
    current_page_195=0
    selected_196=0
    display_count_197="${page_size}"
    __length_189=("${options[@]}")
    if [ "$(( ${#__length_189[@]} < ${page_size} ))" != 0 ]; then
        __length_190=("${options[@]}")
        display_count_197="${#__length_190[@]}"
    fi
    new_line__878_v0 "${display_count_197}"
    array_191=("")
    eprintf__871_v0 "\\x1b[9999D" array_191[@]
    if [ "$(( ${total_pages_194} > 1 ))" != 0 ]; then
        eprintf_colored__872_v0 "Page $(( ${current_page_195} + 1 ))/${total_pages_194}" 90
    fi
    new_line__878_v0 1
    # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
    # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
    # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
    if [ "$(( $(( ${total_pages_194} > 1 )) && $(( ${limit} < 0 )) ))" != 0 ]; then
        array_192=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
        render_tooltip__892_v0 array_192[@] 55 "${term_width_169}"
    elif [ "$(( ${total_pages_194} > 1 ))" != 0 ]; then
        array_193=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
        render_tooltip__892_v0 array_193[@] 47 "${term_width_169}"
    elif [ "$(( ${limit} < 0 ))" != 0 ]; then
        array_194=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
        render_tooltip__892_v0 array_194[@] 44 "${term_width_169}"
    else
        array_195=("↑↓" "select" "x" "toggle" "enter" "confirm")
        render_tooltip__892_v0 array_195[@] 36 "${term_width_169}"
    fi
    go_up__879_v0 "$(( ${display_count_197} + 1 ))"
    array_196=("")
    eprintf__871_v0 "\\x1b[9999D" array_196[@]
    checked_209=()
    from=0
    __length_198=("${options[@]}")
    to="${#__length_198[@]}"
    for ____210 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        checked_209+=(0)
    done
    get_page_options__942_v0 options[@] "${current_page_195}" "${page_size}"
    page_options_215=("${ret_get_page_options942_v0[@]}")
    get_page_start__943_v0 "${current_page_195}" "${page_size}"
    page_start_216="${ret_get_page_start943_v0}"
    render_multi_choose_page__945_v0 page_options_215[@] checked_209[@] "${page_start_216}" "${selected_196}" "${cursor}" "${display_count_197}" "${term_width_169}"
    while :
    do
        get_key__869_v0 
        key_227="${ret_get_key869_v0}"
        prev_selected_228="${selected_196}"
        prev_page_229="${current_page_195}"
        global_selected_230="$(( ${page_start_216} + ${selected_196} ))"
        up_paged_231=0
        if [ "$(( $([ "_${key_227}" != "_UP" ]; echo $?) || $([ "_${key_227}" != "_k" ]; echo $?) ))" != 0 ]; then
            if [ "$(( $(( ${selected_196} == 0 )) && $(( ${total_pages_194} > 1 )) ))" != 0 ]; then
                if [ "$(( ${current_page_195} > 0 ))" != 0 ]; then
                    current_page_195="$(( ${current_page_195} - 1 ))"
                else
                    current_page_195="$(( ${total_pages_194} - 1 ))"
                fi
                up_paged_231=1
            elif [ "$(( ${selected_196} == 0 ))" != 0 ]; then
                __length_200=("${page_options_215[@]}")
                selected_196="$(( ${#__length_200[@]} - 1 ))"
            else
                selected_196="$(( ${selected_196} - 1 ))"
            fi
        elif [ "$(( $([ "_${key_227}" != "_DOWN" ]; echo $?) || $([ "_${key_227}" != "_j" ]; echo $?) ))" != 0 ]; then
            __length_201=("${page_options_215[@]}")
            if [ "$(( ${selected_196} == $(( ${#__length_201[@]} - 1 )) ))" != 0 ]; then
                if [ "$(( ${current_page_195} < $(( ${total_pages_194} - 1 )) ))" != 0 ]; then
                    current_page_195="$(( ${current_page_195} + 1 ))"
                    selected_196=0
                else
                    current_page_195=0
                    selected_196=0
                fi
            else
                selected_196="$(( ${selected_196} + 1 ))"
            fi
        elif [ "$(( $([ "_${key_227}" != "_LEFT" ]; echo $?) || $([ "_${key_227}" != "_h" ]; echo $?) ))" != 0 ]; then
            if [ "$(( ${current_page_195} > 0 ))" != 0 ]; then
                current_page_195="$(( ${current_page_195} - 1 ))"
                selected_196=0
            else
                selected_196=0
            fi
        elif [ "$(( $([ "_${key_227}" != "_RIGHT" ]; echo $?) || $([ "_${key_227}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "$(( ${current_page_195} < $(( ${total_pages_194} - 1 )) ))" != 0 ]; then
                current_page_195="$(( ${current_page_195} + 1 ))"
                selected_196=0
            else
                __length_202=("${page_options_215[@]}")
                selected_196="$(( ${#__length_202[@]} - 1 ))"
            fi
        elif [ "$(( $([ "_${key_227}" != "_x" ]; echo $?) || $([ "_${key_227}" != "_X" ]; echo $?) ))" != 0 ]; then
            count_checked__948_v0 checked_209[@]
            ret_count_checked948_v0__390_34="${ret_count_checked948_v0}"
            if [ "${checked_209[${global_selected_230}]}" != 0 ]; then
                checked_209["${global_selected_230}"]=0
            elif [ "$(( $(( ${limit} < 0 )) || $(( ${ret_count_checked948_v0__390_34} < ${limit} )) ))" != 0 ]; then
                checked_209["${global_selected_230}"]=1
            else
                continue
            fi
            __length_203="${cursor}"
            max_option_width_234="$(( $(( $(( ${term_width_169} - ${#__length_203} )) - 2 )) - 1 ))"
            # 2 for check mark
            go_up__879_v0 "$(( ${display_count_197} - ${selected_196} ))"
            array_204=("")
            eprintf__871_v0 "\\x1b[9999D" array_204[@]
            array_205=("")
            eprintf__871_v0 "\\x1b[K" array_205[@]
            check_mark_235="$(if [ "${checked_209[${global_selected_230}]}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
            cutoff_text__891_v0 "${page_options_215[${selected_196}]}" "${max_option_width_234}"
            ret_cutoff_text891_v0__400_65="${ret_cutoff_text891_v0}"
            colored_secondary__854_v0 "${cursor}""${check_mark_235}""${ret_cutoff_text891_v0__400_65}"
            ret_colored_secondary854_v0__400_25="${ret_colored_secondary854_v0}"
            array_206=("")
            eprintf__871_v0 "${ret_colored_secondary854_v0__400_25}" array_206[@]
            go_down__880_v0 "$(( ${display_count_197} - ${selected_196} ))"
            array_207=("")
            eprintf__871_v0 "\\x1b[9999D" array_207[@]
            continue
        elif [ "$(( $(( $([ "_${key_227}" != "_a" ]; echo $?) || $([ "_${key_227}" != "_A" ]; echo $?) )) && $(( ${limit} < 0 )) ))" != 0 ]; then
            count_checked__948_v0 checked_209[@]
            ret_count_checked948_v0__406_35="${ret_count_checked948_v0}"
            __length_208=("${options[@]}")
            all_checked_236="$(( ${ret_count_checked948_v0__406_35} == ${#__length_208[@]} ))"
            from=0
            __length_209=("${checked_209[@]}")
            to="${#__length_209[@]}"
            for i_237 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
                checked_209["${i_237}"]="$(( ! ${all_checked_236} ))"
            done
            go_up__879_v0 "${display_count_197}"
            array_210=("")
            eprintf__871_v0 "\\x1b[9999D" array_210[@]
            render_multi_choose_page__945_v0 page_options_215[@] checked_209[@] "${page_start_216}" "${selected_196}" "${cursor}" "${display_count_197}" "${term_width_169}"
            continue
        elif [ "$([ "_${key_227}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
        __length_211="${cursor}"
        max_option_width_238="$(( $(( $(( ${term_width_169} - ${#__length_211} )) - 2 )) - 1 ))"
        # 2 for check mark
        if [ "$(( ${prev_page_229} != ${current_page_195} ))" != 0 ]; then
            get_page_options__942_v0 options[@] "${current_page_195}" "${page_size}"
            page_options_215=("${ret_get_page_options942_v0[@]}")
            get_page_start__943_v0 "${current_page_195}" "${page_size}"
            page_start_216="${ret_get_page_start943_v0}"
            if [ "${up_paged_231}" != 0 ]; then
                __length_212=("${page_options_215[@]}")
                selected_196="$(( ${#__length_212[@]} - 1 ))"
            fi
            go_up__879_v0 1
            remove_line__875_v0 "$(( ${display_count_197} - 1 ))"
            remove_current_line__876_v0 
            array_213=("")
            eprintf__871_v0 "\\x1b[9999D" array_213[@]
            render_multi_choose_page__945_v0 page_options_215[@] checked_209[@] "${page_start_216}" "${selected_196}" "${cursor}" "${display_count_197}" "${term_width_169}"
            render_page_indicator__946_v0 "${current_page_195}" "${total_pages_194}"
        elif [ "$(( ${prev_selected_228} != ${selected_196} ))" != 0 ]; then
            prev_global_239="$(( ${page_start_216} + ${prev_selected_228} ))"
            go_up__879_v0 "$(( ${display_count_197} - ${prev_selected_228} ))"
            array_214=("")
            eprintf__871_v0 "\\x1b[K" array_214[@]
            __length_215="${cursor}"
            print_blank__877_v0 "${#__length_215}"
            if [ "${checked_209[${prev_global_239}]}" != 0 ]; then
                cutoff_text__891_v0 "${page_options_215[${prev_selected_228}]}" "${max_option_width_238}"
                ret_cutoff_text891_v0__442_54="${ret_cutoff_text891_v0}"
                colored_secondary__854_v0 "✓ ""${ret_cutoff_text891_v0__442_54}"
                ret_colored_secondary854_v0__442_29="${ret_colored_secondary854_v0}"
                array_216=("")
                eprintf__871_v0 "${ret_colored_secondary854_v0__442_29}" array_216[@]
            else
                cutoff_text__891_v0 "${page_options_215[${prev_selected_228}]}" "${max_option_width_238}"
                ret_cutoff_text891_v0__444_36="${ret_cutoff_text891_v0}"
                array_217=("")
                eprintf__871_v0 "• ""${ret_cutoff_text891_v0__444_36}" array_217[@]
            fi
            diff_240="$(( ${selected_196} - ${prev_selected_228} ))"
            go_up_or_down__881_v0 "${diff_240}"
            array_218=("")
            eprintf__871_v0 "\\x1b[9999D" array_218[@]
            array_219=("")
            eprintf__871_v0 "\\x1b[K" array_219[@]
            new_global_241="$(( ${page_start_216} + ${selected_196} ))"
            check_mark_242="$(if [ "${checked_209[${new_global_241}]}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
            cutoff_text__891_v0 "${page_options_215[${selected_196}]}" "${max_option_width_238}"
            ret_cutoff_text891_v0__453_65="${ret_cutoff_text891_v0}"
            colored_secondary__854_v0 "${cursor}""${check_mark_242}""${ret_cutoff_text891_v0__453_65}"
            ret_colored_secondary854_v0__453_25="${ret_colored_secondary854_v0}"
            array_220=("")
            eprintf__871_v0 "${ret_colored_secondary854_v0__453_25}" array_220[@]
            go_down__880_v0 "$(( ${display_count_197} - ${selected_196} ))"
            array_221=("")
            eprintf__871_v0 "\\x1b[9999D" array_221[@]
        fi
    done
    total_lines_243="$(( ${display_count_197} + 2 ))"
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_243="$(( ${total_lines_243} + 1 ))"
    fi
    go_down__880_v0 1
    remove_line__875_v0 "$(( ${total_lines_243} - 1 ))"
    remove_current_line__876_v0 
    result_244=()
    from=0
    __length_223=("${options[@]}")
    to="${#__length_223[@]}"
    for i_245 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        if [ "${checked_209[${i_245}]}" != 0 ]; then
            result_244+=("${options[${i_245}]}")
        fi
    done
    stty_unlock__834_v0 
    show_cursor__883_v0 
    ret_xyl_multi_choose949_v0=("${result_244[@]}")
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
    options_150=()
    command_230="$([ -t 0 ] && echo "true" || echo "false")"
    __status=$?
    is_tty_151="${command_230}"
    if [ "$([ "_${is_tty_151}" != "_false" ]; echo $?)" != 0 ]; then
        while IFS= read -r line || [[ -n "$line" ]]; do options_150+=("$line"); done
        __status=$?
    fi
    ret_read_stdin_options1077_v0=("${options_150[@]}")
    return 0
}

execute_choose__1078_v0() {
    local parameters=("${!1}")
    cursor_140="> "
    colored_primary__853_v0 "Choose: "
    ret_colored_primary853_v0__17_30="${ret_colored_primary853_v0}"
    header_149="\\x1b[1m""${ret_colored_primary853_v0__17_30}"
    read_stdin_options__1077_v0 
    options_152=("${ret_read_stdin_options1077_v0[@]}")
    multi_153=0
    limit_154=-1
    page_size_155=10
    for param_156 in "${parameters[@]:2:9997}"; do
        match_regex__20_v0 "${param_156}" "^-h\$" 0
        ret_match_regex20_v0__25_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_156}" "^--help\$" 0
        ret_match_regex20_v0__25_43="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_156}" "^--cursor=.*\$" 0
        ret_match_regex20_v0__29_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_156}" "^--header=.*\$" 0
        ret_match_regex20_v0__33_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_156}" "^--limit=.*\$" 0
        ret_match_regex20_v0__37_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_156}" "^--no-limit\$" 0
        ret_match_regex20_v0__45_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_156}" "^--page-size=.*\$" 0
        ret_match_regex20_v0__48_13="${ret_match_regex20_v0}"
        if [ "$(( ${ret_match_regex20_v0__25_13} || ${ret_match_regex20_v0__25_43} ))" != 0 ]; then
            print_choose_help__1026_v0 
            exit 0
        elif [ "${ret_match_regex20_v0__29_13}" != 0 ]; then
            split__5_v0 "${param_156}" "="
            result_157=("${ret_split5_v0[@]}")
            cursor_140="${result_157[1]}"
        elif [ "${ret_match_regex20_v0__33_13}" != 0 ]; then
            split__5_v0 "${param_156}" "="
            result_158=("${ret_split5_v0[@]}")
            header_149="${result_158[1]}"
        elif [ "${ret_match_regex20_v0__37_13}" != 0 ]; then
            split__5_v0 "${param_156}" "="
            result_159=("${ret_split5_v0[@]}")
            parse_int__14_v0 "${result_159[1]}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__872_v0 "ERROR: Invalid limit value: ""${result_159[1]}""
" 31
                exit 1
            fi
            limit_154="${ret_parse_int14_v0}"
            multi_153=1
        elif [ "${ret_match_regex20_v0__45_13}" != 0 ]; then
            multi_153=1
        elif [ "${ret_match_regex20_v0__48_13}" != 0 ]; then
            split__5_v0 "${param_156}" "="
            result_160=("${ret_split5_v0[@]}")
            parse_int__14_v0 "${result_160[1]}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__872_v0 "ERROR: Invalid page-size value: ""${result_160[1]}""
" 31
                exit 1
            fi
            page_size_155="${ret_parse_int14_v0}"
        else
            options_152+=("${param_156}")
        fi
    done
    has_ansi_escape__884_v0 "${header_149}"
    ret_has_ansi_escape884_v0__61_42="${ret_has_ansi_escape884_v0}"
    escape_ansi__885_v0 "${header_149}"
    ret_escape_ansi885_v0__61_71="${ret_escape_ansi885_v0}"
    colored_primary__853_v0 "${header_149}"
    ret_colored_primary853_v0__61_109="${ret_colored_primary853_v0}"
    display_header_162="$(if [ "$(( $([ "_${header_149}" != "_" ]; echo $?) || ${ret_has_ansi_escape884_v0__61_42} ))" != 0 ]; then echo "${ret_escape_ansi885_v0__61_71}"; else echo "\\x1b[1m""${ret_colored_primary853_v0__61_109}"; fi)"
    if [ "${multi_153}" != 0 ]; then
        xyl_multi_choose__949_v0 options_152[@] "${cursor_140}" "${display_header_162}" "${limit_154}" "${page_size_155}"
        results_248=("${ret_xyl_multi_choose949_v0[@]}")
        join__8_v0 results_248[@] "
"
        ret_execute_choose1078_v0="${ret_join8_v0}"
        return 0
    fi
    xyl_choose__947_v0 options_152[@] "${cursor_140}" "${display_header_162}" "${page_size_155}"
    ret_execute_choose1078_v0="${ret_xyl_choose947_v0}"
    return 0
}

# Perl Extensions Utilities
command_232="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_30="$([ "_${command_232}" != "_No" ]; echo $?)"
command_233="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_31="$(( $(( ! ${_perl_disabled_30} )) && $([ "_${command_233}" != "_0" ]; echo $?) ))"
perl_get_cjk_width__1207_v0() {
    local text=$1
    if [ "$(( ! ${_perl_available_31} ))" != 0 ]; then
        ret_perl_get_cjk_width1207_v0=''
        return 1
    fi
    command_234="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1207_v0=''
        return "${__status}"
    fi
    width_str_295="${command_234}"
    parse_int__14_v0 "${width_str_295}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1207_v0=''
        return "${__status}"
    fi
    width_296="${ret_parse_int14_v0}"
    ret_perl_get_cjk_width1207_v0="${width_296}"
    return 0
}

perl_truncate_cjk__1208_v0() {
    local text=$1
    local max_width=$2
    if [ "$(( ! ${_perl_available_31} ))" != 0 ]; then
        ret_perl_truncate_cjk1208_v0=''
        return 1
    fi
    command_235="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text}" ${max_width} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1208_v0=''
        return "${__status}"
    fi
    result_299="${command_235}"
    ret_perl_truncate_cjk1208_v0="${result_299}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_32=0
_term_size_33=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
stty_lock__1215_v0() {
    command_237="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_286="${command_237}"
    parse_int__14_v0 "${count_286}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_287="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_287} == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_287="$(( ${count_num_287} + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_287}
    __status=$?
}

stty_unlock__1216_v0() {
    command_238="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_334="${command_238}"
    parse_int__14_v0 "${count_334}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_335="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_335} > 0 ))" != 0 ]; then
        count_num_335="$(( ${count_num_335} - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_335}
        __status=$?
        if [ "$(( ${count_num_335} == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

get_term_size__1217_v0() {
    # Query terminal size with \x1b[18t, response format: \x1b[8;rows;colst
    command_239="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -rsd t _ignore height width < /dev/tty; echo "$height; $width")"
    __status=$?
    result_288="${command_239}"
    split__5_v0 "${result_288}" ";"
    parts_289=("${ret_split5_v0[@]}")
    __length_240=("${parts_289[@]}")
    if [ "$(( ${#__length_240[@]} != 2 ))" != 0 ]; then
        ret_get_term_size1217_v0=''
        return 1
    fi
    parse_int__14_v0 "${parts_289[0]}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_term_size1217_v0=''
        return "${__status}"
    fi
    rows_290="${ret_parse_int14_v0}"
    parse_int__14_v0 "${parts_289[1]}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_term_size1217_v0=''
        return "${__status}"
    fi
    cols_291="${ret_parse_int14_v0}"
    _term_size_33=("${cols_291}" "${rows_290}")
    _got_term_size_32=1
}

term_width__1219_v0() {
    if [ "$(( ! ${_got_term_size_32} ))" != 0 ]; then
        get_term_size__1217_v0 
        __status=$?
    fi
    ret_term_width1219_v0="${_term_size_33[0]}"
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
get_supports_truecolor__1230_v0() {
    env_var_get__98_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    config_277="${ret_env_var_get98_v0}"
    if [ "$([ "_${config_277}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_34="No"
        ret_get_supports_truecolor1230_v0=0
        return 0
    fi
    env_var_get__98_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_34="No"
        ret_get_supports_truecolor1230_v0=0
        return 0
    fi
    colorterm_278="${ret_env_var_get98_v0}"
    _supports_truecolor_34="$(if [ "$(( $([ "_${colorterm_278}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_278}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1230_v0="$([ "_${_supports_truecolor_34}" != "_Yes" ]; echo $?)"
    return 0
}

colored_rgb__1231_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    if [ "$([ "_${_supports_truecolor_34}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1231_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_34}" != "_None" ]; echo $?)" != 0 ]; then
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
    bg_fallback_320="${fallback}"
    if [ "$(( $(( ${fallback} >= 30 )) && $(( ${fallback} <= 37 )) ))" != 0 ]; then
        bg_fallback_320="$(( ${fallback} + 10 ))"
    fi
    if [ "$(( $(( ${fallback} >= 90 )) && $(( ${fallback} <= 97 )) ))" != 0 ]; then
        bg_fallback_320="$(( ${fallback} + 10 ))"
    fi
    if [ "$([ "_${_supports_truecolor_34}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_background_rgb1232_v0="\\x1b[48;2;${r};${g};${b}m""${message}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_34}" != "_None" ]; echo $?)" != 0 ]; then
        get_supports_truecolor__1230_v0 
        ret_get_supports_truecolor1230_v0__92_17="${ret_get_supports_truecolor1230_v0}"
        if [ "${ret_get_supports_truecolor1230_v0__92_17}" != 0 ]; then
            ret_background_rgb1232_v0="\\x1b[48;2;${r};${g};${b}m""${message}""\\x1b[0m"
            return 0
        elif [ "$(( ${bg_fallback_320} == 0 ))" != 0 ]; then
            ret_background_rgb1232_v0="${message}"
            return 0
        else
            ret_background_rgb1232_v0="\\x1b[${bg_fallback_320}m""${message}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( ${bg_fallback_320} == 0 ))" != 0 ]; then
            ret_background_rgb1232_v0="${message}"
            return 0
        fi
        ret_background_rgb1232_v0="\\x1b[${bg_fallback_320}m""${message}""\\x1b[0m"
        return 0
    fi
}

inner_get_xylitol_colors__1233_v0() {
    if [ "$(( ! ${_got_xylitol_colors_35} ))" != 0 ]; then
        env_var_get__98_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        primary_env_271="${ret_env_var_get98_v0}"
        if [ "$([ "_${primary_env_271}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${primary_env_271}" ";"
            parts_272=("${ret_split5_v0[@]}")
            __length_245=("${parts_272[@]}")
            if [ "$(( ${#__length_245[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_272[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__115_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_272[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__116_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_272[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__117_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_272[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
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
        secondary_env_273="${ret_env_var_get98_v0}"
        if [ "$([ "_${secondary_env_273}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${secondary_env_273}" ";"
            parts_274=("${ret_split5_v0[@]}")
            __length_247=("${parts_274[@]}")
            if [ "$(( ${#__length_247[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_274[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__128_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_274[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__129_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_274[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__130_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_274[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
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
        accent_env_275="${ret_env_var_get98_v0}"
        if [ "$([ "_${accent_env_275}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${accent_env_275}" ";"
            parts_276=("${ret_split5_v0[@]}")
            __length_249=("${parts_276[@]}")
            if [ "$(( ${#__length_249[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_276[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__141_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_276[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__142_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_276[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__143_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_276[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__144_21="${ret_parse_int14_v0}"
            fi
        fi
        _got_xylitol_colors_35=1
    fi
}

get_xylitol_colors__1234_v0() {
    inner_get_xylitol_colors__1233_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__112_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_35=1
}

colored_primary__1235_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_35} ))" != 0 ]; then
        get_xylitol_colors__1234_v0 
    fi
    colored_rgb__1231_v0 "${message}" "${_primary_color_36[0]}" "${_primary_color_36[1]}" "${_primary_color_36[2]}" "${_primary_color_36[3]}"
    ret_colored_primary1235_v0="${ret_colored_rgb1231_v0}"
    return 0
}

colored_secondary__1236_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_35} ))" != 0 ]; then
        get_xylitol_colors__1234_v0 
    fi
    colored_rgb__1231_v0 "${message}" "${_secondary_color_37[0]}" "${_secondary_color_37[1]}" "${_secondary_color_37[2]}" "${_secondary_color_37[3]}"
    ret_colored_secondary1236_v0="${ret_colored_rgb1231_v0}"
    return 0
}

background_secondary__1239_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_35} ))" != 0 ]; then
        get_xylitol_colors__1234_v0 
    fi
    background_rgb__1232_v0 "${message}" "${_secondary_color_37[0]}" "${_secondary_color_37[1]}" "${_secondary_color_37[2]}" "${_secondary_color_37[3]}"
    ret_background_secondary1239_v0="${ret_background_rgb1232_v0}"
    return 0
}

# // IO Functions /////
get_key__1251_v0() {
    command_251="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    var_331="${command_251}"
    if [ "$([ "_${var_331}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1251_v0="UP"
        return 0
    elif [ "$([ "_${var_331}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1251_v0="DOWN"
        return 0
    elif [ "$([ "_${var_331}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1251_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_331}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1251_v0="LEFT"
        return 0
    elif [ "$([ "_${var_331}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1251_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_331}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1251_v0="INPUT"
        return 0
    else
        ret_get_key1251_v0="${var_331}"
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
    has_escape_284="${command_259}"
    ret_has_ansi_escape1266_v0="$([ "_${has_escape_284}" != "_1" ]; echo $?)"
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
    result_294="${command_262}"
    ret_is_all_ascii1269_v0="$([ "_${result_294}" != "_0" ]; echo $?)"
    return 0
}

get_visible_len__1270_v0() {
    local text=$1
    strip_ansi__1268_v0 "${text}"
    stripped_293="${ret_strip_ansi1268_v0}"
    # Check if text is all ASCII
    is_all_ascii__1269_v0 "${stripped_293}"
    ret_is_all_ascii1269_v0__140_12="${ret_is_all_ascii1269_v0}"
    if [ "$(( ! ${ret_is_all_ascii1269_v0__140_12} ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1207_v0 "${stripped_293}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            __length_263="${stripped_293}"
            ret_get_visible_len1270_v0="${#__length_263}"
            return 0
        fi
        ret_get_visible_len1270_v0="${ret_perl_get_cjk_width1207_v0}"
        return 0
    else
        __length_264="${stripped_293}"
        ret_get_visible_len1270_v0="${#__length_264}"
        return 0
    fi
}

truncate_text__1271_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__1270_v0 "${text}"
    visible_len_298="${ret_get_visible_len1270_v0}"
    if [ "$(( ${visible_len_298} <= ${max_width} ))" != 0 ]; then
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
    starts_with_ansi_300="${command_266}"
    # Replace \x1b[ with newline, then split
    command_267="$(t="${text}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    replaced_301="${command_267}"
    split__5_v0 "${replaced_301}" "
"
    parts_302=("${ret_split5_v0[@]}")
    result_303=""
    remaining_width_304="${max_width}"
    from=0
    __length_268=("${parts_302[@]}")
    to="${#__length_268[@]}"
    for idx_305 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        part_306="${parts_302[${idx_305}]}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( ${idx_305} == 0 )) && $([ "_${starts_with_ansi_300}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_306}" == "_" ]; echo $?) && $(( ${remaining_width_304} > 0 )) ))" != 0 ]; then
                truncate_text__1271_v0 "${part_306}" "${remaining_width_304}"
                truncated_307="${ret_truncate_text1271_v0}"
                result_303+="${truncated_307}"
                get_visible_len__1270_v0 "${truncated_307}"
                ret_get_visible_len1270_v0__193_36="${ret_get_visible_len1270_v0}"
                remaining_width_304="$(( ${remaining_width_304} - ${ret_get_visible_len1270_v0__193_36} ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            command_269="$(__p="${part_306}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            m_idx_308="${command_269}"
            if [ "$([ "_${m_idx_308}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                command_270="$(__p="${part_306}"; printf "%s" "${__p:0:${m_idx_308}}")"
                __status=$?
                ansi_params_309="${command_270}"
                result_303+="\\x1b[""${ansi_params_309}""m"
                # Rest is text content
                parse_int__14_v0 "${m_idx_308}"
                __status=$?
                m_idx_num_310="${ret_parse_int14_v0}"
                text_start_311="$(( ${m_idx_num_310} + 1 ))"
                command_271="$(__p="${part_306}"; printf "%s" "${__p:${text_start_311}}")"
                __status=$?
                text_part_312="${command_271}"
                if [ "$(( $([ "_${text_part_312}" == "_" ]; echo $?) && $(( ${remaining_width_304} > 0 )) ))" != 0 ]; then
                    truncate_text__1271_v0 "${text_part_312}" "${remaining_width_304}"
                    truncated_313="${ret_truncate_text1271_v0}"
                    result_303+="${truncated_313}"
                    get_visible_len__1270_v0 "${truncated_313}"
                    ret_get_visible_len1270_v0__210_40="${ret_get_visible_len1270_v0}"
                    remaining_width_304="$(( ${remaining_width_304} - ${ret_get_visible_len1270_v0__210_40} ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_306}" == "_" ]; echo $?) && $(( ${remaining_width_304} > 0 )) ))" != 0 ]; then
                    truncate_text__1271_v0 "${part_306}" "${remaining_width_304}"
                    truncated_314="${ret_truncate_text1271_v0}"
                    result_303+="${truncated_314}"
                    get_visible_len__1270_v0 "${truncated_314}"
                    remaining_width_304="$(( ${remaining_width_304} - ${ret_get_visible_len1270_v0__217_40} ))"
                fi
            fi
        fi
    done
    ret_truncate_ansi1272_v0="${result_303}"
    return 0
}

cutoff_text__1273_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__1270_v0 "${text}"
    visible_len_297="${ret_get_visible_len1270_v0}"
    if [ "$(( ${visible_len_297} <= ${max_width} ))" != 0 ]; then
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
    separator_321=" • "
    separator_len_322=3
    # Fast path: no truncation needed
    if [ "$(( ${total_len} <= ${term_width} ))" != 0 ]; then
        iter_323=0
        while :
        do
            __length_272=("${items[@]}")
            if [ "$(( ${iter_323} >= ${#__length_272[@]} ))" != 0 ]; then
                break
            elif [ "$(( ${iter_323} > 0 ))" != 0 ]; then
                eprintf_colored__1254_v0 "${separator_321}" 90
            fi
            colored__1255_v0 "${items[$(( ${iter_323} + 1 ))]}" 2
            ret_colored1255_v0__258_41="${ret_colored1255_v0}"
            array_273=("")
            eprintf__1253_v0 "${items[${iter_323}]}"" ""${ret_colored1255_v0__258_41}" array_273[@]
            iter_323="$(( ${iter_323} + 2 ))"
        done
    else
        # Slow path: truncate
        current_len_324=0
        first_325=1
        iter_326=0
        while :
        do
            __length_274=("${items[@]}")
            if [ "$(( ${iter_326} >= ${#__length_274[@]} ))" != 0 ]; then
                break
            fi
            key_327="${items[${iter_326}]}"
            action_328="${items[$(( ${iter_326} + 1 ))]}"
            __length_275="${key_327}"
            __length_276="${action_328}"
            part_len_329="$(( $(( ${#__length_275} + 1 )) + ${#__length_276} ))"
            needed_330="${part_len_329}"
            if [ "$(( ! ${first_325} ))" != 0 ]; then
                needed_330="$(( ${needed_330} + ${separator_len_322} ))"
            fi
            if [ "$(( $(( ${current_len_324} + ${needed_330} )) > ${term_width} ))" != 0 ]; then
                break
            fi
            if [ "$(( ! ${first_325} ))" != 0 ]; then
                eprintf_colored__1254_v0 "${separator_321}" 90
            fi
            colored__1255_v0 "${action_328}" 2
            ret_colored1255_v0__286_33="${ret_colored1255_v0}"
            array_277=("")
            eprintf__1253_v0 "${key_327}"" ""${ret_colored1255_v0__286_33}" array_277[@]
            current_len_324="$(( ${current_len_324} + ${needed_330} ))"
            first_325=0
            iter_326="$(( ${iter_326} + 2 ))"
        done
    fi
}

render_confirm_options__1324_v0() {
    local selected=$1
    local term_width=$2
    small_316="$(( ${term_width} < 30 ))"
    yes_label_317="$(if [ "${small_316}" != 0 ]; then echo " Yes "; else echo "    Yes    "; fi)"
    no_label_318="$(if [ "${small_316}" != 0 ]; then echo " No "; else echo "    No    "; fi)"
    gap_319="$(if [ "${small_316}" != 0 ]; then echo " "; else echo "  "; fi)"
    array_278=("")
    eprintf__1253_v0 " " array_278[@]
    if [ "${selected}" != 0 ]; then
        # Yes selected
        background_secondary__1239_v0 "${yes_label_317}"
        ret_background_secondary1239_v0__15_30="${ret_background_secondary1239_v0}"
        array_279=("")
        eprintf__1253_v0 "\\x1b[97m""${ret_background_secondary1239_v0__15_30}" array_279[@]
        array_280=("")
        eprintf__1253_v0 "${gap_319}" array_280[@]
        # No not selected (dim)
        array_281=("")
        eprintf__1253_v0 "\\x1b[49;37m""${no_label_318}""\\x1b[0m" array_281[@]
    else
        # No selected
        array_282=("")
        eprintf__1253_v0 "\\x1b[49;37m""${yes_label_317}""\\x1b[0m" array_282[@]
        array_283=("")
        eprintf__1253_v0 "${gap_319}" array_283[@]
        background_secondary__1239_v0 "${no_label_318}"
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
    term_width_292="${ret_term_width1219_v0}"
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__1273_v0 "${header}" "${term_width_292}"
        ret_cutoff_text1273_v0__45_17="${ret_cutoff_text1273_v0}"
        array_285=("")
        eprintf__1253_v0 "${ret_cutoff_text1273_v0__45_17}""

" array_285[@]
    fi
    selected_315="${default_yes}"
    # Render initial options
    render_confirm_options__1324_v0 "${selected_315}" "${term_width_292}"
    array_286=("")
    eprintf__1253_v0 "

" array_286[@]
    # "←→ select • enter confirm • y yes • n no" = 9 + 3 + 13 + 3 + 5 + 3 + 4 = 40
    array_287=("←→" "select" "enter" "confirm" "y" "yes" "n" "no")
    render_tooltip__1274_v0 array_287[@] 40 "${term_width_292}"
    go_up__1261_v0 2
    while :
    do
        get_key__1251_v0 
        key_332="${ret_get_key1251_v0}"
        if [ "$(( $(( $(( $([ "_${key_332}" != "_LEFT" ]; echo $?) || $([ "_${key_332}" != "_h" ]; echo $?) )) || $([ "_${key_332}" != "_RIGHT" ]; echo $?) )) || $([ "_${key_332}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "${selected_315}" != 0 ]; then
                selected_315=0
                array_288=("")
                eprintf__1253_v0 "\\x1b[9999D\\x1b[K" array_288[@]
                render_confirm_options__1324_v0 "${selected_315}" "${term_width_292}"
            elif [ "$(( ! ${selected_315} ))" != 0 ]; then
                selected_315=1
                array_289=("")
                eprintf__1253_v0 "\\x1b[9999D\\x1b[K" array_289[@]
                render_confirm_options__1324_v0 "${selected_315}" "${term_width_292}"
            fi
        elif [ "$(( $([ "_${key_332}" != "_y" ]; echo $?) || $([ "_${key_332}" != "_Y" ]; echo $?) ))" != 0 ]; then
            selected_315=1
            break
        elif [ "$(( $([ "_${key_332}" != "_n" ]; echo $?) || $([ "_${key_332}" != "_N" ]; echo $?) ))" != 0 ]; then
            selected_315=0
            break
        elif [ "$([ "_${key_332}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
    done
    # Clean up: remove options line and hint line
    total_lines_333=4
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_333="$(( ${total_lines_333} + 1 ))"
    fi
    go_down__1262_v0 2
    remove_line__1257_v0 "$(( ${total_lines_333} - 1 ))"
    remove_current_line__1258_v0 
    stty_unlock__1216_v0 
    show_cursor__1265_v0 
    ret_xyl_confirm1325_v0="${selected_315}"
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
    header_279="\\x1b[1m""${ret_colored_primary1235_v0__9_30}"
    default_yes_280=1
    for param_281 in "${parameters[@]}"; do
        match_regex__20_v0 "${param_281}" "^-h\$" 0
        ret_match_regex20_v0__14_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_281}" "^--help\$" 0
        ret_match_regex20_v0__14_43="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_281}" "^--header=.*\$" 0
        ret_match_regex20_v0__18_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_281}" "^--default=.*\$" 0
        ret_match_regex20_v0__22_13="${ret_match_regex20_v0}"
        if [ "$(( ${ret_match_regex20_v0__14_13} || ${ret_match_regex20_v0__14_43} ))" != 0 ]; then
            print_confirm_help__1401_v0 
            exit 0
        elif [ "${ret_match_regex20_v0__18_13}" != 0 ]; then
            split__5_v0 "${param_281}" "="
            result_282=("${ret_split5_v0[@]}")
            header_279="${result_282[1]}"
        elif [ "${ret_match_regex20_v0__22_13}" != 0 ]; then
            split__5_v0 "${param_281}" "="
            result_283=("${ret_split5_v0[@]}")
            if [ "$(( $([ "_${result_283[1]}" != "_yes" ]; echo $?) || $([ "_${result_283[1]}" != "_y" ]; echo $?) ))" != 0 ]; then
                default_yes_280=1
            elif [ "$(( $([ "_${result_283[1]}" != "_no" ]; echo $?) || $([ "_${result_283[1]}" != "_n" ]; echo $?) ))" != 0 ]; then
                default_yes_280=0
            else
                eprintf_colored__1254_v0 "ERROR: Invalid default value: ""${result_283[1]}"". Use 'yes' or 'no'.
" 31
                exit 1
            fi
        fi
    done
    has_ansi_escape__1266_v0 "${header_279}"
    ret_has_ansi_escape1266_v0__36_42="${ret_has_ansi_escape1266_v0}"
    escape_ansi__1267_v0 "${header_279}"
    ret_escape_ansi1267_v0__36_71="${ret_escape_ansi1267_v0}"
    colored_primary__1235_v0 "${header_279}"
    ret_colored_primary1235_v0__36_109="${ret_colored_primary1235_v0}"
    display_header_285="$(if [ "$(( $([ "_${header_279}" != "_" ]; echo $?) || ${ret_has_ansi_escape1266_v0__36_42} ))" != 0 ]; then echo "${ret_escape_ansi1267_v0__36_71}"; else echo "\\x1b[1m""${ret_colored_primary1235_v0__36_109}"; fi)"
    xyl_confirm__1325_v0 "${display_header_285}" "${default_yes_280}"
    result_336="${ret_xyl_confirm1325_v0}"
    ret_execute_confirm1452_v0="$(if [ "${result_336}" != 0 ]; then echo "yes"; else echo "no"; fi)"
    return 0
}

get_directory_entries__1570_v0() {
    local path=$1
    command_293="$(ls -lA "${path}" 2>/dev/null | tail -n +2)"
    __status=$?
    raw_364="${command_293}"
    command_294="$(ls -lA "${path}" | tail -n +2 | sed -E 's/^(.).*/\1/')"
    __status=$?
    types_365="${command_294}"
    command_295="$(ls -1A "${path}")"
    __status=$?
    names_366="${command_295}"
    split__5_v0 "${types_365}" "
"
    types_367=("${ret_split5_v0[@]}")
    split__5_v0 "${raw_364}" "
"
    raw_368=("${ret_split5_v0[@]}")
    split__5_v0 "${names_366}" "
"
    names_369=("${ret_split5_v0[@]}")
    entries_370=()
    from=0
    __length_297=("${raw_368[@]}")
    to="${#__length_297[@]}"
    for i_371 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        file_type_372="f"
        target_373=""
        if [ "$([ "_${types_367[${i_371}]}" != "_-" ]; echo $?)" != 0 ]; then
            file_type_372="f"
        elif [ "$([ "_${types_367[${i_371}]}" != "_l" ]; echo $?)" != 0 ]; then
            command_298="$(echo ${raw_368[${i_371}]} | sed 's/.*-> //')"
            __status=$?
            target_373="${command_298}"
            file_type_372="l"
        fi
        if [ "$([ "_${file_type_372}" != "_l" ]; echo $?)" != 0 ]; then
            entries_370+=("${names_369[${i_371}]}	${types_367[${i_371}]}	${target_373}")
        else
            entries_370+=("${names_369[${i_371}]}	${types_367[${i_371}]}")
        fi
    done
    ret_get_directory_entries1570_v0=("${entries_370[@]}")
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
    normalized_363="${command_302}"
    if [ "$([ "_${normalized_363}" != "_" ]; echo $?)" != 0 ]; then
        ret_normalize_path1573_v0="${path}"
        return 0
    fi
    ret_normalize_path1573_v0="${normalized_363}"
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
    parent_469="${command_303}"
    ret_get_parent_dir1576_v0="${parent_469}"
    return 0
}

# Perl Extensions Utilities
command_304="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_39="$([ "_${command_304}" != "_No" ]; echo $?)"
command_305="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_40="$(( $(( ! ${_perl_disabled_39} )) && $([ "_${command_305}" != "_0" ]; echo $?) ))"
# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_41=0
_term_size_42=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
stty_lock__1593_v0() {
    command_307="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_354="${command_307}"
    parse_int__14_v0 "${count_354}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_355="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_355} == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_355="$(( ${count_num_355} + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_355}
    __status=$?
}

stty_unlock__1594_v0() {
    command_308="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_383="${command_308}"
    parse_int__14_v0 "${count_383}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_384="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_384} > 0 ))" != 0 ]; then
        count_num_384="$(( ${count_num_384} - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_384}
        __status=$?
        if [ "$(( ${count_num_384} == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

get_term_size__1595_v0() {
    # Query terminal size with \x1b[18t, response format: \x1b[8;rows;colst
    command_309="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -rsd t _ignore height width < /dev/tty; echo "$height; $width")"
    __status=$?
    result_356="${command_309}"
    split__5_v0 "${result_356}" ";"
    parts_357=("${ret_split5_v0[@]}")
    __length_310=("${parts_357[@]}")
    if [ "$(( ${#__length_310[@]} != 2 ))" != 0 ]; then
        ret_get_term_size1595_v0=''
        return 1
    fi
    parse_int__14_v0 "${parts_357[0]}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_term_size1595_v0=''
        return "${__status}"
    fi
    rows_358="${ret_parse_int14_v0}"
    parse_int__14_v0 "${parts_357[1]}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_term_size1595_v0=''
        return "${__status}"
    fi
    cols_359="${ret_parse_int14_v0}"
    _term_size_42=("${cols_359}" "${rows_358}")
    _got_term_size_41=1
}

term_width__1597_v0() {
    if [ "$(( ! ${_got_term_size_41} ))" != 0 ]; then
        get_term_size__1595_v0 
        __status=$?
    fi
    ret_term_width1597_v0="${_term_size_42[0]}"
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
get_supports_truecolor__1608_v0() {
    env_var_get__98_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    config_349="${ret_env_var_get98_v0}"
    if [ "$([ "_${config_349}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_43="No"
        ret_get_supports_truecolor1608_v0=0
        return 0
    fi
    env_var_get__98_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_43="No"
        ret_get_supports_truecolor1608_v0=0
        return 0
    fi
    colorterm_350="${ret_env_var_get98_v0}"
    _supports_truecolor_43="$(if [ "$(( $([ "_${colorterm_350}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_350}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1608_v0="$([ "_${_supports_truecolor_43}" != "_Yes" ]; echo $?)"
    return 0
}

colored_rgb__1609_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    if [ "$([ "_${_supports_truecolor_43}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1609_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_43}" != "_None" ]; echo $?)" != 0 ]; then
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
    if [ "$(( ! ${_got_xylitol_colors_44} ))" != 0 ]; then
        env_var_get__98_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        primary_env_343="${ret_env_var_get98_v0}"
        if [ "$([ "_${primary_env_343}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${primary_env_343}" ";"
            parts_344=("${ret_split5_v0[@]}")
            __length_315=("${parts_344[@]}")
            if [ "$(( ${#__length_315[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_344[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__115_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_344[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__116_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_344[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__117_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_344[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
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
        secondary_env_345="${ret_env_var_get98_v0}"
        if [ "$([ "_${secondary_env_345}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${secondary_env_345}" ";"
            parts_346=("${ret_split5_v0[@]}")
            __length_317=("${parts_346[@]}")
            if [ "$(( ${#__length_317[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_346[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__128_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_346[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__129_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_346[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__130_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_346[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
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
        accent_env_347="${ret_env_var_get98_v0}"
        if [ "$([ "_${accent_env_347}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${accent_env_347}" ";"
            parts_348=("${ret_split5_v0[@]}")
            __length_319=("${parts_348[@]}")
            if [ "$(( ${#__length_319[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_348[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__141_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_348[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__142_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_348[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__143_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_348[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__144_21="${ret_parse_int14_v0}"
                _accent_color_47=("${ret_parse_int14_v0__141_21}" "${ret_parse_int14_v0__142_21}" "${ret_parse_int14_v0__143_21}" "${ret_parse_int14_v0__144_21}")
            fi
        fi
        _got_xylitol_colors_44=1
    fi
}

get_xylitol_colors__1612_v0() {
    inner_get_xylitol_colors__1611_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__112_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_44=1
}

colored_primary__1613_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_44} ))" != 0 ]; then
        get_xylitol_colors__1612_v0 
    fi
    colored_rgb__1609_v0 "${message}" "${_primary_color_45[0]}" "${_primary_color_45[1]}" "${_primary_color_45[2]}" "${_primary_color_45[3]}"
    ret_colored_primary1613_v0="${ret_colored_rgb1609_v0}"
    return 0
}

colored_secondary__1614_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_44} ))" != 0 ]; then
        get_xylitol_colors__1612_v0 
    fi
    colored_rgb__1609_v0 "${message}" "${_secondary_color_46[0]}" "${_secondary_color_46[1]}" "${_secondary_color_46[2]}" "${_secondary_color_46[3]}"
    ret_colored_secondary1614_v0="${ret_colored_rgb1609_v0}"
    return 0
}

colored_accent__1615_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_44} ))" != 0 ]; then
        get_xylitol_colors__1612_v0 
    fi
    colored_rgb__1609_v0 "${message}" "${_accent_color_47[0]}" "${_accent_color_47[1]}" "${_accent_color_47[2]}" "${_accent_color_47[3]}"
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
_perl_disabled_48="$([ "_${command_323}" != "_No" ]; echo $?)"
command_324="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_49="$(( $(( ! ${_perl_disabled_48} )) && $([ "_${command_324}" != "_0" ]; echo $?) ))"
perl_get_cjk_width__1780_v0() {
    local text=$1
    if [ "$(( ! ${_perl_available_49} ))" != 0 ]; then
        ret_perl_get_cjk_width1780_v0=''
        return 1
    fi
    command_325="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1780_v0=''
        return "${__status}"
    fi
    width_str_397="${command_325}"
    parse_int__14_v0 "${width_str_397}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1780_v0=''
        return "${__status}"
    fi
    width_398="${ret_parse_int14_v0}"
    ret_perl_get_cjk_width1780_v0="${width_398}"
    return 0
}

perl_truncate_cjk__1781_v0() {
    local text=$1
    local max_width=$2
    if [ "$(( ! ${_perl_available_49} ))" != 0 ]; then
        ret_perl_truncate_cjk1781_v0=''
        return 1
    fi
    command_326="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text}" ${max_width} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1781_v0=''
        return "${__status}"
    fi
    result_402="${command_326}"
    ret_perl_truncate_cjk1781_v0="${result_402}"
    return 0
}

# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_50=0
_term_size_51=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
stty_lock__1788_v0() {
    command_328="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_386="${command_328}"
    parse_int__14_v0 "${count_386}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_387="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_387} == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_387="$(( ${count_num_387} + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_387}
    __status=$?
}

stty_unlock__1789_v0() {
    command_329="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_460="${command_329}"
    parse_int__14_v0 "${count_460}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_461="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_461} > 0 ))" != 0 ]; then
        count_num_461="$(( ${count_num_461} - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_461}
        __status=$?
        if [ "$(( ${count_num_461} == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

get_term_size__1790_v0() {
    # Query terminal size with \x1b[18t, response format: \x1b[8;rows;colst
    command_330="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -rsd t _ignore height width < /dev/tty; echo "$height; $width")"
    __status=$?
    result_388="${command_330}"
    split__5_v0 "${result_388}" ";"
    parts_389=("${ret_split5_v0[@]}")
    __length_331=("${parts_389[@]}")
    if [ "$(( ${#__length_331[@]} != 2 ))" != 0 ]; then
        ret_get_term_size1790_v0=''
        return 1
    fi
    parse_int__14_v0 "${parts_389[0]}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_term_size1790_v0=''
        return "${__status}"
    fi
    rows_390="${ret_parse_int14_v0}"
    parse_int__14_v0 "${parts_389[1]}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_term_size1790_v0=''
        return "${__status}"
    fi
    cols_391="${ret_parse_int14_v0}"
    _term_size_51=("${cols_391}" "${rows_390}")
    _got_term_size_50=1
}

term_width__1792_v0() {
    if [ "$(( ! ${_got_term_size_50} ))" != 0 ]; then
        get_term_size__1790_v0 
        __status=$?
    fi
    ret_term_width1792_v0="${_term_size_51[0]}"
    return 0
}

term_height__1793_v0() {
    if [ "$(( ! ${_got_term_size_50} ))" != 0 ]; then
        get_term_size__1790_v0 
        __status=$?
    fi
    ret_term_height1793_v0="${_term_size_51[1]}"
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
get_supports_truecolor__1803_v0() {
    env_var_get__98_v0 "XYLITOL_TRUECOLOR"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    config_448="${ret_env_var_get98_v0}"
    if [ "$([ "_${config_448}" != "_No" ]; echo $?)" != 0 ]; then
        _supports_truecolor_52="No"
        ret_get_supports_truecolor1803_v0=0
        return 0
    fi
    env_var_get__98_v0 "COLORTERM"
    __status=$?
    if [ "${__status}" != 0 ]; then
        _supports_truecolor_52="No"
        ret_get_supports_truecolor1803_v0=0
        return 0
    fi
    colorterm_449="${ret_env_var_get98_v0}"
    _supports_truecolor_52="$(if [ "$(( $([ "_${colorterm_449}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_449}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
    ret_get_supports_truecolor1803_v0="$([ "_${_supports_truecolor_52}" != "_Yes" ]; echo $?)"
    return 0
}

colored_rgb__1804_v0() {
    local message=$1
    local r=$2
    local g=$3
    local b=$4
    local fallback=$5
    if [ "$([ "_${_supports_truecolor_52}" != "_Yes" ]; echo $?)" != 0 ]; then
        ret_colored_rgb1804_v0="\\x1b[38;2;${r};${g};${b}m""${message}""\\x1b[0m"
        return 0
    elif [ "$([ "_${_supports_truecolor_52}" != "_None" ]; echo $?)" != 0 ]; then
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
    if [ "$(( ! ${_got_xylitol_colors_53} ))" != 0 ]; then
        env_var_get__98_v0 "XYLITOL_PRIMARY_COLOR"
        __status=$?
        if [ "${__status}" != 0 ]; then
            :
        fi
        primary_env_442="${ret_env_var_get98_v0}"
        if [ "$([ "_${primary_env_442}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${primary_env_442}" ";"
            parts_443=("${ret_split5_v0[@]}")
            __length_336=("${parts_443[@]}")
            if [ "$(( ${#__length_336[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_443[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__115_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_443[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__116_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_443[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__117_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_443[3]}"
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
        secondary_env_444="${ret_env_var_get98_v0}"
        if [ "$([ "_${secondary_env_444}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${secondary_env_444}" ";"
            parts_445=("${ret_split5_v0[@]}")
            __length_338=("${parts_445[@]}")
            if [ "$(( ${#__length_338[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_445[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__128_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_445[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__129_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_445[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__130_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_445[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
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
        accent_env_446="${ret_env_var_get98_v0}"
        if [ "$([ "_${accent_env_446}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${accent_env_446}" ";"
            parts_447=("${ret_split5_v0[@]}")
            __length_340=("${parts_447[@]}")
            if [ "$(( ${#__length_340[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_447[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__141_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_447[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__142_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_447[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__143_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_447[3]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__144_21="${ret_parse_int14_v0}"
            fi
        fi
        _got_xylitol_colors_53=1
    fi
}

get_xylitol_colors__1807_v0() {
    inner_get_xylitol_colors__1806_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_colored__112_v0 "WARN: Failed to parse Xylitol colors from envs." 33
    fi
    _got_xylitol_colors_53=1
}

colored_secondary__1809_v0() {
    local message=$1
    if [ "$(( ! ${_got_xylitol_colors_53} ))" != 0 ]; then
        get_xylitol_colors__1807_v0 
    fi
    colored_rgb__1804_v0 "${message}" "${_secondary_color_55[0]}" "${_secondary_color_55[1]}" "${_secondary_color_55[2]}" "${_secondary_color_55[3]}"
    ret_colored_secondary1809_v0="${ret_colored_rgb1804_v0}"
    return 0
}

# // IO Functions /////
get_key__1824_v0() {
    command_342="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    var_452="${command_342}"
    if [ "$([ "_${var_452}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1824_v0="UP"
        return 0
    elif [ "$([ "_${var_452}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1824_v0="DOWN"
        return 0
    elif [ "$([ "_${var_452}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1824_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_452}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1824_v0="LEFT"
        return 0
    elif [ "$([ "_${var_452}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1824_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_452}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1824_v0="INPUT"
        return 0
    else
        ret_get_key1824_v0="${var_452}"
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
    for i_422 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
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
    has_escape_400="${command_351}"
    ret_has_ansi_escape1839_v0="$([ "_${has_escape_400}" != "_1" ]; echo $?)"
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
    result_396="${command_353}"
    ret_is_all_ascii1842_v0="$([ "_${result_396}" != "_0" ]; echo $?)"
    return 0
}

get_visible_len__1843_v0() {
    local text=$1
    strip_ansi__1841_v0 "${text}"
    stripped_395="${ret_strip_ansi1841_v0}"
    # Check if text is all ASCII
    is_all_ascii__1842_v0 "${stripped_395}"
    ret_is_all_ascii1842_v0__140_12="${ret_is_all_ascii1842_v0}"
    if [ "$(( ! ${ret_is_all_ascii1842_v0__140_12} ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1780_v0 "${stripped_395}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            __length_354="${stripped_395}"
            ret_get_visible_len1843_v0="${#__length_354}"
            return 0
        fi
        ret_get_visible_len1843_v0="${ret_perl_get_cjk_width1780_v0}"
        return 0
    else
        __length_355="${stripped_395}"
        ret_get_visible_len1843_v0="${#__length_355}"
        return 0
    fi
}

truncate_text__1844_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__1843_v0 "${text}"
    visible_len_401="${ret_get_visible_len1843_v0}"
    if [ "$(( ${visible_len_401} <= ${max_width} ))" != 0 ]; then
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
    starts_with_ansi_403="${command_357}"
    # Replace \x1b[ with newline, then split
    command_358="$(t="${text}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    replaced_404="${command_358}"
    split__5_v0 "${replaced_404}" "
"
    parts_405=("${ret_split5_v0[@]}")
    result_406=""
    remaining_width_407="${max_width}"
    from=0
    __length_359=("${parts_405[@]}")
    to="${#__length_359[@]}"
    for idx_408 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        part_409="${parts_405[${idx_408}]}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( ${idx_408} == 0 )) && $([ "_${starts_with_ansi_403}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_409}" == "_" ]; echo $?) && $(( ${remaining_width_407} > 0 )) ))" != 0 ]; then
                truncate_text__1844_v0 "${part_409}" "${remaining_width_407}"
                truncated_410="${ret_truncate_text1844_v0}"
                result_406+="${truncated_410}"
                get_visible_len__1843_v0 "${truncated_410}"
                ret_get_visible_len1843_v0__193_36="${ret_get_visible_len1843_v0}"
                remaining_width_407="$(( ${remaining_width_407} - ${ret_get_visible_len1843_v0__193_36} ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            command_360="$(__p="${part_409}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            m_idx_411="${command_360}"
            if [ "$([ "_${m_idx_411}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                command_361="$(__p="${part_409}"; printf "%s" "${__p:0:${m_idx_411}}")"
                __status=$?
                ansi_params_412="${command_361}"
                result_406+="\\x1b[""${ansi_params_412}""m"
                # Rest is text content
                parse_int__14_v0 "${m_idx_411}"
                __status=$?
                m_idx_num_413="${ret_parse_int14_v0}"
                text_start_414="$(( ${m_idx_num_413} + 1 ))"
                command_362="$(__p="${part_409}"; printf "%s" "${__p:${text_start_414}}")"
                __status=$?
                text_part_415="${command_362}"
                if [ "$(( $([ "_${text_part_415}" == "_" ]; echo $?) && $(( ${remaining_width_407} > 0 )) ))" != 0 ]; then
                    truncate_text__1844_v0 "${text_part_415}" "${remaining_width_407}"
                    truncated_416="${ret_truncate_text1844_v0}"
                    result_406+="${truncated_416}"
                    get_visible_len__1843_v0 "${truncated_416}"
                    ret_get_visible_len1843_v0__210_40="${ret_get_visible_len1843_v0}"
                    remaining_width_407="$(( ${remaining_width_407} - ${ret_get_visible_len1843_v0__210_40} ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_409}" == "_" ]; echo $?) && $(( ${remaining_width_407} > 0 )) ))" != 0 ]; then
                    truncate_text__1844_v0 "${part_409}" "${remaining_width_407}"
                    truncated_417="${ret_truncate_text1844_v0}"
                    result_406+="${truncated_417}"
                    get_visible_len__1843_v0 "${truncated_417}"
                    remaining_width_407="$(( ${remaining_width_407} - ${ret_get_visible_len1843_v0__217_40} ))"
                fi
            fi
        fi
    done
    ret_truncate_ansi1845_v0="${result_406}"
    return 0
}

cutoff_text__1846_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__1843_v0 "${text}"
    visible_len_399="${ret_get_visible_len1843_v0}"
    if [ "$(( ${visible_len_399} <= ${max_width} ))" != 0 ]; then
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
    separator_423=" • "
    separator_len_424=3
    # Fast path: no truncation needed
    if [ "$(( ${total_len} <= ${term_width} ))" != 0 ]; then
        iter_425=0
        while :
        do
            __length_363=("${items[@]}")
            if [ "$(( ${iter_425} >= ${#__length_363[@]} ))" != 0 ]; then
                break
            elif [ "$(( ${iter_425} > 0 ))" != 0 ]; then
                eprintf_colored__1827_v0 "${separator_423}" 90
            fi
            colored__1828_v0 "${items[$(( ${iter_425} + 1 ))]}" 2
            ret_colored1828_v0__258_41="${ret_colored1828_v0}"
            array_364=("")
            eprintf__1826_v0 "${items[${iter_425}]}"" ""${ret_colored1828_v0__258_41}" array_364[@]
            iter_425="$(( ${iter_425} + 2 ))"
        done
    else
        # Slow path: truncate
        current_len_426=0
        first_427=1
        iter_428=0
        while :
        do
            __length_365=("${items[@]}")
            if [ "$(( ${iter_428} >= ${#__length_365[@]} ))" != 0 ]; then
                break
            fi
            key_429="${items[${iter_428}]}"
            action_430="${items[$(( ${iter_428} + 1 ))]}"
            __length_366="${key_429}"
            __length_367="${action_430}"
            part_len_431="$(( $(( ${#__length_366} + 1 )) + ${#__length_367} ))"
            needed_432="${part_len_431}"
            if [ "$(( ! ${first_427} ))" != 0 ]; then
                needed_432="$(( ${needed_432} + ${separator_len_424} ))"
            fi
            if [ "$(( $(( ${current_len_426} + ${needed_432} )) > ${term_width} ))" != 0 ]; then
                break
            fi
            if [ "$(( ! ${first_427} ))" != 0 ]; then
                eprintf_colored__1827_v0 "${separator_423}" 90
            fi
            colored__1828_v0 "${action_430}" 2
            ret_colored1828_v0__286_33="${ret_colored1828_v0}"
            array_368=("")
            eprintf__1826_v0 "${key_429}"" ""${ret_colored1828_v0__286_33}" array_368[@]
            current_len_426="$(( ${current_len_426} + ${needed_432} ))"
            first_427=0
            iter_428="$(( ${iter_428} + 2 ))"
        done
    fi
}

get_page_options__1897_v0() {
    local options=("${!1}")
    local page=$2
    local page_size=$3
    start_433="$(( ${page} * ${page_size} ))"
    end_434="$(( ${start_433} + ${page_size} ))"
    __length_369=("${options[@]}")
    if [ "$(( ${end_434} > ${#__length_369[@]} ))" != 0 ]; then
        __length_370=("${options[@]}")
        end_434="${#__length_370[@]}"
    fi
    result_435=()
    from="${start_433}"
    to="${end_434}"
    for i_436 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        result_435+=("${options[${i_436}]}")
    done
    ret_get_page_options1897_v0=("${result_435[@]}")
    return 0
}

render_choose_page__1899_v0() {
    local page_options=("${!1}")
    local sel=$2
    local cursor=$3
    local display_count=$4
    local term_width=$5
    __length_373="${cursor}"
    cursor_len_438="${#__length_373}"
    max_option_width_439="$(( $(( ${term_width} - ${cursor_len_438} )) - 1 ))"
    from=0
    __length_374=("${page_options[@]}")
    to="${#__length_374[@]}"
    for i_440 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        cutoff_text__1846_v0 "${page_options[${i_440}]}" "${max_option_width_439}"
        truncated_option_441="${ret_cutoff_text1846_v0}"
        if [ "$(( ${i_440} == ${sel} ))" != 0 ]; then
            colored_secondary__1809_v0 "${cursor}""${truncated_option_441}""
"
            ret_colored_secondary1809_v0__28_21="${ret_colored_secondary1809_v0}"
            array_375=("")
            eprintf__1826_v0 "${ret_colored_secondary1809_v0__28_21}" array_375[@]
        else
            print_blank__1832_v0 "${cursor_len_438}"
            array_376=("")
            eprintf__1826_v0 "${truncated_option_441}""
" array_376[@]
        fi
    done
    __length_377=("${page_options[@]}")
    remaining_slots_450="$(( ${display_count} - ${#__length_377[@]} ))"
    if [ "$(( ${remaining_slots_450} > 0 ))" != 0 ]; then
        # Amber bug gaurd
        from=0
        to="${remaining_slots_450}"
        for ____451 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
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
    term_width_392="${ret_term_width1792_v0}"
    term_height__1793_v0 
    term_height_393="${ret_term_height1793_v0}"
    max_page_size_394="$(( ${term_height_393} - $(if [ "$([ "_${header}" != "_" ]; echo $?)" != 0 ]; then echo 2; else echo 3; fi) ))"
    if [ "$(( ${page_size} > ${max_page_size_394} ))" != 0 ]; then
        page_size="${max_page_size_394}"
    fi
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__1846_v0 "${header}" "${term_width_392}"
        ret_cutoff_text1846_v0__107_17="${ret_cutoff_text1846_v0}"
        array_382=("")
        eprintf__1826_v0 "${ret_cutoff_text1846_v0__107_17}""
" array_382[@]
    fi
    __length_383=("${options[@]}")
    math_floor__416_v0 "$(( $(( $(( ${#__length_383[@]} + ${page_size} )) - 1 )) / ${page_size} ))"
    total_pages_418="${ret_math_floor416_v0}"
    current_page_419=0
    selected_420=0
    display_count_421="${page_size}"
    __length_384=("${options[@]}")
    if [ "$(( ${#__length_384[@]} < ${page_size} ))" != 0 ]; then
        __length_385=("${options[@]}")
        display_count_421="${#__length_385[@]}"
    fi
    new_line__1833_v0 "${display_count_421}"
    array_386=("")
    eprintf__1826_v0 "\\x1b[9999D" array_386[@]
    if [ "$(( ${total_pages_418} > 1 ))" != 0 ]; then
        eprintf_colored__1827_v0 "Page $(( ${current_page_419} + 1 ))/${total_pages_418}" 90
    fi
    new_line__1833_v0 1
    # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
    # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    if [ "$(( ${total_pages_418} > 1 ))" != 0 ]; then
        array_387=("↑↓" "select" "←→" "page" "enter" "confirm")
        render_tooltip__1847_v0 array_387[@] 36 "${term_width_392}"
    else
        array_388=("↑↓" "select" "enter" "confirm")
        render_tooltip__1847_v0 array_388[@] 25 "${term_width_392}"
    fi
    go_up__1834_v0 "$(( ${display_count_421} + 1 ))"
    array_389=("")
    eprintf__1826_v0 "\\x1b[9999D" array_389[@]
    get_page_options__1897_v0 options[@] "${current_page_419}" "${page_size}"
    page_options_437=("${ret_get_page_options1897_v0[@]}")
    render_choose_page__1899_v0 page_options_437[@] "${selected_420}" "${cursor}" "${display_count_421}" "${term_width_392}"
    while :
    do
        get_key__1824_v0 
        key_453="${ret_get_key1824_v0}"
        prev_selected_454="${selected_420}"
        prev_page_455="${current_page_419}"
        up_paged_456=0
        if [ "$(( $([ "_${key_453}" != "_UP" ]; echo $?) || $([ "_${key_453}" != "_k" ]; echo $?) ))" != 0 ]; then
            if [ "$(( $(( ${selected_420} == 0 )) && $(( ${total_pages_418} > 1 )) ))" != 0 ]; then
                if [ "$(( ${current_page_419} > 0 ))" != 0 ]; then
                    current_page_419="$(( ${current_page_419} - 1 ))"
                else
                    current_page_419="$(( ${total_pages_418} - 1 ))"
                fi
                up_paged_456=1
            elif [ "$(( ${selected_420} == 0 ))" != 0 ]; then
                __length_390=("${page_options_437[@]}")
                selected_420="$(( ${#__length_390[@]} - 1 ))"
            else
                selected_420="$(( ${selected_420} - 1 ))"
            fi
        elif [ "$(( $([ "_${key_453}" != "_DOWN" ]; echo $?) || $([ "_${key_453}" != "_j" ]; echo $?) ))" != 0 ]; then
            __length_391=("${page_options_437[@]}")
            if [ "$(( ${selected_420} == $(( ${#__length_391[@]} - 1 )) ))" != 0 ]; then
                if [ "$(( ${current_page_419} < $(( ${total_pages_418} - 1 )) ))" != 0 ]; then
                    current_page_419="$(( ${current_page_419} + 1 ))"
                    selected_420=0
                else
                    current_page_419=0
                    selected_420=0
                fi
            else
                selected_420="$(( ${selected_420} + 1 ))"
            fi
        elif [ "$(( $([ "_${key_453}" != "_LEFT" ]; echo $?) || $([ "_${key_453}" != "_h" ]; echo $?) ))" != 0 ]; then
            if [ "$(( ${current_page_419} > 0 ))" != 0 ]; then
                current_page_419="$(( ${current_page_419} - 1 ))"
                selected_420=0
            else
                selected_420=0
            fi
        elif [ "$(( $([ "_${key_453}" != "_RIGHT" ]; echo $?) || $([ "_${key_453}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "$(( ${current_page_419} < $(( ${total_pages_418} - 1 )) ))" != 0 ]; then
                current_page_419="$(( ${current_page_419} + 1 ))"
                selected_420=0
            else
                __length_392=("${page_options_437[@]}")
                selected_420="$(( ${#__length_392[@]} - 1 ))"
            fi
        elif [ "$([ "_${key_453}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
        __length_393="${cursor}"
        max_option_width_457="$(( $(( ${term_width_392} - ${#__length_393} )) - 1 ))"
        if [ "$(( ${prev_page_455} != ${current_page_419} ))" != 0 ]; then
            get_page_options__1897_v0 options[@] "${current_page_419}" "${page_size}"
            page_options_437=("${ret_get_page_options1897_v0[@]}")
            if [ "${up_paged_456}" != 0 ]; then
                __length_394=("${page_options_437[@]}")
                selected_420="$(( ${#__length_394[@]} - 1 ))"
            fi
            go_up__1834_v0 1
            remove_line__1830_v0 "$(( ${display_count_421} - 1 ))"
            remove_current_line__1831_v0 
            array_395=("")
            eprintf__1826_v0 "\\x1b[9999D" array_395[@]
            render_choose_page__1899_v0 page_options_437[@] "${selected_420}" "${cursor}" "${display_count_421}" "${term_width_392}"
            render_page_indicator__1901_v0 "${current_page_419}" "${total_pages_418}"
        elif [ "$(( ${prev_selected_454} != ${selected_420} ))" != 0 ]; then
            go_up__1834_v0 "$(( ${display_count_421} - ${prev_selected_454} ))"
            array_396=("")
            eprintf__1826_v0 "\\x1b[K" array_396[@]
            __length_397="${cursor}"
            print_blank__1832_v0 "${#__length_397}"
            cutoff_text__1846_v0 "${page_options_437[${prev_selected_454}]}" "${max_option_width_457}"
            ret_cutoff_text1846_v0__218_25="${ret_cutoff_text1846_v0}"
            array_398=("")
            eprintf__1826_v0 "${ret_cutoff_text1846_v0__218_25}" array_398[@]
            diff_458="$(( ${selected_420} - ${prev_selected_454} ))"
            go_up_or_down__1836_v0 "${diff_458}"
            array_399=("")
            eprintf__1826_v0 "\\x1b[9999D" array_399[@]
            array_400=("")
            eprintf__1826_v0 "\\x1b[K" array_400[@]
            cutoff_text__1846_v0 "${page_options_437[${selected_420}]}" "${max_option_width_457}"
            ret_cutoff_text1846_v0__224_52="${ret_cutoff_text1846_v0}"
            colored_secondary__1809_v0 "${cursor}""${ret_cutoff_text1846_v0__224_52}"
            ret_colored_secondary1809_v0__224_25="${ret_colored_secondary1809_v0}"
            array_401=("")
            eprintf__1826_v0 "${ret_colored_secondary1809_v0__224_25}" array_401[@]
            go_down__1835_v0 "$(( ${display_count_421} - ${selected_420} ))"
            array_402=("")
            eprintf__1826_v0 "\\x1b[9999D" array_402[@]
        fi
    done
    total_lines_459="$(( ${display_count_421} + 2 ))"
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_459="$(( ${total_lines_459} + 1 ))"
    fi
    go_down__1835_v0 1
    remove_line__1830_v0 "$(( ${total_lines_459} - 1 ))"
    remove_current_line__1831_v0 
    stty_unlock__1789_v0 
    show_cursor__1838_v0 
    global_selected_462="$(( $(( ${current_page_419} * ${page_size} )) + ${selected_420} ))"
    ret_xyl_choose1902_v0="${options[${global_selected_462}]}"
    return 0
}

format_entry_display__1906_v0() {
    local entry=("${!1}")
    name_381="${entry[0]}"
    file_type_382="${entry[1]}"
    if [ "$([ "_${file_type_382}" != "_d" ]; echo $?)" != 0 ]; then
        colored_primary__1613_v0 "/"
        ret_colored_primary1613_v0__13_23="${ret_colored_primary1613_v0}"
        ret_format_entry_display1906_v0="${name_381}""${ret_colored_primary1613_v0__13_23}"
        return 0
    fi
    if [ "$([ "_${file_type_382}" != "_l" ]; echo $?)" != 0 ]; then
        colored_accent__1615_v0 " > "
        ret_colored_accent1615_v0__16_23="${ret_colored_accent1615_v0}"
        colored_primary__1613_v0 "${entry[2]}"
        ret_colored_primary1613_v0__16_47="${ret_colored_primary1613_v0}"
        ret_format_entry_display1906_v0="${name_381}""${ret_colored_accent1615_v0__16_23}""${ret_colored_primary1613_v0__16_47}"
        return 0
    fi
    ret_format_entry_display1906_v0="${name_381}"
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
    current_path_362="${start_path}"
    if [ "$([ "_${current_path_362}" != "_" ]; echo $?)" != 0 ]; then
        get_cwd__1572_v0 
        current_path_362="${ret_get_cwd1572_v0}"
    fi
    normalize_path__1573_v0 "${current_path_362}"
    current_path_362="${ret_normalize_path1573_v0}"
    while :
    do
        colored_primary__1613_v0 "Loading files..."
        ret_colored_primary1613_v0__47_17="${ret_colored_primary1613_v0}"
        array_404=("")
        eprintf__1631_v0 "${ret_colored_primary1613_v0__47_17}" array_404[@]
        # Get directory entries
        get_directory_entries__1570_v0 "${current_path_362}"
        raw_entries_374=("${ret_get_directory_entries1570_v0[@]}")
        # Build options list and parallel entries list
        options_375=()
        entries_376=()
        # Add parent directory entry (..)
        if [ "$([ "_${current_path_362}" == "_/" ]; echo $?)" != 0 ]; then
            options_375+=("..")
            entries_376+=("..	d")
        fi
        for raw_entry_377 in "${raw_entries_374[@]}"; do
            parse_entry__1571_v0 "${raw_entry_377}"
            entry_378=("${ret_parse_entry1571_v0[@]}")
            name_379="${entry_378[0]}"
            # Skip hidden files if not showing them
            command_409="$(echo "${name_379}" | cut -c1)"
            __status=$?
            first_char_380="${command_409}"
            if [ "$(( $(( ! ${show_hidden} )) && $([ "_${first_char_380}" != "_." ]; echo $?) ))" != 0 ]; then
                continue
            fi
            format_entry_display__1906_v0 entry_378[@]
            ret_format_entry_display1906_v0__70_25="${ret_format_entry_display1906_v0}"
            options_375+=("${ret_format_entry_display1906_v0__70_25}")
            entries_376+=("${raw_entry_377}")
        done
        __length_412=("${entries_376[@]}")
        if [ "$(( ${#__length_412[@]} == 0 ))" != 0 ]; then
            eprintf_colored__1632_v0 "ERROR: Directory is empty or inaccessible.
" 31
            stty_unlock__1594_v0 
            ret_xyl_file1907_v0=""
            return 0
        fi
        # Use xyl_choose with current path as header
        colored_primary__1613_v0 "${current_path_362}"
        header_385="${ret_colored_primary1613_v0}"
        remove_current_line__1636_v0 
        xyl_choose__1902_v0 options_375[@] "${cursor}" "${header_385}" "${page_size}"
        selected_option_463="${ret_xyl_choose1902_v0}"
        # Find selected entry index
        selected_idx_464=-1
        from=0
        __length_413=("${options_375[@]}")
        to="${#__length_413[@]}"
        for i_465 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
            if [ "$([ "_${options_375[${i_465}]}" != "_${selected_option_463}" ]; echo $?)" != 0 ]; then
                selected_idx_464="${i_465}"
                break
            fi
        done
        if [ "$(( ${selected_idx_464} < 0 ))" != 0 ]; then
            ret_xyl_file1907_v0=""
            return 0
        fi
        parse_entry__1571_v0 "${entries_376[${selected_idx_464}]}"
        entry_466=("${ret_parse_entry1571_v0[@]}")
        name_467="${entry_466[0]}"
        file_type_468="${entry_466[1]}"
        if [ "$([ "_${name_467}" != "_.." ]; echo $?)" != 0 ]; then
            get_parent_dir__1576_v0 "${current_path_362}"
            current_path_362="${ret_get_parent_dir1576_v0}"
        elif [ "$([ "_${file_type_468}" != "_d" ]; echo $?)" != 0 ]; then
            path_join__1575_v0 "${current_path_362}" "${name_467}"
            current_path_362="${ret_path_join1575_v0}"
            normalize_path__1573_v0 "${current_path_362}"
            current_path_362="${ret_normalize_path1573_v0}"
        elif [ "$([ "_${file_type_468}" != "_l" ]; echo $?)" != 0 ]; then
            # For symlinks, check if they point to a directory
            starts_with__23_v0 "${entry_466[2]}" "/"
            ret_starts_with23_v0__113_20="${ret_starts_with23_v0}"
            if [ "${ret_starts_with23_v0__113_20}" != 0 ]; then
                current_path_362="${entry_466[2]}"
                normalize_path__1573_v0 "${current_path_362}"
                current_path_362="${ret_normalize_path1573_v0}"
            else
                stty_unlock__1594_v0 
                path_join__1575_v0 "${current_path_362}" "${entry_466[2]}"
                ret_xyl_file1907_v0="${ret_path_join1575_v0}"
                return 0
            fi
        else
            stty_unlock__1594_v0 
            path_join__1575_v0 "${current_path_362}" "${name_467}"
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
    cursor_338="> "
    start_path_339=""
    show_hidden_340=0
    page_size_341=10
    for param_342 in "${parameters[@]:2:9997}"; do
        match_regex__20_v0 "${param_342}" "^-h\$" 0
        ret_match_regex20_v0__14_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_342}" "^--help\$" 0
        ret_match_regex20_v0__14_43="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_342}" "^--cursor=.*\$" 0
        ret_match_regex20_v0__18_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_342}" "^--path=.*\$" 0
        ret_match_regex20_v0__22_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_342}" "^-a\$" 0
        ret_match_regex20_v0__26_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_342}" "^--all\$" 0
        ret_match_regex20_v0__26_43="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_342}" "^--page-size=.*\$" 0
        ret_match_regex20_v0__29_13="${ret_match_regex20_v0}"
        if [ "$(( ${ret_match_regex20_v0__14_13} || ${ret_match_regex20_v0__14_43} ))" != 0 ]; then
            print_file_help__1983_v0 
            exit 0
        elif [ "${ret_match_regex20_v0__18_13}" != 0 ]; then
            split__5_v0 "${param_342}" "="
            result_351=("${ret_split5_v0[@]}")
            cursor_338="${result_351[1]}"
        elif [ "${ret_match_regex20_v0__22_13}" != 0 ]; then
            split__5_v0 "${param_342}" "="
            result_352=("${ret_split5_v0[@]}")
            start_path_339="${result_352[1]}"
        elif [ "$(( ${ret_match_regex20_v0__26_13} || ${ret_match_regex20_v0__26_43} ))" != 0 ]; then
            show_hidden_340=1
        elif [ "${ret_match_regex20_v0__29_13}" != 0 ]; then
            split__5_v0 "${param_342}" "="
            result_353=("${ret_split5_v0[@]}")
            parse_int__14_v0 "${result_353[1]}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1632_v0 "ERROR: Invalid page-size value: ""${result_353[1]}""
" 31
                exit 1
            fi
            page_size_341="${ret_parse_int14_v0}"
        else
            # Treat as start path if not a flag
            start_path_339="${param_342}"
        fi
    done
    xyl_file__1907_v0 "${start_path_339}" "${cursor_338}" "${show_hidden_340}" "${page_size_341}"
    ret_execute_file2034_v0="${ret_xyl_file1907_v0}"
    return 0
}

# #!/usr/bin/env amber
__VERSION_57="0.1.0"
__AMBER_VERSION_58="0.5.1-alpha"
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

declare -r args_59=("$0" "$@")
trap_cleanup__2037_v0 
check_prerequirements__2036_v0 
ret_check_prerequirements2036_v0__32_12="${ret_check_prerequirements2036_v0}"
if [ "$(( ! ${ret_check_prerequirements2036_v0__32_12} ))" != 0 ]; then
    exit 1
fi
__length_423=("${args_59[@]}")
if [ "$(( $(( $(( $(( ${#__length_423[@]} < 2 )) || $([ "_${args_59[1]}" != "_help" ]; echo $?) )) || $([ "_${args_59[1]}" != "_--help" ]; echo $?) )) || $([ "_${args_59[1]}" != "_-h" ]; echo $?) ))" != 0 ]; then
    print_help__358_v0 
elif [ "$([ "_${args_59[1]}" != "_input" ]; echo $?)" != 0 ]; then
    execute_input__716_v0 args_59[@]
    ret_execute_input716_v0__39_18="${ret_execute_input716_v0}"
    echo "${ret_execute_input716_v0__39_18}"
elif [ "$([ "_${args_59[1]}" != "_choose" ]; echo $?)" != 0 ]; then
    execute_choose__1078_v0 args_59[@]
    ret_execute_choose1078_v0__42_18="${ret_execute_choose1078_v0}"
    echo "${ret_execute_choose1078_v0__42_18}"
elif [ "$([ "_${args_59[1]}" != "_confirm" ]; echo $?)" != 0 ]; then
    execute_confirm__1452_v0 args_59[@]
    result_337="${ret_execute_confirm1452_v0}"
    if [ "$([ "_${result_337}" != "_yes" ]; echo $?)" != 0 ]; then
        exit 0
    else
        exit 1
    fi
elif [ "$([ "_${args_59[1]}" != "_file" ]; echo $?)" != 0 ]; then
    execute_file__2034_v0 args_59[@]
    ret_execute_file2034_v0__52_18="${ret_execute_file2034_v0}"
    echo "${ret_execute_file2034_v0__52_18}"
elif [ "$(( $(( $([ "_${args_59[1]}" != "_version" ]; echo $?) || $([ "_${args_59[1]}" != "_--version" ]; echo $?) )) || $([ "_${args_59[1]}" != "_-v" ]; echo $?) ))" != 0 ]; then
    colored_primary__194_v0 "xylitol.sh"
    ret_colored_primary194_v0__55_20="${ret_colored_primary194_v0}"
    array_424=("")
    printf__106_v0 "${ret_colored_primary194_v0__55_20}" array_424[@]
    array_425=("")
    printf__106_v0 " version: " array_425[@]
    colored_accent__196_v0 "${__VERSION_57}"
    ret_colored_accent196_v0__57_20="${ret_colored_accent196_v0}"
    array_426=("")
    printf__106_v0 "${ret_colored_accent196_v0__57_20}" array_426[@]
    echo ""
    printf_colored__211_v0 "written in Amber: " 90
    printf_colored__211_v0 "  ""${__AMBER_VERSION_58}" 90
else
    print_help__358_v0 
    printf_colored__211_v0 "ERROR: Unknown command '""${args_59[1]}""'" 91
fi
