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
    result_480="${command_10}"
    ret_starts_with23_v0="$([ "_${result_480}" != "_1" ]; echo $?)"
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
    if [ "$(( ${cnt} > 0 ))" != 0 ]; then
        array_62=("")
        eprintf__518_v0 "\\x1b[${cnt}D\\x1b[K" array_62[@]
    fi
}

remove_line__522_v0() {
    local cnt=$1
    if [ "$(( ${cnt} > 0 ))" != 0 ]; then
        sequence_140=""
        from=0
        to="${cnt}"
        for ____141 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
            sequence_140+="\\x1b[2K\\x1b[1A"
        done
        array_63=("")
        eprintf__518_v0 "${sequence_140}" array_63[@]
    fi
    array_64=("")
    eprintf__518_v0 "\\x1b[9999D" array_64[@]
}

remove_current_line__523_v0() {
    array_65=("")
    eprintf__518_v0 "\\x1b[2K\\x1b[9999D" array_65[@]
}

new_line__525_v0() {
    local cnt=$1
    from=0
    to="${cnt}"
    for i_122 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        array_66=("")
        eprintf__518_v0 "
" array_66[@]
    done
}

go_up__526_v0() {
    local cnt=$1
    array_67=("")
    eprintf__518_v0 "\\x1b[${cnt}A" array_67[@]
}

go_down__527_v0() {
    local cnt=$1
    array_68=("")
    eprintf__518_v0 "\\x1b[${cnt}B" array_68[@]
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
has_ansi_escape__531_v0() {
    local text=$1
    # Check for ESC character (0x1B = 27) or literal \x1b[
    command_69="$([[ "${text}" == *$'\x1b'* || "${text}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    has_escape_91="${command_69}"
    ret_has_ansi_escape531_v0="$([ "_${has_escape_91}" != "_1" ]; echo $?)"
    return 0
}

escape_ansi__532_v0() {
    local text=$1
    command_70="$(printf '%s' "${text}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi532_v0="${command_70}"
    return 0
}

strip_ansi__533_v0() {
    local text=$1
    command_71="$(printf "%s" "${text}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi533_v0="${command_71}"
    return 0
}

is_all_ascii__534_v0() {
    local text=$1
    command_72="$(printf "%s" "${text}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    result_101="${command_72}"
    ret_is_all_ascii534_v0="$([ "_${result_101}" != "_0" ]; echo $?)"
    return 0
}

get_visible_len__535_v0() {
    local text=$1
    strip_ansi__533_v0 "${text}"
    stripped_100="${ret_strip_ansi533_v0}"
    # Check if text is all ASCII
    is_all_ascii__534_v0 "${stripped_100}"
    ret_is_all_ascii534_v0__150_12="${ret_is_all_ascii534_v0}"
    if [ "$(( ! ${ret_is_all_ascii534_v0__150_12} ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__472_v0 "${stripped_100}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            __length_73="${stripped_100}"
            ret_get_visible_len535_v0="${#__length_73}"
            return 0
        fi
        ret_get_visible_len535_v0="${ret_perl_get_cjk_width472_v0}"
        return 0
    else
        __length_74="${stripped_100}"
        ret_get_visible_len535_v0="${#__length_74}"
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
    ret_is_all_ascii534_v0__167_12="${ret_is_all_ascii534_v0}"
    if [ "$(( ! ${ret_is_all_ascii534_v0__167_12} ))" != 0 ]; then
        perl_truncate_cjk__473_v0 "${text}" "${max_width}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text}" | cut -c1-${max_width}
            __status=$?
        fi
        ret_truncate_text536_v0="${ret_perl_truncate_cjk473_v0}"
        return 0
    fi
    command_75="$(printf "%s" "${text}" | cut -c1-${max_width})"
    __status=$?
    ret_truncate_text536_v0="${command_75}"
    return 0
}

truncate_ansi__537_v0() {
    local text=$1
    local max_width=$2
    has_ansi_escape__531_v0 "${text}"
    ret_has_ansi_escape531_v0__179_12="${ret_has_ansi_escape531_v0}"
    if [ "$(( ! ${ret_has_ansi_escape531_v0__179_12} ))" != 0 ]; then
        truncate_text__536_v0 "${text}" "${max_width}"
        ret_truncate_ansi537_v0="${ret_truncate_text536_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    command_76="$([[ "${text}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    starts_with_ansi_107="${command_76}"
    # Replace \x1b[ with newline, then split
    command_77="$(t="${text}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    replaced_108="${command_77}"
    split__5_v0 "${replaced_108}" "
"
    parts_109=("${ret_split5_v0[@]}")
    result_110=""
    remaining_width_111="${max_width}"
    from=0
    __length_78=("${parts_109[@]}")
    to="${#__length_78[@]}"
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
                ret_get_visible_len535_v0__203_36="${ret_get_visible_len535_v0}"
                remaining_width_111="$(( ${remaining_width_111} - ${ret_get_visible_len535_v0__203_36} ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            command_79="$(__p="${part_113}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            m_idx_115="${command_79}"
            if [ "$([ "_${m_idx_115}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                command_80="$(__p="${part_113}"; printf "%s" "${__p:0:${m_idx_115}}")"
                __status=$?
                ansi_params_116="${command_80}"
                result_110+="\\x1b[""${ansi_params_116}""m"
                # Rest is text content
                parse_int__14_v0 "${m_idx_115}"
                __status=$?
                m_idx_num_117="${ret_parse_int14_v0}"
                text_start_118="$(( ${m_idx_num_117} + 1 ))"
                command_81="$(__p="${part_113}"; printf "%s" "${__p:${text_start_118}}")"
                __status=$?
                text_part_119="${command_81}"
                if [ "$(( $([ "_${text_part_119}" == "_" ]; echo $?) && $(( ${remaining_width_111} > 0 )) ))" != 0 ]; then
                    truncate_text__536_v0 "${text_part_119}" "${remaining_width_111}"
                    truncated_120="${ret_truncate_text536_v0}"
                    result_110+="${truncated_120}"
                    get_visible_len__535_v0 "${truncated_120}"
                    ret_get_visible_len535_v0__220_40="${ret_get_visible_len535_v0}"
                    remaining_width_111="$(( ${remaining_width_111} - ${ret_get_visible_len535_v0__220_40} ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_113}" == "_" ]; echo $?) && $(( ${remaining_width_111} > 0 )) ))" != 0 ]; then
                    truncate_text__536_v0 "${part_113}" "${remaining_width_111}"
                    truncated_121="${ret_truncate_text536_v0}"
                    result_110+="${truncated_121}"
                    get_visible_len__535_v0 "${truncated_121}"
                    remaining_width_111="$(( ${remaining_width_111} - ${ret_get_visible_len535_v0__227_40} ))"
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
    ret_truncate_ansi537_v0__243_12="${ret_truncate_ansi537_v0}"
    ret_cutoff_text538_v0="${ret_truncate_ansi537_v0__243_12}""..."
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
            __length_82=("${items[@]}")
            if [ "$(( ${iter_125} >= ${#__length_82[@]} ))" != 0 ]; then
                break
            elif [ "$(( ${iter_125} > 0 ))" != 0 ]; then
                eprintf_colored__519_v0 "${separator_123}" 90
            fi
            colored__520_v0 "${items[$(( ${iter_125} + 1 ))]}" 2
            ret_colored520_v0__268_41="${ret_colored520_v0}"
            array_83=("")
            eprintf__518_v0 "${items[${iter_125}]}"" ""${ret_colored520_v0__268_41}" array_83[@]
            iter_125="$(( ${iter_125} + 2 ))"
        done
    else
        # Slow path: truncate
        current_len_126=0
        first_127=1
        iter_128=0
        while :
        do
            __length_84=("${items[@]}")
            if [ "$(( ${iter_128} >= ${#__length_84[@]} ))" != 0 ]; then
                break
            fi
            key_129="${items[${iter_128}]}"
            action_130="${items[$(( ${iter_128} + 1 ))]}"
            __length_85="${key_129}"
            __length_86="${action_130}"
            part_len_131="$(( $(( ${#__length_85} + 1 )) + ${#__length_86} ))"
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
            ret_colored520_v0__296_33="${ret_colored520_v0}"
            array_87=("")
            eprintf__518_v0 "${key_129}"" ""${ret_colored520_v0__296_33}" array_87[@]
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
        array_88=("")
        eprintf__518_v0 "${ret_cutoff_text538_v0__23_17}""
" array_88[@]
    fi
    new_line__525_v0 2
    # "enter submit" = 12
    array_89=("enter" "submit")
    render_tooltip__539_v0 array_89[@] 12 "${term_width_99}"
    go_up__526_v0 2
    array_90=("")
    eprintf__518_v0 "\\x1b[99999D" array_90[@]
    array_91=("")
    eprintf__518_v0 "${prompt}" array_91[@]
    eprintf_colored__519_v0 "${placeholder}" 90
    get_char__515_v0 
    char_134="${ret_get_char515_v0}"
    __length_92="${prompt}"
    remove__521_v0 "${#__length_92}"
    __length_93="${placeholder}"
    remove__521_v0 "$(( ${#__length_93} + 1 ))"
    text_135=""
    if [ "$(( ! ${password} ))" != 0 ]; then
        stty_unlock__481_v0 
        command_94="$(read -e -i ${char_134} -p "${prompt}" text < /dev/tty; printf "%s" "$text")"
        __status=$?
        text_135="${command_94}"
    else
        stty_unlock__481_v0 
        command_95="$(read -es -i ${char_134} -p "${prompt}" text < /dev/tty; printf "%s" "$text")"
        __status=$?
        text_135="${command_95}"
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
    array_96=("")
    printf__106_v0 "${ret_colored_primary500_v0__7_12}" array_96[@]
    array_97=("")
    printf__106_v0 " - Prompt for some input from the user." array_97[@]
    echo ""
    echo ""
    colored_secondary__501_v0 "Flags: "
    ret_colored_secondary501_v0__11_12="${ret_colored_secondary501_v0}"
    array_98=("")
    printf__106_v0 "${ret_colored_secondary501_v0__11_12}""
" array_98[@]
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
command_99="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_21="$([ "_${command_99}" != "_No" ]; echo $?)"
command_100="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_22="$(( $(( ! ${_perl_disabled_21} )) && $([ "_${command_100}" != "_0" ]; echo $?) ))"
perl_get_cjk_width__825_v0() {
    local text=$1
    if [ "$(( ! ${_perl_available_22} ))" != 0 ]; then
        ret_perl_get_cjk_width825_v0=''
        return 1
    fi
    command_101="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width825_v0=''
        return "${__status}"
    fi
    width_str_176="${command_101}"
    parse_int__14_v0 "${width_str_176}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width825_v0=''
        return "${__status}"
    fi
    width_177="${ret_parse_int14_v0}"
    ret_perl_get_cjk_width825_v0="${width_177}"
    return 0
}

perl_truncate_cjk__826_v0() {
    local text=$1
    local max_width=$2
    if [ "$(( ! ${_perl_available_22} ))" != 0 ]; then
        ret_perl_truncate_cjk826_v0=''
        return 1
    fi
    command_102="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text}" ${max_width} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk826_v0=''
        return "${__status}"
    fi
    result_180="${command_102}"
    ret_perl_truncate_cjk826_v0="${result_180}"
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
    command_104="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_165="${command_104}"
    parse_int__14_v0 "${count_165}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_166="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_166} == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_166="$(( ${count_num_166} + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_166}
    __status=$?
}

stty_unlock__834_v0() {
    command_105="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_250="${command_105}"
    parse_int__14_v0 "${count_250}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_251="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_251} > 0 ))" != 0 ]; then
        count_num_251="$(( ${count_num_251} - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_251}
        __status=$?
        if [ "$(( ${count_num_251} == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

get_term_size__835_v0() {
    # Query terminal size with \x1b[18t, response format: \x1b[8;rows;colst
    command_106="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -rsd t _ignore height width < /dev/tty; echo "$height; $width")"
    __status=$?
    result_167="${command_106}"
    split__5_v0 "${result_167}" ";"
    parts_168=("${ret_split5_v0[@]}")
    __length_107=("${parts_168[@]}")
    if [ "$(( ${#__length_107[@]} != 2 ))" != 0 ]; then
        ret_get_term_size835_v0=''
        return 1
    fi
    parse_int__14_v0 "${parts_168[0]}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_term_size835_v0=''
        return "${__status}"
    fi
    rows_169="${ret_parse_int14_v0}"
    parse_int__14_v0 "${parts_168[1]}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_term_size835_v0=''
        return "${__status}"
    fi
    cols_170="${ret_parse_int14_v0}"
    _term_size_24=("${cols_170}" "${rows_169}")
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
    config_149="${ret_env_var_get98_v0}"
    if [ "$([ "_${config_149}" != "_No" ]; echo $?)" != 0 ]; then
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
    colorterm_150="${ret_env_var_get98_v0}"
    _supports_truecolor_25="$(if [ "$(( $([ "_${colorterm_150}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_150}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
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
        primary_env_143="${ret_env_var_get98_v0}"
        if [ "$([ "_${primary_env_143}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${primary_env_143}" ";"
            parts_144=("${ret_split5_v0[@]}")
            __length_112=("${parts_144[@]}")
            if [ "$(( ${#__length_112[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_144[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__115_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_144[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__116_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_144[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__117_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_144[3]}"
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
        secondary_env_145="${ret_env_var_get98_v0}"
        if [ "$([ "_${secondary_env_145}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${secondary_env_145}" ";"
            parts_146=("${ret_split5_v0[@]}")
            __length_114=("${parts_146[@]}")
            if [ "$(( ${#__length_114[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_146[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__128_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_146[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__129_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_146[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__130_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_146[3]}"
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
        accent_env_147="${ret_env_var_get98_v0}"
        if [ "$([ "_${accent_env_147}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${accent_env_147}" ";"
            parts_148=("${ret_split5_v0[@]}")
            __length_116=("${parts_148[@]}")
            if [ "$(( ${#__length_116[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_148[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__141_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_148[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__142_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_148[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors851_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__143_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_148[3]}"
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
    command_118="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    var_228="${command_118}"
    if [ "$([ "_${var_228}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key869_v0="UP"
        return 0
    elif [ "$([ "_${var_228}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key869_v0="DOWN"
        return 0
    elif [ "$([ "_${var_228}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key869_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_228}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key869_v0="LEFT"
        return 0
    elif [ "$([ "_${var_228}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key869_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_228}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key869_v0="INPUT"
        return 0
    else
        ret_get_key869_v0="${var_228}"
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
    array_119=("${message}")
    eprintf__871_v0 "\\x1b[${color}m%s\\x1b[0m" array_119[@]
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
    if [ "$(( ${cnt} > 0 ))" != 0 ]; then
        sequence_241=""
        from=0
        to="${cnt}"
        for ____242 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
            sequence_241+="\\x1b[2K\\x1b[1A"
        done
        array_120=("")
        eprintf__871_v0 "${sequence_241}" array_120[@]
    fi
    array_121=("")
    eprintf__871_v0 "\\x1b[9999D" array_121[@]
}

remove_current_line__876_v0() {
    array_122=("")
    eprintf__871_v0 "\\x1b[2K\\x1b[9999D" array_122[@]
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
    for i_200 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        array_123=("")
        eprintf__871_v0 "
" array_123[@]
    done
}

go_up__879_v0() {
    local cnt=$1
    array_124=("")
    eprintf__871_v0 "\\x1b[${cnt}A" array_124[@]
}

go_down__880_v0() {
    local cnt=$1
    array_125=("")
    eprintf__871_v0 "\\x1b[${cnt}B" array_125[@]
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
    array_126=("")
    eprintf__871_v0 "\\x1b[?25l" array_126[@]
}

show_cursor__883_v0() {
    array_127=("")
    eprintf__871_v0 "\\x1b[?25h" array_127[@]
}

# / Text Utilities /////
has_ansi_escape__884_v0() {
    local text=$1
    # Check for ESC character (0x1B = 27) or literal \x1b[
    command_128="$([[ "${text}" == *$'\x1b'* || "${text}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    has_escape_163="${command_128}"
    ret_has_ansi_escape884_v0="$([ "_${has_escape_163}" != "_1" ]; echo $?)"
    return 0
}

escape_ansi__885_v0() {
    local text=$1
    command_129="$(printf '%s' "${text}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi885_v0="${command_129}"
    return 0
}

strip_ansi__886_v0() {
    local text=$1
    command_130="$(printf "%s" "${text}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi886_v0="${command_130}"
    return 0
}

is_all_ascii__887_v0() {
    local text=$1
    command_131="$(printf "%s" "${text}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    result_175="${command_131}"
    ret_is_all_ascii887_v0="$([ "_${result_175}" != "_0" ]; echo $?)"
    return 0
}

get_visible_len__888_v0() {
    local text=$1
    strip_ansi__886_v0 "${text}"
    stripped_174="${ret_strip_ansi886_v0}"
    # Check if text is all ASCII
    is_all_ascii__887_v0 "${stripped_174}"
    ret_is_all_ascii887_v0__150_12="${ret_is_all_ascii887_v0}"
    if [ "$(( ! ${ret_is_all_ascii887_v0__150_12} ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__825_v0 "${stripped_174}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            __length_132="${stripped_174}"
            ret_get_visible_len888_v0="${#__length_132}"
            return 0
        fi
        ret_get_visible_len888_v0="${ret_perl_get_cjk_width825_v0}"
        return 0
    else
        __length_133="${stripped_174}"
        ret_get_visible_len888_v0="${#__length_133}"
        return 0
    fi
}

truncate_text__889_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__888_v0 "${text}"
    visible_len_179="${ret_get_visible_len888_v0}"
    if [ "$(( ${visible_len_179} <= ${max_width} ))" != 0 ]; then
        ret_truncate_text889_v0="${text}"
        return 0
    fi
    is_all_ascii__887_v0 "${text}"
    ret_is_all_ascii887_v0__167_12="${ret_is_all_ascii887_v0}"
    if [ "$(( ! ${ret_is_all_ascii887_v0__167_12} ))" != 0 ]; then
        perl_truncate_cjk__826_v0 "${text}" "${max_width}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text}" | cut -c1-${max_width}
            __status=$?
        fi
        ret_truncate_text889_v0="${ret_perl_truncate_cjk826_v0}"
        return 0
    fi
    command_134="$(printf "%s" "${text}" | cut -c1-${max_width})"
    __status=$?
    ret_truncate_text889_v0="${command_134}"
    return 0
}

truncate_ansi__890_v0() {
    local text=$1
    local max_width=$2
    has_ansi_escape__884_v0 "${text}"
    ret_has_ansi_escape884_v0__179_12="${ret_has_ansi_escape884_v0}"
    if [ "$(( ! ${ret_has_ansi_escape884_v0__179_12} ))" != 0 ]; then
        truncate_text__889_v0 "${text}" "${max_width}"
        ret_truncate_ansi890_v0="${ret_truncate_text889_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    command_135="$([[ "${text}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    starts_with_ansi_181="${command_135}"
    # Replace \x1b[ with newline, then split
    command_136="$(t="${text}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    replaced_182="${command_136}"
    split__5_v0 "${replaced_182}" "
"
    parts_183=("${ret_split5_v0[@]}")
    result_184=""
    remaining_width_185="${max_width}"
    from=0
    __length_137=("${parts_183[@]}")
    to="${#__length_137[@]}"
    for idx_186 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        part_187="${parts_183[${idx_186}]}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( ${idx_186} == 0 )) && $([ "_${starts_with_ansi_181}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_187}" == "_" ]; echo $?) && $(( ${remaining_width_185} > 0 )) ))" != 0 ]; then
                truncate_text__889_v0 "${part_187}" "${remaining_width_185}"
                truncated_188="${ret_truncate_text889_v0}"
                result_184+="${truncated_188}"
                get_visible_len__888_v0 "${truncated_188}"
                ret_get_visible_len888_v0__203_36="${ret_get_visible_len888_v0}"
                remaining_width_185="$(( ${remaining_width_185} - ${ret_get_visible_len888_v0__203_36} ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            command_138="$(__p="${part_187}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            m_idx_189="${command_138}"
            if [ "$([ "_${m_idx_189}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                command_139="$(__p="${part_187}"; printf "%s" "${__p:0:${m_idx_189}}")"
                __status=$?
                ansi_params_190="${command_139}"
                result_184+="\\x1b[""${ansi_params_190}""m"
                # Rest is text content
                parse_int__14_v0 "${m_idx_189}"
                __status=$?
                m_idx_num_191="${ret_parse_int14_v0}"
                text_start_192="$(( ${m_idx_num_191} + 1 ))"
                command_140="$(__p="${part_187}"; printf "%s" "${__p:${text_start_192}}")"
                __status=$?
                text_part_193="${command_140}"
                if [ "$(( $([ "_${text_part_193}" == "_" ]; echo $?) && $(( ${remaining_width_185} > 0 )) ))" != 0 ]; then
                    truncate_text__889_v0 "${text_part_193}" "${remaining_width_185}"
                    truncated_194="${ret_truncate_text889_v0}"
                    result_184+="${truncated_194}"
                    get_visible_len__888_v0 "${truncated_194}"
                    ret_get_visible_len888_v0__220_40="${ret_get_visible_len888_v0}"
                    remaining_width_185="$(( ${remaining_width_185} - ${ret_get_visible_len888_v0__220_40} ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_187}" == "_" ]; echo $?) && $(( ${remaining_width_185} > 0 )) ))" != 0 ]; then
                    truncate_text__889_v0 "${part_187}" "${remaining_width_185}"
                    truncated_195="${ret_truncate_text889_v0}"
                    result_184+="${truncated_195}"
                    get_visible_len__888_v0 "${truncated_195}"
                    remaining_width_185="$(( ${remaining_width_185} - ${ret_get_visible_len888_v0__227_40} ))"
                fi
            fi
        fi
    done
    ret_truncate_ansi890_v0="${result_184}"
    return 0
}

cutoff_text__891_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__888_v0 "${text}"
    visible_len_178="${ret_get_visible_len888_v0}"
    if [ "$(( ${visible_len_178} <= ${max_width} ))" != 0 ]; then
        ret_cutoff_text891_v0="${text}"
        return 0
    fi
    truncate_ansi__890_v0 "${text}" "$(( ${max_width} - 3 ))"
    ret_truncate_ansi890_v0__243_12="${ret_truncate_ansi890_v0}"
    ret_cutoff_text891_v0="${ret_truncate_ansi890_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
render_tooltip__892_v0() {
    local items=("${!1}")
    local total_len=$2
    local term_width=$3
    separator_201=" • "
    separator_len_202=3
    # Fast path: no truncation needed
    if [ "$(( ${total_len} <= ${term_width} ))" != 0 ]; then
        iter_203=0
        while :
        do
            __length_141=("${items[@]}")
            if [ "$(( ${iter_203} >= ${#__length_141[@]} ))" != 0 ]; then
                break
            elif [ "$(( ${iter_203} > 0 ))" != 0 ]; then
                eprintf_colored__872_v0 "${separator_201}" 90
            fi
            colored__873_v0 "${items[$(( ${iter_203} + 1 ))]}" 2
            ret_colored873_v0__268_41="${ret_colored873_v0}"
            array_142=("")
            eprintf__871_v0 "${items[${iter_203}]}"" ""${ret_colored873_v0__268_41}" array_142[@]
            iter_203="$(( ${iter_203} + 2 ))"
        done
    else
        # Slow path: truncate
        current_len_204=0
        first_205=1
        iter_206=0
        while :
        do
            __length_143=("${items[@]}")
            if [ "$(( ${iter_206} >= ${#__length_143[@]} ))" != 0 ]; then
                break
            fi
            key_207="${items[${iter_206}]}"
            action_208="${items[$(( ${iter_206} + 1 ))]}"
            __length_144="${key_207}"
            __length_145="${action_208}"
            part_len_209="$(( $(( ${#__length_144} + 1 )) + ${#__length_145} ))"
            needed_210="${part_len_209}"
            if [ "$(( ! ${first_205} ))" != 0 ]; then
                needed_210="$(( ${needed_210} + ${separator_len_202} ))"
            fi
            if [ "$(( $(( ${current_len_204} + ${needed_210} )) > ${term_width} ))" != 0 ]; then
                break
            fi
            if [ "$(( ! ${first_205} ))" != 0 ]; then
                eprintf_colored__872_v0 "${separator_201}" 90
            fi
            colored__873_v0 "${action_208}" 2
            ret_colored873_v0__296_33="${ret_colored873_v0}"
            array_146=("")
            eprintf__871_v0 "${key_207}"" ""${ret_colored873_v0__296_33}" array_146[@]
            current_len_204="$(( ${current_len_204} + ${needed_210} ))"
            first_205=0
            iter_206="$(( ${iter_206} + 2 ))"
        done
    fi
}

get_page_options__942_v0() {
    local options=("${!1}")
    local page=$2
    local page_size=$3
    start_213="$(( ${page} * ${page_size} ))"
    end_214="$(( ${start_213} + ${page_size} ))"
    __length_147=("${options[@]}")
    if [ "$(( ${end_214} > ${#__length_147[@]} ))" != 0 ]; then
        __length_148=("${options[@]}")
        end_214="${#__length_148[@]}"
    fi
    result_215=()
    from="${start_213}"
    to="${end_214}"
    for i_216 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        result_215+=("${options[${i_216}]}")
    done
    ret_get_page_options942_v0=("${result_215[@]}")
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
    __length_151="${cursor}"
    cursor_len_261="${#__length_151}"
    max_option_width_262="$(( $(( ${term_width} - ${cursor_len_261} )) - 1 ))"
    from=0
    __length_152=("${page_options[@]}")
    to="${#__length_152[@]}"
    for i_263 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        cutoff_text__891_v0 "${page_options[${i_263}]}" "${max_option_width_262}"
        truncated_option_264="${ret_cutoff_text891_v0}"
        if [ "$(( ${i_263} == ${sel} ))" != 0 ]; then
            colored_secondary__854_v0 "${cursor}""${truncated_option_264}""
"
            ret_colored_secondary854_v0__28_21="${ret_colored_secondary854_v0}"
            array_153=("")
            eprintf__871_v0 "${ret_colored_secondary854_v0__28_21}" array_153[@]
        else
            print_blank__877_v0 "${cursor_len_261}"
            array_154=("")
            eprintf__871_v0 "${truncated_option_264}""
" array_154[@]
        fi
    done
    __length_155=("${page_options[@]}")
    remaining_slots_265="$(( ${display_count} - ${#__length_155[@]} ))"
    if [ "$(( ${remaining_slots_265} > 0 ))" != 0 ]; then
        # Amber bug gaurd
        from=0
        to="${remaining_slots_265}"
        for ____266 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
            array_156=("")
            eprintf__871_v0 "\\x1b[K
" array_156[@]
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
    __length_157="${cursor}"
    cursor_len_219="${#__length_157}"
    check_mark_len_220=2
    # "✓ " or "• "
    max_option_width_221="$(( $(( $(( ${term_width} - ${cursor_len_219} )) - ${check_mark_len_220} )) - 1 ))"
    from=0
    __length_158=("${page_options[@]}")
    to="${#__length_158[@]}"
    for i_222 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        global_idx_223="$(( ${page_start} + ${i_222} ))"
        check_mark_224="$(if [ "${checked[${global_idx_223}]}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
        cutoff_text__891_v0 "${page_options[${i_222}]}" "${max_option_width_221}"
        truncated_option_225="${ret_cutoff_text891_v0}"
        if [ "$(( ${i_222} == ${sel} ))" != 0 ]; then
            colored_secondary__854_v0 "${cursor}""${check_mark_224}""${truncated_option_225}""
"
            ret_colored_secondary854_v0__51_31="${ret_colored_secondary854_v0}"
            array_159=("")
            eprintf__871_v0 "${ret_colored_secondary854_v0__51_31}" array_159[@]
        elif [ "${checked[${global_idx_223}]}" != 0 ]; then
            print_blank__877_v0 "${cursor_len_219}"
            colored_secondary__854_v0 "${check_mark_224}""${truncated_option_225}""
"
            ret_colored_secondary854_v0__54_25="${ret_colored_secondary854_v0}"
            array_160=("")
            eprintf__871_v0 "${ret_colored_secondary854_v0__54_25}" array_160[@]
        else
            print_blank__877_v0 "${cursor_len_219}"
            array_161=("")
            eprintf__871_v0 "${check_mark_224}""${truncated_option_225}""
" array_161[@]
        fi
    done
    __length_162=("${page_options[@]}")
    remaining_slots_226="$(( ${display_count} - ${#__length_162[@]} ))"
    if [ "$(( ${remaining_slots_226} > 0 ))" != 0 ]; then
        # Amber bug guard
        from=0
        to="${remaining_slots_226}"
        for ____227 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
            array_163=("")
            eprintf__871_v0 "\\x1b[K
" array_163[@]
        done
    fi
}

render_page_indicator__946_v0() {
    local page=$1
    local total_pages=$2
    if [ "$(( ${total_pages} > 1 ))" != 0 ]; then
        array_164=("")
        eprintf__871_v0 "\\x1b[9999D\\x1b[K" array_164[@]
        eprintf_colored__872_v0 "Page $(( ${page} + 1 ))/${total_pages}" 90
        array_165=("")
        eprintf__871_v0 "\\x1b[9999D" array_165[@]
    fi
}

xyl_choose__947_v0() {
    local options=("${!1}")
    local cursor=$2
    local header=$3
    local page_size=$4
    __length_166=("${options[@]}")
    if [ "$(( ${#__length_166[@]} == 0 ))" != 0 ]; then
        eprintf_colored__872_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    stty_lock__833_v0 
    hide_cursor__882_v0 
    term_width__837_v0 
    term_width_253="${ret_term_width837_v0}"
    term_height__838_v0 
    term_height_254="${ret_term_height838_v0}"
    max_page_size_255="$(( ${term_height_254} - $(if [ "$([ "_${header}" != "_" ]; echo $?)" != 0 ]; then echo 2; else echo 3; fi) ))"
    if [ "$(( ${page_size} > ${max_page_size_255} ))" != 0 ]; then
        page_size="${max_page_size_255}"
    fi
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__891_v0 "${header}" "${term_width_253}"
        ret_cutoff_text891_v0__107_17="${ret_cutoff_text891_v0}"
        array_167=("")
        eprintf__871_v0 "${ret_cutoff_text891_v0__107_17}""
" array_167[@]
    fi
    __length_168=("${options[@]}")
    math_floor__416_v0 "$(( $(( $(( ${#__length_168[@]} + ${page_size} )) - 1 )) / ${page_size} ))"
    total_pages_256="${ret_math_floor416_v0}"
    current_page_257=0
    selected_258=0
    display_count_259="${page_size}"
    __length_169=("${options[@]}")
    if [ "$(( ${#__length_169[@]} < ${page_size} ))" != 0 ]; then
        __length_170=("${options[@]}")
        display_count_259="${#__length_170[@]}"
    fi
    new_line__878_v0 "${display_count_259}"
    array_171=("")
    eprintf__871_v0 "\\x1b[9999D" array_171[@]
    if [ "$(( ${total_pages_256} > 1 ))" != 0 ]; then
        eprintf_colored__872_v0 "Page $(( ${current_page_257} + 1 ))/${total_pages_256}" 90
    fi
    new_line__878_v0 1
    # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
    # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    if [ "$(( ${total_pages_256} > 1 ))" != 0 ]; then
        array_172=("↑↓" "select" "←→" "page" "enter" "confirm")
        render_tooltip__892_v0 array_172[@] 36 "${term_width_253}"
    else
        array_173=("↑↓" "select" "enter" "confirm")
        render_tooltip__892_v0 array_173[@] 25 "${term_width_253}"
    fi
    go_up__879_v0 "$(( ${display_count_259} + 1 ))"
    array_174=("")
    eprintf__871_v0 "\\x1b[9999D" array_174[@]
    get_page_options__942_v0 options[@] "${current_page_257}" "${page_size}"
    page_options_260=("${ret_get_page_options942_v0[@]}")
    render_choose_page__944_v0 page_options_260[@] "${selected_258}" "${cursor}" "${display_count_259}" "${term_width_253}"
    while :
    do
        get_key__869_v0 
        key_267="${ret_get_key869_v0}"
        prev_selected_268="${selected_258}"
        prev_page_269="${current_page_257}"
        up_paged_270=0
        if [ "$(( $([ "_${key_267}" != "_UP" ]; echo $?) || $([ "_${key_267}" != "_k" ]; echo $?) ))" != 0 ]; then
            if [ "$(( $(( ${selected_258} == 0 )) && $(( ${total_pages_256} > 1 )) ))" != 0 ]; then
                if [ "$(( ${current_page_257} > 0 ))" != 0 ]; then
                    current_page_257="$(( ${current_page_257} - 1 ))"
                else
                    current_page_257="$(( ${total_pages_256} - 1 ))"
                fi
                up_paged_270=1
            elif [ "$(( ${selected_258} == 0 ))" != 0 ]; then
                __length_175=("${page_options_260[@]}")
                selected_258="$(( ${#__length_175[@]} - 1 ))"
            else
                selected_258="$(( ${selected_258} - 1 ))"
            fi
        elif [ "$(( $([ "_${key_267}" != "_DOWN" ]; echo $?) || $([ "_${key_267}" != "_j" ]; echo $?) ))" != 0 ]; then
            __length_176=("${page_options_260[@]}")
            if [ "$(( ${selected_258} == $(( ${#__length_176[@]} - 1 )) ))" != 0 ]; then
                if [ "$(( ${current_page_257} < $(( ${total_pages_256} - 1 )) ))" != 0 ]; then
                    current_page_257="$(( ${current_page_257} + 1 ))"
                    selected_258=0
                else
                    current_page_257=0
                    selected_258=0
                fi
            else
                selected_258="$(( ${selected_258} + 1 ))"
            fi
        elif [ "$(( $([ "_${key_267}" != "_LEFT" ]; echo $?) || $([ "_${key_267}" != "_h" ]; echo $?) ))" != 0 ]; then
            if [ "$(( ${current_page_257} > 0 ))" != 0 ]; then
                current_page_257="$(( ${current_page_257} - 1 ))"
                selected_258=0
            else
                selected_258=0
            fi
        elif [ "$(( $([ "_${key_267}" != "_RIGHT" ]; echo $?) || $([ "_${key_267}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "$(( ${current_page_257} < $(( ${total_pages_256} - 1 )) ))" != 0 ]; then
                current_page_257="$(( ${current_page_257} + 1 ))"
                selected_258=0
            else
                __length_177=("${page_options_260[@]}")
                selected_258="$(( ${#__length_177[@]} - 1 ))"
            fi
        elif [ "$([ "_${key_267}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
        __length_178="${cursor}"
        max_option_width_271="$(( $(( ${term_width_253} - ${#__length_178} )) - 1 ))"
        if [ "$(( ${prev_page_269} != ${current_page_257} ))" != 0 ]; then
            get_page_options__942_v0 options[@] "${current_page_257}" "${page_size}"
            page_options_260=("${ret_get_page_options942_v0[@]}")
            if [ "${up_paged_270}" != 0 ]; then
                __length_179=("${page_options_260[@]}")
                selected_258="$(( ${#__length_179[@]} - 1 ))"
            fi
            go_up__879_v0 1
            remove_line__875_v0 "$(( ${display_count_259} - 1 ))"
            remove_current_line__876_v0 
            array_180=("")
            eprintf__871_v0 "\\x1b[9999D" array_180[@]
            render_choose_page__944_v0 page_options_260[@] "${selected_258}" "${cursor}" "${display_count_259}" "${term_width_253}"
            render_page_indicator__946_v0 "${current_page_257}" "${total_pages_256}"
        elif [ "$(( ${prev_selected_268} != ${selected_258} ))" != 0 ]; then
            go_up__879_v0 "$(( ${display_count_259} - ${prev_selected_268} ))"
            array_181=("")
            eprintf__871_v0 "\\x1b[K" array_181[@]
            __length_182="${cursor}"
            print_blank__877_v0 "${#__length_182}"
            cutoff_text__891_v0 "${page_options_260[${prev_selected_268}]}" "${max_option_width_271}"
            ret_cutoff_text891_v0__218_25="${ret_cutoff_text891_v0}"
            array_183=("")
            eprintf__871_v0 "${ret_cutoff_text891_v0__218_25}" array_183[@]
            diff_272="$(( ${selected_258} - ${prev_selected_268} ))"
            go_up_or_down__881_v0 "${diff_272}"
            array_184=("")
            eprintf__871_v0 "\\x1b[9999D" array_184[@]
            array_185=("")
            eprintf__871_v0 "\\x1b[K" array_185[@]
            cutoff_text__891_v0 "${page_options_260[${selected_258}]}" "${max_option_width_271}"
            ret_cutoff_text891_v0__224_52="${ret_cutoff_text891_v0}"
            colored_secondary__854_v0 "${cursor}""${ret_cutoff_text891_v0__224_52}"
            ret_colored_secondary854_v0__224_25="${ret_colored_secondary854_v0}"
            array_186=("")
            eprintf__871_v0 "${ret_colored_secondary854_v0__224_25}" array_186[@]
            go_down__880_v0 "$(( ${display_count_259} - ${selected_258} ))"
            array_187=("")
            eprintf__871_v0 "\\x1b[9999D" array_187[@]
        fi
    done
    total_lines_273="$(( ${display_count_259} + 2 ))"
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_273="$(( ${total_lines_273} + 1 ))"
    fi
    go_down__880_v0 1
    remove_line__875_v0 "$(( ${total_lines_273} - 1 ))"
    remove_current_line__876_v0 
    stty_unlock__834_v0 
    show_cursor__883_v0 
    global_selected_274="$(( $(( ${current_page_257} * ${page_size} )) + ${selected_258} ))"
    ret_xyl_choose947_v0="${options[${global_selected_274}]}"
    return 0
}

count_checked__948_v0() {
    local checked=("${!1}")
    count_234=0
    for c_235 in "${checked[@]}"; do
        if [ "${c_235}" != 0 ]; then
            count_234="$(( ${count_234} + 1 ))"
        fi
    done
    ret_count_checked948_v0="${count_234}"
    return 0
}

xyl_multi_choose__949_v0() {
    local options=("${!1}")
    local cursor=$2
    local header=$3
    local limit=$4
    local page_size=$5
    __length_188=("${options[@]}")
    if [ "$(( ${#__length_188[@]} == 0 ))" != 0 ]; then
        eprintf_colored__872_v0 "ERROR: No options provided.
" 31
        ret_xyl_multi_choose949_v0=()
        return 0
    fi
    stty_lock__833_v0 
    hide_cursor__882_v0 
    term_width__837_v0 
    term_width_171="${ret_term_width837_v0}"
    term_height__838_v0 
    term_height_172="${ret_term_height838_v0}"
    max_page_size_173="$(( ${term_height_172} - $(if [ "$([ "_${header}" != "_" ]; echo $?)" != 0 ]; then echo 2; else echo 3; fi) ))"
    if [ "$(( ${page_size} > ${max_page_size_173} ))" != 0 ]; then
        page_size="${max_page_size_173}"
    fi
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__891_v0 "${header}" "${term_width_171}"
        ret_cutoff_text891_v0__288_17="${ret_cutoff_text891_v0}"
        array_190=("")
        eprintf__871_v0 "${ret_cutoff_text891_v0__288_17}""
" array_190[@]
    fi
    __length_191=("${options[@]}")
    math_floor__416_v0 "$(( $(( $(( ${#__length_191[@]} + ${page_size} )) - 1 )) / ${page_size} ))"
    total_pages_196="${ret_math_floor416_v0}"
    current_page_197=0
    selected_198=0
    display_count_199="${page_size}"
    __length_192=("${options[@]}")
    if [ "$(( ${#__length_192[@]} < ${page_size} ))" != 0 ]; then
        __length_193=("${options[@]}")
        display_count_199="${#__length_193[@]}"
    fi
    new_line__878_v0 "${display_count_199}"
    array_194=("")
    eprintf__871_v0 "\\x1b[9999D" array_194[@]
    if [ "$(( ${total_pages_196} > 1 ))" != 0 ]; then
        eprintf_colored__872_v0 "Page $(( ${current_page_197} + 1 ))/${total_pages_196}" 90
    fi
    new_line__878_v0 1
    # "↑↓ select • x toggle • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    # "↑↓ select • x toggle • a all • enter confirm" = 36 + 5 + 3 = 44
    # "↑↓ select • x toggle • ←→ page • enter confirm" = 36 + 8 + 3 = 47
    # "↑↓ select • x toggle • a all • ←→ page • enter confirm" = 36 + 5 + 3 + 8 + 3 = 55
    if [ "$(( $(( ${total_pages_196} > 1 )) && $(( ${limit} < 0 )) ))" != 0 ]; then
        array_195=("↑↓" "select" "x" "toggle" "a" "all" "←→" "page" "enter" "confirm")
        render_tooltip__892_v0 array_195[@] 55 "${term_width_171}"
    elif [ "$(( ${total_pages_196} > 1 ))" != 0 ]; then
        array_196=("↑↓" "select" "x" "toggle" "←→" "page" "enter" "confirm")
        render_tooltip__892_v0 array_196[@] 47 "${term_width_171}"
    elif [ "$(( ${limit} < 0 ))" != 0 ]; then
        array_197=("↑↓" "select" "x" "toggle" "a" "all" "enter" "confirm")
        render_tooltip__892_v0 array_197[@] 44 "${term_width_171}"
    else
        array_198=("↑↓" "select" "x" "toggle" "enter" "confirm")
        render_tooltip__892_v0 array_198[@] 36 "${term_width_171}"
    fi
    go_up__879_v0 "$(( ${display_count_199} + 1 ))"
    array_199=("")
    eprintf__871_v0 "\\x1b[9999D" array_199[@]
    checked_211=()
    from=0
    __length_201=("${options[@]}")
    to="${#__length_201[@]}"
    for ____212 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        checked_211+=(0)
    done
    get_page_options__942_v0 options[@] "${current_page_197}" "${page_size}"
    page_options_217=("${ret_get_page_options942_v0[@]}")
    get_page_start__943_v0 "${current_page_197}" "${page_size}"
    page_start_218="${ret_get_page_start943_v0}"
    render_multi_choose_page__945_v0 page_options_217[@] checked_211[@] "${page_start_218}" "${selected_198}" "${cursor}" "${display_count_199}" "${term_width_171}"
    while :
    do
        get_key__869_v0 
        key_229="${ret_get_key869_v0}"
        prev_selected_230="${selected_198}"
        prev_page_231="${current_page_197}"
        global_selected_232="$(( ${page_start_218} + ${selected_198} ))"
        up_paged_233=0
        if [ "$(( $([ "_${key_229}" != "_UP" ]; echo $?) || $([ "_${key_229}" != "_k" ]; echo $?) ))" != 0 ]; then
            if [ "$(( $(( ${selected_198} == 0 )) && $(( ${total_pages_196} > 1 )) ))" != 0 ]; then
                if [ "$(( ${current_page_197} > 0 ))" != 0 ]; then
                    current_page_197="$(( ${current_page_197} - 1 ))"
                else
                    current_page_197="$(( ${total_pages_196} - 1 ))"
                fi
                up_paged_233=1
            elif [ "$(( ${selected_198} == 0 ))" != 0 ]; then
                __length_203=("${page_options_217[@]}")
                selected_198="$(( ${#__length_203[@]} - 1 ))"
            else
                selected_198="$(( ${selected_198} - 1 ))"
            fi
        elif [ "$(( $([ "_${key_229}" != "_DOWN" ]; echo $?) || $([ "_${key_229}" != "_j" ]; echo $?) ))" != 0 ]; then
            __length_204=("${page_options_217[@]}")
            if [ "$(( ${selected_198} == $(( ${#__length_204[@]} - 1 )) ))" != 0 ]; then
                if [ "$(( ${current_page_197} < $(( ${total_pages_196} - 1 )) ))" != 0 ]; then
                    current_page_197="$(( ${current_page_197} + 1 ))"
                    selected_198=0
                else
                    current_page_197=0
                    selected_198=0
                fi
            else
                selected_198="$(( ${selected_198} + 1 ))"
            fi
        elif [ "$(( $([ "_${key_229}" != "_LEFT" ]; echo $?) || $([ "_${key_229}" != "_h" ]; echo $?) ))" != 0 ]; then
            if [ "$(( ${current_page_197} > 0 ))" != 0 ]; then
                current_page_197="$(( ${current_page_197} - 1 ))"
                selected_198=0
            else
                selected_198=0
            fi
        elif [ "$(( $([ "_${key_229}" != "_RIGHT" ]; echo $?) || $([ "_${key_229}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "$(( ${current_page_197} < $(( ${total_pages_196} - 1 )) ))" != 0 ]; then
                current_page_197="$(( ${current_page_197} + 1 ))"
                selected_198=0
            else
                __length_205=("${page_options_217[@]}")
                selected_198="$(( ${#__length_205[@]} - 1 ))"
            fi
        elif [ "$(( $([ "_${key_229}" != "_x" ]; echo $?) || $([ "_${key_229}" != "_X" ]; echo $?) ))" != 0 ]; then
            count_checked__948_v0 checked_211[@]
            ret_count_checked948_v0__390_34="${ret_count_checked948_v0}"
            if [ "${checked_211[${global_selected_232}]}" != 0 ]; then
                checked_211["${global_selected_232}"]=0
            elif [ "$(( $(( ${limit} < 0 )) || $(( ${ret_count_checked948_v0__390_34} < ${limit} )) ))" != 0 ]; then
                checked_211["${global_selected_232}"]=1
            else
                continue
            fi
            __length_206="${cursor}"
            max_option_width_236="$(( $(( $(( ${term_width_171} - ${#__length_206} )) - 2 )) - 1 ))"
            # 2 for check mark
            go_up__879_v0 "$(( ${display_count_199} - ${selected_198} ))"
            array_207=("")
            eprintf__871_v0 "\\x1b[9999D" array_207[@]
            array_208=("")
            eprintf__871_v0 "\\x1b[K" array_208[@]
            check_mark_237="$(if [ "${checked_211[${global_selected_232}]}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
            cutoff_text__891_v0 "${page_options_217[${selected_198}]}" "${max_option_width_236}"
            ret_cutoff_text891_v0__400_65="${ret_cutoff_text891_v0}"
            colored_secondary__854_v0 "${cursor}""${check_mark_237}""${ret_cutoff_text891_v0__400_65}"
            ret_colored_secondary854_v0__400_25="${ret_colored_secondary854_v0}"
            array_209=("")
            eprintf__871_v0 "${ret_colored_secondary854_v0__400_25}" array_209[@]
            go_down__880_v0 "$(( ${display_count_199} - ${selected_198} ))"
            array_210=("")
            eprintf__871_v0 "\\x1b[9999D" array_210[@]
            continue
        elif [ "$(( $(( $([ "_${key_229}" != "_a" ]; echo $?) || $([ "_${key_229}" != "_A" ]; echo $?) )) && $(( ${limit} < 0 )) ))" != 0 ]; then
            count_checked__948_v0 checked_211[@]
            ret_count_checked948_v0__406_35="${ret_count_checked948_v0}"
            __length_211=("${options[@]}")
            all_checked_238="$(( ${ret_count_checked948_v0__406_35} == ${#__length_211[@]} ))"
            from=0
            __length_212=("${checked_211[@]}")
            to="${#__length_212[@]}"
            for i_239 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
                checked_211["${i_239}"]="$(( ! ${all_checked_238} ))"
            done
            go_up__879_v0 "${display_count_199}"
            array_213=("")
            eprintf__871_v0 "\\x1b[9999D" array_213[@]
            render_multi_choose_page__945_v0 page_options_217[@] checked_211[@] "${page_start_218}" "${selected_198}" "${cursor}" "${display_count_199}" "${term_width_171}"
            continue
        elif [ "$([ "_${key_229}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
        __length_214="${cursor}"
        max_option_width_240="$(( $(( $(( ${term_width_171} - ${#__length_214} )) - 2 )) - 1 ))"
        # 2 for check mark
        if [ "$(( ${prev_page_231} != ${current_page_197} ))" != 0 ]; then
            get_page_options__942_v0 options[@] "${current_page_197}" "${page_size}"
            page_options_217=("${ret_get_page_options942_v0[@]}")
            get_page_start__943_v0 "${current_page_197}" "${page_size}"
            page_start_218="${ret_get_page_start943_v0}"
            if [ "${up_paged_233}" != 0 ]; then
                __length_215=("${page_options_217[@]}")
                selected_198="$(( ${#__length_215[@]} - 1 ))"
            fi
            go_up__879_v0 1
            remove_line__875_v0 "$(( ${display_count_199} - 1 ))"
            remove_current_line__876_v0 
            array_216=("")
            eprintf__871_v0 "\\x1b[9999D" array_216[@]
            render_multi_choose_page__945_v0 page_options_217[@] checked_211[@] "${page_start_218}" "${selected_198}" "${cursor}" "${display_count_199}" "${term_width_171}"
            render_page_indicator__946_v0 "${current_page_197}" "${total_pages_196}"
        elif [ "$(( ${prev_selected_230} != ${selected_198} ))" != 0 ]; then
            prev_global_243="$(( ${page_start_218} + ${prev_selected_230} ))"
            go_up__879_v0 "$(( ${display_count_199} - ${prev_selected_230} ))"
            array_217=("")
            eprintf__871_v0 "\\x1b[K" array_217[@]
            __length_218="${cursor}"
            print_blank__877_v0 "${#__length_218}"
            if [ "${checked_211[${prev_global_243}]}" != 0 ]; then
                cutoff_text__891_v0 "${page_options_217[${prev_selected_230}]}" "${max_option_width_240}"
                ret_cutoff_text891_v0__442_54="${ret_cutoff_text891_v0}"
                colored_secondary__854_v0 "✓ ""${ret_cutoff_text891_v0__442_54}"
                ret_colored_secondary854_v0__442_29="${ret_colored_secondary854_v0}"
                array_219=("")
                eprintf__871_v0 "${ret_colored_secondary854_v0__442_29}" array_219[@]
            else
                cutoff_text__891_v0 "${page_options_217[${prev_selected_230}]}" "${max_option_width_240}"
                ret_cutoff_text891_v0__444_36="${ret_cutoff_text891_v0}"
                array_220=("")
                eprintf__871_v0 "• ""${ret_cutoff_text891_v0__444_36}" array_220[@]
            fi
            diff_244="$(( ${selected_198} - ${prev_selected_230} ))"
            go_up_or_down__881_v0 "${diff_244}"
            array_221=("")
            eprintf__871_v0 "\\x1b[9999D" array_221[@]
            array_222=("")
            eprintf__871_v0 "\\x1b[K" array_222[@]
            new_global_245="$(( ${page_start_218} + ${selected_198} ))"
            check_mark_246="$(if [ "${checked_211[${new_global_245}]}" != 0 ]; then echo "✓ "; else echo "• "; fi)"
            cutoff_text__891_v0 "${page_options_217[${selected_198}]}" "${max_option_width_240}"
            ret_cutoff_text891_v0__453_65="${ret_cutoff_text891_v0}"
            colored_secondary__854_v0 "${cursor}""${check_mark_246}""${ret_cutoff_text891_v0__453_65}"
            ret_colored_secondary854_v0__453_25="${ret_colored_secondary854_v0}"
            array_223=("")
            eprintf__871_v0 "${ret_colored_secondary854_v0__453_25}" array_223[@]
            go_down__880_v0 "$(( ${display_count_199} - ${selected_198} ))"
            array_224=("")
            eprintf__871_v0 "\\x1b[9999D" array_224[@]
        fi
    done
    total_lines_247="$(( ${display_count_199} + 2 ))"
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_247="$(( ${total_lines_247} + 1 ))"
    fi
    go_down__880_v0 1
    remove_line__875_v0 "$(( ${total_lines_247} - 1 ))"
    remove_current_line__876_v0 
    result_248=()
    from=0
    __length_226=("${options[@]}")
    to="${#__length_226[@]}"
    for i_249 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        if [ "${checked_211[${i_249}]}" != 0 ]; then
            result_248+=("${options[${i_249}]}")
        fi
    done
    stty_unlock__834_v0 
    show_cursor__883_v0 
    ret_xyl_multi_choose949_v0=("${result_248[@]}")
    return 0
}

print_choose_help__1026_v0() {
    echo "Usage: ./xylitol.sh choose [<options> ...] [flags]"
    echo ""
    colored_primary__853_v0 "choose"
    ret_colored_primary853_v0__7_12="${ret_colored_primary853_v0}"
    array_228=("")
    printf__106_v0 "${ret_colored_primary853_v0__7_12}" array_228[@]
    array_229=("")
    printf__106_v0 " - Choose from a list of options." array_229[@]
    echo ""
    echo ""
    colored_secondary__854_v0 "Arguments: "
    ret_colored_secondary854_v0__11_12="${ret_colored_secondary854_v0}"
    array_230=("")
    printf__106_v0 "${ret_colored_secondary854_v0__11_12}""
" array_230[@]
    echo "  [<options> ...]        List of options to choose from"
    echo ""
    colored_secondary__854_v0 "Flags: "
    ret_colored_secondary854_v0__14_12="${ret_colored_secondary854_v0}"
    array_231=("")
    printf__106_v0 "${ret_colored_secondary854_v0__14_12}""
" array_231[@]
    echo "  -h, --help             Show this help message"
    echo "  --limit=<number>       Enable multi-selection mode with a limit of selections"
    echo "  --no-limit             Enable multi-selection mode with no limit"
    echo "  --cursor=\"<text>\"      Set the cursor text (default: '> ')"
    echo "  --header=\"<text>\"      Set a header text to display above the options (ANSI escape supported)"
    echo "  --page-size=<number>   Set the number of options per page (default: 10)"
    echo ""
}

read_stdin_options__1077_v0() {
    options_152=()
    command_233="$([ -t 0 ] && echo "true" || echo "false")"
    __status=$?
    is_tty_153="${command_233}"
    if [ "$([ "_${is_tty_153}" != "_false" ]; echo $?)" != 0 ]; then
        while IFS= read -r line || [[ -n "$line" ]]; do options_152+=("$line"); done
        __status=$?
    fi
    ret_read_stdin_options1077_v0=("${options_152[@]}")
    return 0
}

execute_choose__1078_v0() {
    local parameters=("${!1}")
    cursor_142="> "
    colored_primary__853_v0 "Choose: "
    ret_colored_primary853_v0__17_30="${ret_colored_primary853_v0}"
    header_151="\\x1b[1m""${ret_colored_primary853_v0__17_30}"
    read_stdin_options__1077_v0 
    options_154=("${ret_read_stdin_options1077_v0[@]}")
    multi_155=0
    limit_156=-1
    page_size_157=10
    for param_158 in "${parameters[@]:2:9997}"; do
        match_regex__20_v0 "${param_158}" "^-h\$" 0
        ret_match_regex20_v0__25_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_158}" "^--help\$" 0
        ret_match_regex20_v0__25_43="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_158}" "^--cursor=.*\$" 0
        ret_match_regex20_v0__29_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_158}" "^--header=.*\$" 0
        ret_match_regex20_v0__33_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_158}" "^--limit=.*\$" 0
        ret_match_regex20_v0__37_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_158}" "^--no-limit\$" 0
        ret_match_regex20_v0__45_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_158}" "^--page-size=.*\$" 0
        ret_match_regex20_v0__48_13="${ret_match_regex20_v0}"
        if [ "$(( ${ret_match_regex20_v0__25_13} || ${ret_match_regex20_v0__25_43} ))" != 0 ]; then
            print_choose_help__1026_v0 
            exit 0
        elif [ "${ret_match_regex20_v0__29_13}" != 0 ]; then
            split__5_v0 "${param_158}" "="
            result_159=("${ret_split5_v0[@]}")
            cursor_142="${result_159[1]}"
        elif [ "${ret_match_regex20_v0__33_13}" != 0 ]; then
            split__5_v0 "${param_158}" "="
            result_160=("${ret_split5_v0[@]}")
            header_151="${result_160[1]}"
        elif [ "${ret_match_regex20_v0__37_13}" != 0 ]; then
            split__5_v0 "${param_158}" "="
            result_161=("${ret_split5_v0[@]}")
            parse_int__14_v0 "${result_161[1]}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__872_v0 "ERROR: Invalid limit value: ""${result_161[1]}""
" 31
                exit 1
            fi
            limit_156="${ret_parse_int14_v0}"
            multi_155=1
        elif [ "${ret_match_regex20_v0__45_13}" != 0 ]; then
            multi_155=1
        elif [ "${ret_match_regex20_v0__48_13}" != 0 ]; then
            split__5_v0 "${param_158}" "="
            result_162=("${ret_split5_v0[@]}")
            parse_int__14_v0 "${result_162[1]}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__872_v0 "ERROR: Invalid page-size value: ""${result_162[1]}""
" 31
                exit 1
            fi
            page_size_157="${ret_parse_int14_v0}"
        else
            options_154+=("${param_158}")
        fi
    done
    has_ansi_escape__884_v0 "${header_151}"
    ret_has_ansi_escape884_v0__61_42="${ret_has_ansi_escape884_v0}"
    escape_ansi__885_v0 "${header_151}"
    ret_escape_ansi885_v0__61_71="${ret_escape_ansi885_v0}"
    colored_primary__853_v0 "${header_151}"
    ret_colored_primary853_v0__61_109="${ret_colored_primary853_v0}"
    display_header_164="$(if [ "$(( $([ "_${header_151}" != "_" ]; echo $?) || ${ret_has_ansi_escape884_v0__61_42} ))" != 0 ]; then echo "${ret_escape_ansi885_v0__61_71}"; else echo "\\x1b[1m""${ret_colored_primary853_v0__61_109}"; fi)"
    if [ "${multi_155}" != 0 ]; then
        xyl_multi_choose__949_v0 options_154[@] "${cursor_142}" "${display_header_164}" "${limit_156}" "${page_size_157}"
        results_252=("${ret_xyl_multi_choose949_v0[@]}")
        join__8_v0 results_252[@] "
"
        ret_execute_choose1078_v0="${ret_join8_v0}"
        return 0
    fi
    xyl_choose__947_v0 options_154[@] "${cursor_142}" "${display_header_164}" "${page_size_157}"
    ret_execute_choose1078_v0="${ret_xyl_choose947_v0}"
    return 0
}

# Perl Extensions Utilities
command_235="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_30="$([ "_${command_235}" != "_No" ]; echo $?)"
command_236="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_31="$(( $(( ! ${_perl_disabled_30} )) && $([ "_${command_236}" != "_0" ]; echo $?) ))"
perl_get_cjk_width__1207_v0() {
    local text=$1
    if [ "$(( ! ${_perl_available_31} ))" != 0 ]; then
        ret_perl_get_cjk_width1207_v0=''
        return 1
    fi
    command_237="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1207_v0=''
        return "${__status}"
    fi
    width_str_299="${command_237}"
    parse_int__14_v0 "${width_str_299}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1207_v0=''
        return "${__status}"
    fi
    width_300="${ret_parse_int14_v0}"
    ret_perl_get_cjk_width1207_v0="${width_300}"
    return 0
}

perl_truncate_cjk__1208_v0() {
    local text=$1
    local max_width=$2
    if [ "$(( ! ${_perl_available_31} ))" != 0 ]; then
        ret_perl_truncate_cjk1208_v0=''
        return 1
    fi
    command_238="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text}" ${max_width} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1208_v0=''
        return "${__status}"
    fi
    result_303="${command_238}"
    ret_perl_truncate_cjk1208_v0="${result_303}"
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
    command_240="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_290="${command_240}"
    parse_int__14_v0 "${count_290}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_291="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_291} == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_291="$(( ${count_num_291} + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_291}
    __status=$?
}

stty_unlock__1216_v0() {
    command_241="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_340="${command_241}"
    parse_int__14_v0 "${count_340}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_341="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_341} > 0 ))" != 0 ]; then
        count_num_341="$(( ${count_num_341} - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_341}
        __status=$?
        if [ "$(( ${count_num_341} == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

get_term_size__1217_v0() {
    # Query terminal size with \x1b[18t, response format: \x1b[8;rows;colst
    command_242="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -rsd t _ignore height width < /dev/tty; echo "$height; $width")"
    __status=$?
    result_292="${command_242}"
    split__5_v0 "${result_292}" ";"
    parts_293=("${ret_split5_v0[@]}")
    __length_243=("${parts_293[@]}")
    if [ "$(( ${#__length_243[@]} != 2 ))" != 0 ]; then
        ret_get_term_size1217_v0=''
        return 1
    fi
    parse_int__14_v0 "${parts_293[0]}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_term_size1217_v0=''
        return "${__status}"
    fi
    rows_294="${ret_parse_int14_v0}"
    parse_int__14_v0 "${parts_293[1]}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_term_size1217_v0=''
        return "${__status}"
    fi
    cols_295="${ret_parse_int14_v0}"
    _term_size_33=("${cols_295}" "${rows_294}")
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
    config_281="${ret_env_var_get98_v0}"
    if [ "$([ "_${config_281}" != "_No" ]; echo $?)" != 0 ]; then
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
    colorterm_282="${ret_env_var_get98_v0}"
    _supports_truecolor_34="$(if [ "$(( $([ "_${colorterm_282}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_282}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
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
    bg_fallback_324="${fallback}"
    if [ "$(( $(( ${fallback} >= 30 )) && $(( ${fallback} <= 37 )) ))" != 0 ]; then
        bg_fallback_324="$(( ${fallback} + 10 ))"
    fi
    if [ "$(( $(( ${fallback} >= 90 )) && $(( ${fallback} <= 97 )) ))" != 0 ]; then
        bg_fallback_324="$(( ${fallback} + 10 ))"
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
        elif [ "$(( ${bg_fallback_324} == 0 ))" != 0 ]; then
            ret_background_rgb1232_v0="${message}"
            return 0
        else
            ret_background_rgb1232_v0="\\x1b[${bg_fallback_324}m""${message}""\\x1b[0m"
            return 0
        fi
    else
        if [ "$(( ${bg_fallback_324} == 0 ))" != 0 ]; then
            ret_background_rgb1232_v0="${message}"
            return 0
        fi
        ret_background_rgb1232_v0="\\x1b[${bg_fallback_324}m""${message}""\\x1b[0m"
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
        primary_env_275="${ret_env_var_get98_v0}"
        if [ "$([ "_${primary_env_275}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${primary_env_275}" ";"
            parts_276=("${ret_split5_v0[@]}")
            __length_248=("${parts_276[@]}")
            if [ "$(( ${#__length_248[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_276[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__115_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_276[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__116_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_276[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__117_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_276[3]}"
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
        secondary_env_277="${ret_env_var_get98_v0}"
        if [ "$([ "_${secondary_env_277}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${secondary_env_277}" ";"
            parts_278=("${ret_split5_v0[@]}")
            __length_250=("${parts_278[@]}")
            if [ "$(( ${#__length_250[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_278[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__128_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_278[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__129_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_278[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__130_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_278[3]}"
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
        accent_env_279="${ret_env_var_get98_v0}"
        if [ "$([ "_${accent_env_279}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${accent_env_279}" ";"
            parts_280=("${ret_split5_v0[@]}")
            __length_252=("${parts_280[@]}")
            if [ "$(( ${#__length_252[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_280[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__141_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_280[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__142_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_280[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1233_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__143_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_280[3]}"
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
    command_254="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    var_335="${command_254}"
    if [ "$([ "_${var_335}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1251_v0="UP"
        return 0
    elif [ "$([ "_${var_335}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1251_v0="DOWN"
        return 0
    elif [ "$([ "_${var_335}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1251_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_335}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1251_v0="LEFT"
        return 0
    elif [ "$([ "_${var_335}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1251_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_335}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1251_v0="INPUT"
        return 0
    else
        ret_get_key1251_v0="${var_335}"
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
    array_255=("${message}")
    eprintf__1253_v0 "\\x1b[${color}m%s\\x1b[0m" array_255[@]
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
    if [ "$(( ${cnt} > 0 ))" != 0 ]; then
        sequence_338=""
        from=0
        to="${cnt}"
        for ____339 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
            sequence_338+="\\x1b[2K\\x1b[1A"
        done
        array_256=("")
        eprintf__1253_v0 "${sequence_338}" array_256[@]
    fi
    array_257=("")
    eprintf__1253_v0 "\\x1b[9999D" array_257[@]
}

remove_current_line__1258_v0() {
    array_258=("")
    eprintf__1253_v0 "\\x1b[2K\\x1b[9999D" array_258[@]
}

go_up__1261_v0() {
    local cnt=$1
    array_259=("")
    eprintf__1253_v0 "\\x1b[${cnt}A" array_259[@]
}

go_down__1262_v0() {
    local cnt=$1
    array_260=("")
    eprintf__1253_v0 "\\x1b[${cnt}B" array_260[@]
}

# move the cursor up or down `cnt` lines.
hide_cursor__1264_v0() {
    array_261=("")
    eprintf__1253_v0 "\\x1b[?25l" array_261[@]
}

show_cursor__1265_v0() {
    array_262=("")
    eprintf__1253_v0 "\\x1b[?25h" array_262[@]
}

# / Text Utilities /////
has_ansi_escape__1266_v0() {
    local text=$1
    # Check for ESC character (0x1B = 27) or literal \x1b[
    command_263="$([[ "${text}" == *$'\x1b'* || "${text}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    has_escape_288="${command_263}"
    ret_has_ansi_escape1266_v0="$([ "_${has_escape_288}" != "_1" ]; echo $?)"
    return 0
}

escape_ansi__1267_v0() {
    local text=$1
    command_264="$(printf '%s' "${text}" | sed $'s/\x1b/\\x1b/g')"
    __status=$?
    ret_escape_ansi1267_v0="${command_264}"
    return 0
}

strip_ansi__1268_v0() {
    local text=$1
    command_265="$(printf "%s" "${text}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1268_v0="${command_265}"
    return 0
}

is_all_ascii__1269_v0() {
    local text=$1
    command_266="$(printf "%s" "${text}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    result_298="${command_266}"
    ret_is_all_ascii1269_v0="$([ "_${result_298}" != "_0" ]; echo $?)"
    return 0
}

get_visible_len__1270_v0() {
    local text=$1
    strip_ansi__1268_v0 "${text}"
    stripped_297="${ret_strip_ansi1268_v0}"
    # Check if text is all ASCII
    is_all_ascii__1269_v0 "${stripped_297}"
    ret_is_all_ascii1269_v0__150_12="${ret_is_all_ascii1269_v0}"
    if [ "$(( ! ${ret_is_all_ascii1269_v0__150_12} ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1207_v0 "${stripped_297}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            __length_267="${stripped_297}"
            ret_get_visible_len1270_v0="${#__length_267}"
            return 0
        fi
        ret_get_visible_len1270_v0="${ret_perl_get_cjk_width1207_v0}"
        return 0
    else
        __length_268="${stripped_297}"
        ret_get_visible_len1270_v0="${#__length_268}"
        return 0
    fi
}

truncate_text__1271_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__1270_v0 "${text}"
    visible_len_302="${ret_get_visible_len1270_v0}"
    if [ "$(( ${visible_len_302} <= ${max_width} ))" != 0 ]; then
        ret_truncate_text1271_v0="${text}"
        return 0
    fi
    is_all_ascii__1269_v0 "${text}"
    ret_is_all_ascii1269_v0__167_12="${ret_is_all_ascii1269_v0}"
    if [ "$(( ! ${ret_is_all_ascii1269_v0__167_12} ))" != 0 ]; then
        perl_truncate_cjk__1208_v0 "${text}" "${max_width}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text}" | cut -c1-${max_width}
            __status=$?
        fi
        ret_truncate_text1271_v0="${ret_perl_truncate_cjk1208_v0}"
        return 0
    fi
    command_269="$(printf "%s" "${text}" | cut -c1-${max_width})"
    __status=$?
    ret_truncate_text1271_v0="${command_269}"
    return 0
}

truncate_ansi__1272_v0() {
    local text=$1
    local max_width=$2
    has_ansi_escape__1266_v0 "${text}"
    ret_has_ansi_escape1266_v0__179_12="${ret_has_ansi_escape1266_v0}"
    if [ "$(( ! ${ret_has_ansi_escape1266_v0__179_12} ))" != 0 ]; then
        truncate_text__1271_v0 "${text}" "${max_width}"
        ret_truncate_ansi1272_v0="${ret_truncate_text1271_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    command_270="$([[ "${text}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    starts_with_ansi_304="${command_270}"
    # Replace \x1b[ with newline, then split
    command_271="$(t="${text}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    replaced_305="${command_271}"
    split__5_v0 "${replaced_305}" "
"
    parts_306=("${ret_split5_v0[@]}")
    result_307=""
    remaining_width_308="${max_width}"
    from=0
    __length_272=("${parts_306[@]}")
    to="${#__length_272[@]}"
    for idx_309 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        part_310="${parts_306[${idx_309}]}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( ${idx_309} == 0 )) && $([ "_${starts_with_ansi_304}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_310}" == "_" ]; echo $?) && $(( ${remaining_width_308} > 0 )) ))" != 0 ]; then
                truncate_text__1271_v0 "${part_310}" "${remaining_width_308}"
                truncated_311="${ret_truncate_text1271_v0}"
                result_307+="${truncated_311}"
                get_visible_len__1270_v0 "${truncated_311}"
                ret_get_visible_len1270_v0__203_36="${ret_get_visible_len1270_v0}"
                remaining_width_308="$(( ${remaining_width_308} - ${ret_get_visible_len1270_v0__203_36} ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            command_273="$(__p="${part_310}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            m_idx_312="${command_273}"
            if [ "$([ "_${m_idx_312}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                command_274="$(__p="${part_310}"; printf "%s" "${__p:0:${m_idx_312}}")"
                __status=$?
                ansi_params_313="${command_274}"
                result_307+="\\x1b[""${ansi_params_313}""m"
                # Rest is text content
                parse_int__14_v0 "${m_idx_312}"
                __status=$?
                m_idx_num_314="${ret_parse_int14_v0}"
                text_start_315="$(( ${m_idx_num_314} + 1 ))"
                command_275="$(__p="${part_310}"; printf "%s" "${__p:${text_start_315}}")"
                __status=$?
                text_part_316="${command_275}"
                if [ "$(( $([ "_${text_part_316}" == "_" ]; echo $?) && $(( ${remaining_width_308} > 0 )) ))" != 0 ]; then
                    truncate_text__1271_v0 "${text_part_316}" "${remaining_width_308}"
                    truncated_317="${ret_truncate_text1271_v0}"
                    result_307+="${truncated_317}"
                    get_visible_len__1270_v0 "${truncated_317}"
                    ret_get_visible_len1270_v0__220_40="${ret_get_visible_len1270_v0}"
                    remaining_width_308="$(( ${remaining_width_308} - ${ret_get_visible_len1270_v0__220_40} ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_310}" == "_" ]; echo $?) && $(( ${remaining_width_308} > 0 )) ))" != 0 ]; then
                    truncate_text__1271_v0 "${part_310}" "${remaining_width_308}"
                    truncated_318="${ret_truncate_text1271_v0}"
                    result_307+="${truncated_318}"
                    get_visible_len__1270_v0 "${truncated_318}"
                    remaining_width_308="$(( ${remaining_width_308} - ${ret_get_visible_len1270_v0__227_40} ))"
                fi
            fi
        fi
    done
    ret_truncate_ansi1272_v0="${result_307}"
    return 0
}

cutoff_text__1273_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__1270_v0 "${text}"
    visible_len_301="${ret_get_visible_len1270_v0}"
    if [ "$(( ${visible_len_301} <= ${max_width} ))" != 0 ]; then
        ret_cutoff_text1273_v0="${text}"
        return 0
    fi
    truncate_ansi__1272_v0 "${text}" "$(( ${max_width} - 3 ))"
    ret_truncate_ansi1272_v0__243_12="${ret_truncate_ansi1272_v0}"
    ret_cutoff_text1273_v0="${ret_truncate_ansi1272_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
render_tooltip__1274_v0() {
    local items=("${!1}")
    local total_len=$2
    local term_width=$3
    separator_325=" • "
    separator_len_326=3
    # Fast path: no truncation needed
    if [ "$(( ${total_len} <= ${term_width} ))" != 0 ]; then
        iter_327=0
        while :
        do
            __length_276=("${items[@]}")
            if [ "$(( ${iter_327} >= ${#__length_276[@]} ))" != 0 ]; then
                break
            elif [ "$(( ${iter_327} > 0 ))" != 0 ]; then
                eprintf_colored__1254_v0 "${separator_325}" 90
            fi
            colored__1255_v0 "${items[$(( ${iter_327} + 1 ))]}" 2
            ret_colored1255_v0__268_41="${ret_colored1255_v0}"
            array_277=("")
            eprintf__1253_v0 "${items[${iter_327}]}"" ""${ret_colored1255_v0__268_41}" array_277[@]
            iter_327="$(( ${iter_327} + 2 ))"
        done
    else
        # Slow path: truncate
        current_len_328=0
        first_329=1
        iter_330=0
        while :
        do
            __length_278=("${items[@]}")
            if [ "$(( ${iter_330} >= ${#__length_278[@]} ))" != 0 ]; then
                break
            fi
            key_331="${items[${iter_330}]}"
            action_332="${items[$(( ${iter_330} + 1 ))]}"
            __length_279="${key_331}"
            __length_280="${action_332}"
            part_len_333="$(( $(( ${#__length_279} + 1 )) + ${#__length_280} ))"
            needed_334="${part_len_333}"
            if [ "$(( ! ${first_329} ))" != 0 ]; then
                needed_334="$(( ${needed_334} + ${separator_len_326} ))"
            fi
            if [ "$(( $(( ${current_len_328} + ${needed_334} )) > ${term_width} ))" != 0 ]; then
                break
            fi
            if [ "$(( ! ${first_329} ))" != 0 ]; then
                eprintf_colored__1254_v0 "${separator_325}" 90
            fi
            colored__1255_v0 "${action_332}" 2
            ret_colored1255_v0__296_33="${ret_colored1255_v0}"
            array_281=("")
            eprintf__1253_v0 "${key_331}"" ""${ret_colored1255_v0__296_33}" array_281[@]
            current_len_328="$(( ${current_len_328} + ${needed_334} ))"
            first_329=0
            iter_330="$(( ${iter_330} + 2 ))"
        done
    fi
}

render_confirm_options__1324_v0() {
    local selected=$1
    local term_width=$2
    small_320="$(( ${term_width} < 30 ))"
    yes_label_321="$(if [ "${small_320}" != 0 ]; then echo " Yes "; else echo "    Yes    "; fi)"
    no_label_322="$(if [ "${small_320}" != 0 ]; then echo " No "; else echo "    No    "; fi)"
    gap_323="$(if [ "${small_320}" != 0 ]; then echo " "; else echo "  "; fi)"
    array_282=("")
    eprintf__1253_v0 " " array_282[@]
    if [ "${selected}" != 0 ]; then
        # Yes selected
        background_secondary__1239_v0 "${yes_label_321}"
        ret_background_secondary1239_v0__15_30="${ret_background_secondary1239_v0}"
        array_283=("")
        eprintf__1253_v0 "\\x1b[97m""${ret_background_secondary1239_v0__15_30}" array_283[@]
        array_284=("")
        eprintf__1253_v0 "${gap_323}" array_284[@]
        # No not selected (dim)
        array_285=("")
        eprintf__1253_v0 "\\x1b[49;37m""${no_label_322}""\\x1b[0m" array_285[@]
    else
        # No selected
        array_286=("")
        eprintf__1253_v0 "\\x1b[49;37m""${yes_label_321}""\\x1b[0m" array_286[@]
        array_287=("")
        eprintf__1253_v0 "${gap_323}" array_287[@]
        background_secondary__1239_v0 "${no_label_322}"
        ret_background_secondary1239_v0__23_30="${ret_background_secondary1239_v0}"
        array_288=("")
        eprintf__1253_v0 "\\x1b[97m""${ret_background_secondary1239_v0__23_30}" array_288[@]
    fi
}

xyl_confirm__1325_v0() {
    local header=$1
    local default_yes=$2
    stty_lock__1215_v0 
    hide_cursor__1264_v0 
    term_width__1219_v0 
    term_width_296="${ret_term_width1219_v0}"
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__1273_v0 "${header}" "${term_width_296}"
        ret_cutoff_text1273_v0__45_17="${ret_cutoff_text1273_v0}"
        array_289=("")
        eprintf__1253_v0 "${ret_cutoff_text1273_v0__45_17}""

" array_289[@]
    fi
    selected_319="${default_yes}"
    # Render initial options
    render_confirm_options__1324_v0 "${selected_319}" "${term_width_296}"
    array_290=("")
    eprintf__1253_v0 "

" array_290[@]
    # "←→ select • enter confirm • y yes • n no" = 9 + 3 + 13 + 3 + 5 + 3 + 4 = 40
    array_291=("←→" "select" "enter" "confirm" "y" "yes" "n" "no")
    render_tooltip__1274_v0 array_291[@] 40 "${term_width_296}"
    go_up__1261_v0 2
    while :
    do
        get_key__1251_v0 
        key_336="${ret_get_key1251_v0}"
        if [ "$(( $(( $(( $([ "_${key_336}" != "_LEFT" ]; echo $?) || $([ "_${key_336}" != "_h" ]; echo $?) )) || $([ "_${key_336}" != "_RIGHT" ]; echo $?) )) || $([ "_${key_336}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "${selected_319}" != 0 ]; then
                selected_319=0
                array_292=("")
                eprintf__1253_v0 "\\x1b[9999D\\x1b[K" array_292[@]
                render_confirm_options__1324_v0 "${selected_319}" "${term_width_296}"
            elif [ "$(( ! ${selected_319} ))" != 0 ]; then
                selected_319=1
                array_293=("")
                eprintf__1253_v0 "\\x1b[9999D\\x1b[K" array_293[@]
                render_confirm_options__1324_v0 "${selected_319}" "${term_width_296}"
            fi
        elif [ "$(( $([ "_${key_336}" != "_y" ]; echo $?) || $([ "_${key_336}" != "_Y" ]; echo $?) ))" != 0 ]; then
            selected_319=1
            break
        elif [ "$(( $([ "_${key_336}" != "_n" ]; echo $?) || $([ "_${key_336}" != "_N" ]; echo $?) ))" != 0 ]; then
            selected_319=0
            break
        elif [ "$([ "_${key_336}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
    done
    # Clean up: remove options line and hint line
    total_lines_337=4
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_337="$(( ${total_lines_337} + 1 ))"
    fi
    go_down__1262_v0 2
    remove_line__1257_v0 "$(( ${total_lines_337} - 1 ))"
    remove_current_line__1258_v0 
    stty_unlock__1216_v0 
    show_cursor__1265_v0 
    ret_xyl_confirm1325_v0="${selected_319}"
    return 0
}

print_confirm_help__1401_v0() {
    echo "Usage: ./xylitol.sh confirm [flags]"
    echo ""
    colored_primary__1235_v0 "confirm"
    ret_colored_primary1235_v0__7_12="${ret_colored_primary1235_v0}"
    array_294=("")
    printf__106_v0 "${ret_colored_primary1235_v0__7_12}" array_294[@]
    array_295=("")
    printf__106_v0 " - Display a Yes/No confirmation dialog." array_295[@]
    echo ""
    echo ""
    colored_secondary__1236_v0 "Flags: "
    ret_colored_secondary1236_v0__11_12="${ret_colored_secondary1236_v0}"
    array_296=("")
    printf__106_v0 "${ret_colored_secondary1236_v0__11_12}""
" array_296[@]
    echo "  -h, --help             Show this help message"
    echo "  --header=\"<text>\"      Set a header text to display above the options (ANSI escape supported)"
    echo "  --default=<yes|no>     Set the default selection (default: yes)"
    echo ""
}

execute_confirm__1452_v0() {
    local parameters=("${!1}")
    colored_primary__1235_v0 "Are you sure?"
    ret_colored_primary1235_v0__9_30="${ret_colored_primary1235_v0}"
    header_283="\\x1b[1m""${ret_colored_primary1235_v0__9_30}"
    default_yes_284=1
    for param_285 in "${parameters[@]}"; do
        match_regex__20_v0 "${param_285}" "^-h\$" 0
        ret_match_regex20_v0__14_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_285}" "^--help\$" 0
        ret_match_regex20_v0__14_43="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_285}" "^--header=.*\$" 0
        ret_match_regex20_v0__18_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_285}" "^--default=.*\$" 0
        ret_match_regex20_v0__22_13="${ret_match_regex20_v0}"
        if [ "$(( ${ret_match_regex20_v0__14_13} || ${ret_match_regex20_v0__14_43} ))" != 0 ]; then
            print_confirm_help__1401_v0 
            exit 0
        elif [ "${ret_match_regex20_v0__18_13}" != 0 ]; then
            split__5_v0 "${param_285}" "="
            result_286=("${ret_split5_v0[@]}")
            header_283="${result_286[1]}"
        elif [ "${ret_match_regex20_v0__22_13}" != 0 ]; then
            split__5_v0 "${param_285}" "="
            result_287=("${ret_split5_v0[@]}")
            if [ "$(( $([ "_${result_287[1]}" != "_yes" ]; echo $?) || $([ "_${result_287[1]}" != "_y" ]; echo $?) ))" != 0 ]; then
                default_yes_284=1
            elif [ "$(( $([ "_${result_287[1]}" != "_no" ]; echo $?) || $([ "_${result_287[1]}" != "_n" ]; echo $?) ))" != 0 ]; then
                default_yes_284=0
            else
                eprintf_colored__1254_v0 "ERROR: Invalid default value: ""${result_287[1]}"". Use 'yes' or 'no'.
" 31
                exit 1
            fi
        fi
    done
    has_ansi_escape__1266_v0 "${header_283}"
    ret_has_ansi_escape1266_v0__36_42="${ret_has_ansi_escape1266_v0}"
    escape_ansi__1267_v0 "${header_283}"
    ret_escape_ansi1267_v0__36_71="${ret_escape_ansi1267_v0}"
    colored_primary__1235_v0 "${header_283}"
    ret_colored_primary1235_v0__36_109="${ret_colored_primary1235_v0}"
    display_header_289="$(if [ "$(( $([ "_${header_283}" != "_" ]; echo $?) || ${ret_has_ansi_escape1266_v0__36_42} ))" != 0 ]; then echo "${ret_escape_ansi1267_v0__36_71}"; else echo "\\x1b[1m""${ret_colored_primary1235_v0__36_109}"; fi)"
    xyl_confirm__1325_v0 "${display_header_289}" "${default_yes_284}"
    result_342="${ret_xyl_confirm1325_v0}"
    ret_execute_confirm1452_v0="$(if [ "${result_342}" != 0 ]; then echo "yes"; else echo "no"; fi)"
    return 0
}

get_directory_entries__1570_v0() {
    local path=$1
    command_297="$(ls -lA "${path}" 2>/dev/null | tail -n +2)"
    __status=$?
    raw_370="${command_297}"
    command_298="$(ls -lA "${path}" | tail -n +2 | sed -E 's/^(.).*/\1/')"
    __status=$?
    types_371="${command_298}"
    command_299="$(ls -1A "${path}")"
    __status=$?
    names_372="${command_299}"
    split__5_v0 "${types_371}" "
"
    types_373=("${ret_split5_v0[@]}")
    split__5_v0 "${raw_370}" "
"
    raw_374=("${ret_split5_v0[@]}")
    split__5_v0 "${names_372}" "
"
    names_375=("${ret_split5_v0[@]}")
    entries_376=()
    from=0
    __length_301=("${raw_374[@]}")
    to="${#__length_301[@]}"
    for i_377 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        file_type_378="f"
        target_379=""
        if [ "$([ "_${types_373[${i_377}]}" != "_-" ]; echo $?)" != 0 ]; then
            file_type_378="f"
        elif [ "$([ "_${types_373[${i_377}]}" != "_d" ]; echo $?)" != 0 ]; then
            file_type_378="d"
        elif [ "$([ "_${types_373[${i_377}]}" != "_l" ]; echo $?)" != 0 ]; then
            command_302="$(echo ${raw_374[${i_377}]} | sed 's/.*-> //')"
            __status=$?
            target_379="${command_302}"
            file_type_378="l"
        fi
        if [ "$([ "_${file_type_378}" != "_l" ]; echo $?)" != 0 ]; then
            entries_376+=("${names_375[${i_377}]}	${types_373[${i_377}]}	${target_379}")
        else
            entries_376+=("${names_375[${i_377}]}	${types_373[${i_377}]}")
        fi
    done
    ret_get_directory_entries1570_v0=("${entries_376[@]}")
    return 0
}

parse_entry__1571_v0() {
    local entry=$1
    split__5_v0 "${entry}" "	"
    ret_parse_entry1571_v0=("${ret_split5_v0[@]}")
    return 0
}

get_cwd__1572_v0() {
    command_305="$(pwd)"
    __status=$?
    ret_get_cwd1572_v0="${command_305}"
    return 0
}

normalize_path__1573_v0() {
    local path=$1
    command_306="$(cd "${path}" 2>/dev/null && pwd)"
    __status=$?
    normalized_369="${command_306}"
    if [ "$([ "_${normalized_369}" != "_" ]; echo $?)" != 0 ]; then
        ret_normalize_path1573_v0="${path}"
        return 0
    fi
    ret_normalize_path1573_v0="${normalized_369}"
    return 0
}

is_directory__1574_v0() {
    local path=$1
    command_307="$([ -d "${path}" ] && echo "1" || echo "0")"
    __status=$?
    result_481="${command_307}"
    ret_is_directory1574_v0="$([ "_${result_481}" != "_1" ]; echo $?)"
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
    command_308="$(dirname "${path}")"
    __status=$?
    parent_477="${command_308}"
    ret_get_parent_dir1576_v0="${parent_477}"
    return 0
}

# Perl Extensions Utilities
command_309="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_39="$([ "_${command_309}" != "_No" ]; echo $?)"
command_310="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_40="$(( $(( ! ${_perl_disabled_39} )) && $([ "_${command_310}" != "_0" ]; echo $?) ))"
# global variables to store terminal size
# (prevent multiple queries in one session)
_got_term_size_41=0
_term_size_42=(80 24)
# stty lock/unlock using environment variable for cross-module state
export XYLITOL_RUNTIME_STTY_COUNT=0
__status=$?
stty_lock__1593_v0() {
    command_312="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_360="${command_312}"
    parse_int__14_v0 "${count_360}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_361="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_361} == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_361="$(( ${count_num_361} + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_361}
    __status=$?
}

stty_unlock__1594_v0() {
    command_313="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_389="${command_313}"
    parse_int__14_v0 "${count_389}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_390="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_390} > 0 ))" != 0 ]; then
        count_num_390="$(( ${count_num_390} - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_390}
        __status=$?
        if [ "$(( ${count_num_390} == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

get_term_size__1595_v0() {
    # Query terminal size with \x1b[18t, response format: \x1b[8;rows;colst
    command_314="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -rsd t _ignore height width < /dev/tty; echo "$height; $width")"
    __status=$?
    result_362="${command_314}"
    split__5_v0 "${result_362}" ";"
    parts_363=("${ret_split5_v0[@]}")
    __length_315=("${parts_363[@]}")
    if [ "$(( ${#__length_315[@]} != 2 ))" != 0 ]; then
        ret_get_term_size1595_v0=''
        return 1
    fi
    parse_int__14_v0 "${parts_363[0]}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_term_size1595_v0=''
        return "${__status}"
    fi
    rows_364="${ret_parse_int14_v0}"
    parse_int__14_v0 "${parts_363[1]}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_term_size1595_v0=''
        return "${__status}"
    fi
    cols_365="${ret_parse_int14_v0}"
    _term_size_42=("${cols_365}" "${rows_364}")
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
    config_355="${ret_env_var_get98_v0}"
    if [ "$([ "_${config_355}" != "_No" ]; echo $?)" != 0 ]; then
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
    colorterm_356="${ret_env_var_get98_v0}"
    _supports_truecolor_43="$(if [ "$(( $([ "_${colorterm_356}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_356}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
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
        primary_env_349="${ret_env_var_get98_v0}"
        if [ "$([ "_${primary_env_349}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${primary_env_349}" ";"
            parts_350=("${ret_split5_v0[@]}")
            __length_320=("${parts_350[@]}")
            if [ "$(( ${#__length_320[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_350[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__115_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_350[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__116_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_350[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__117_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_350[3]}"
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
        secondary_env_351="${ret_env_var_get98_v0}"
        if [ "$([ "_${secondary_env_351}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${secondary_env_351}" ";"
            parts_352=("${ret_split5_v0[@]}")
            __length_322=("${parts_352[@]}")
            if [ "$(( ${#__length_322[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_352[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__128_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_352[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__129_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_352[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__130_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_352[3]}"
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
        accent_env_353="${ret_env_var_get98_v0}"
        if [ "$([ "_${accent_env_353}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${accent_env_353}" ";"
            parts_354=("${ret_split5_v0[@]}")
            __length_324=("${parts_354[@]}")
            if [ "$(( ${#__length_324[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_354[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__141_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_354[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__142_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_354[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1611_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__143_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_354[3]}"
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
    array_326=("${message}")
    eprintf__1631_v0 "\\x1b[${color}m%s\\x1b[0m" array_326[@]
}

remove_current_line__1636_v0() {
    array_327=("")
    eprintf__1631_v0 "\\x1b[2K\\x1b[9999D" array_327[@]
}

# move the cursor up or down `cnt` lines.
# / Text Utilities /////
# // Application Utilities /////
# Perl Extensions Utilities
command_328="$(echo "$XYLITOL_USE_PERL")"
__status=$?
_perl_disabled_48="$([ "_${command_328}" != "_No" ]; echo $?)"
command_329="$(command -v perl > /dev/null && echo 0 || echo 1)"
__status=$?
_perl_available_49="$(( $(( ! ${_perl_disabled_48} )) && $([ "_${command_329}" != "_0" ]; echo $?) ))"
perl_get_cjk_width__1780_v0() {
    local text=$1
    if [ "$(( ! ${_perl_available_49} ))" != 0 ]; then
        ret_perl_get_cjk_width1780_v0=''
        return 1
    fi
    command_330="$(perl -CSDA -E '$w=0;$w+=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1 for split//,shift; say $w' "${text}" 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1780_v0=''
        return "${__status}"
    fi
    width_str_403="${command_330}"
    parse_int__14_v0 "${width_str_403}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_get_cjk_width1780_v0=''
        return "${__status}"
    fi
    width_404="${ret_parse_int14_v0}"
    ret_perl_get_cjk_width1780_v0="${width_404}"
    return 0
}

perl_truncate_cjk__1781_v0() {
    local text=$1
    local max_width=$2
    if [ "$(( ! ${_perl_available_49} ))" != 0 ]; then
        ret_perl_truncate_cjk1781_v0=''
        return 1
    fi
    command_331="$(perl -CSDA -E '$t=shift;$m=shift;$w=0;$r="";$c=/\p{EastAsianWidth=Wide}|\p{EastAsianWidth=Fullwidth}|\p{EastAsianWidth=Ambiguous}/?2:1,($w+$c<=$m?($w+=$c,$r.=$_):last) for split//,$t; print $r' "${text}" ${max_width} 2>/dev/null)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_perl_truncate_cjk1781_v0=''
        return "${__status}"
    fi
    result_408="${command_331}"
    ret_perl_truncate_cjk1781_v0="${result_408}"
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
    command_333="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_392="${command_333}"
    parse_int__14_v0 "${count_392}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_393="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_393} == 0 ))" != 0 ]; then
        stty -echo < /dev/tty
        __status=$?
    fi
    count_num_393="$(( ${count_num_393} + 1 ))"
    export XYLITOL_RUNTIME_STTY_COUNT=${count_num_393}
    __status=$?
}

stty_unlock__1789_v0() {
    command_334="$(echo "${XYLITOL_RUNTIME_STTY_COUNT:-0}")"
    __status=$?
    count_468="${command_334}"
    parse_int__14_v0 "${count_468}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    count_num_469="${ret_parse_int14_v0}"
    if [ "$(( ${count_num_469} > 0 ))" != 0 ]; then
        count_num_469="$(( ${count_num_469} - 1 ))"
        export XYLITOL_RUNTIME_STTY_COUNT=${count_num_469}
        __status=$?
        if [ "$(( ${count_num_469} == 0 ))" != 0 ]; then
            stty echo < /dev/tty
            __status=$?
        fi
    fi
}

get_term_size__1790_v0() {
    # Query terminal size with \x1b[18t, response format: \x1b[8;rows;colst
    command_335="$(printf '\x1b[18t' > /dev/tty; IFS=';' read -rsd t _ignore height width < /dev/tty; echo "$height; $width")"
    __status=$?
    result_394="${command_335}"
    split__5_v0 "${result_394}" ";"
    parts_395=("${ret_split5_v0[@]}")
    __length_336=("${parts_395[@]}")
    if [ "$(( ${#__length_336[@]} != 2 ))" != 0 ]; then
        ret_get_term_size1790_v0=''
        return 1
    fi
    parse_int__14_v0 "${parts_395[0]}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_term_size1790_v0=''
        return "${__status}"
    fi
    rows_396="${ret_parse_int14_v0}"
    parse_int__14_v0 "${parts_395[1]}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_term_size1790_v0=''
        return "${__status}"
    fi
    cols_397="${ret_parse_int14_v0}"
    _term_size_51=("${cols_397}" "${rows_396}")
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
    config_454="${ret_env_var_get98_v0}"
    if [ "$([ "_${config_454}" != "_No" ]; echo $?)" != 0 ]; then
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
    colorterm_455="${ret_env_var_get98_v0}"
    _supports_truecolor_52="$(if [ "$(( $([ "_${colorterm_455}" != "_truecolor" ]; echo $?) || $([ "_${colorterm_455}" != "_24bit" ]; echo $?) ))" != 0 ]; then echo "Yes"; else echo "No"; fi)"
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
        primary_env_448="${ret_env_var_get98_v0}"
        if [ "$([ "_${primary_env_448}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${primary_env_448}" ";"
            parts_449=("${ret_split5_v0[@]}")
            __length_341=("${parts_449[@]}")
            if [ "$(( ${#__length_341[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_449[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__115_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_449[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__116_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_449[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__117_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_449[3]}"
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
        secondary_env_450="${ret_env_var_get98_v0}"
        if [ "$([ "_${secondary_env_450}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${secondary_env_450}" ";"
            parts_451=("${ret_split5_v0[@]}")
            __length_343=("${parts_451[@]}")
            if [ "$(( ${#__length_343[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_451[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__128_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_451[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__129_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_451[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__130_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_451[3]}"
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
        accent_env_452="${ret_env_var_get98_v0}"
        if [ "$([ "_${accent_env_452}" == "_" ]; echo $?)" != 0 ]; then
            split__5_v0 "${accent_env_452}" ";"
            parts_453=("${ret_split5_v0[@]}")
            __length_345=("${parts_453[@]}")
            if [ "$(( ${#__length_345[@]} == 4 ))" != 0 ]; then
                parse_int__14_v0 "${parts_453[0]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__141_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_453[1]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__142_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_453[2]}"
                __status=$?
                if [ "${__status}" != 0 ]; then
                    ret_inner_get_xylitol_colors1806_v0=''
                    return "${__status}"
                fi
                ret_parse_int14_v0__143_21="${ret_parse_int14_v0}"
                parse_int__14_v0 "${parts_453[3]}"
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
    command_347="$(read -rsn1 k < /dev/tty; if [[ "$k" == $'\e' ]]; then read -rsn2 r < /dev/tty; k+=$r; fi; printf '%q' "$k")"
    __status=$?
    var_458="${command_347}"
    if [ "$([ "_${var_458}" != "_\$'\\E[A'" ]; echo $?)" != 0 ]; then
        ret_get_key1824_v0="UP"
        return 0
    elif [ "$([ "_${var_458}" != "_\$'\\E[B'" ]; echo $?)" != 0 ]; then
        ret_get_key1824_v0="DOWN"
        return 0
    elif [ "$([ "_${var_458}" != "_\$'\\E[C'" ]; echo $?)" != 0 ]; then
        ret_get_key1824_v0="RIGHT"
        return 0
    elif [ "$([ "_${var_458}" != "_\$'\\E[D'" ]; echo $?)" != 0 ]; then
        ret_get_key1824_v0="LEFT"
        return 0
    elif [ "$([ "_${var_458}" != "_\$'\\177'" ]; echo $?)" != 0 ]; then
        ret_get_key1824_v0="BACKSPACE"
        return 0
    elif [ "$([ "_${var_458}" != "_''" ]; echo $?)" != 0 ]; then
        ret_get_key1824_v0="INPUT"
        return 0
    else
        ret_get_key1824_v0="${var_458}"
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
    array_348=("${message}")
    eprintf__1826_v0 "\\x1b[${color}m%s\\x1b[0m" array_348[@]
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
    if [ "$(( ${cnt} > 0 ))" != 0 ]; then
        sequence_464=""
        from=0
        to="${cnt}"
        for ____465 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
            sequence_464+="\\x1b[2K\\x1b[1A"
        done
        array_349=("")
        eprintf__1826_v0 "${sequence_464}" array_349[@]
    fi
    array_350=("")
    eprintf__1826_v0 "\\x1b[9999D" array_350[@]
}

remove_current_line__1831_v0() {
    array_351=("")
    eprintf__1826_v0 "\\x1b[2K\\x1b[9999D" array_351[@]
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
    for i_428 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        array_352=("")
        eprintf__1826_v0 "
" array_352[@]
    done
}

go_up__1834_v0() {
    local cnt=$1
    array_353=("")
    eprintf__1826_v0 "\\x1b[${cnt}A" array_353[@]
}

go_down__1835_v0() {
    local cnt=$1
    array_354=("")
    eprintf__1826_v0 "\\x1b[${cnt}B" array_354[@]
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
    array_355=("")
    eprintf__1826_v0 "\\x1b[?25l" array_355[@]
}

show_cursor__1838_v0() {
    array_356=("")
    eprintf__1826_v0 "\\x1b[?25h" array_356[@]
}

# / Text Utilities /////
has_ansi_escape__1839_v0() {
    local text=$1
    # Check for ESC character (0x1B = 27) or literal \x1b[
    command_357="$([[ "${text}" == *$'\x1b'* || "${text}" == *'\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    has_escape_406="${command_357}"
    ret_has_ansi_escape1839_v0="$([ "_${has_escape_406}" != "_1" ]; echo $?)"
    return 0
}

strip_ansi__1841_v0() {
    local text=$1
    command_358="$(printf "%s" "${text}" | sed $'s/\x1b\[[0-9;]*m//g' | sed 's/\\x1b\[[0-9;]*m//g')"
    __status=$?
    ret_strip_ansi1841_v0="${command_358}"
    return 0
}

is_all_ascii__1842_v0() {
    local text=$1
    command_359="$(printf "%s" "${text}" | LC_ALL=C grep -q '^[ -~]*$' && echo 0 || echo 1)"
    __status=$?
    result_402="${command_359}"
    ret_is_all_ascii1842_v0="$([ "_${result_402}" != "_0" ]; echo $?)"
    return 0
}

get_visible_len__1843_v0() {
    local text=$1
    strip_ansi__1841_v0 "${text}"
    stripped_401="${ret_strip_ansi1841_v0}"
    # Check if text is all ASCII
    is_all_ascii__1842_v0 "${stripped_401}"
    ret_is_all_ascii1842_v0__150_12="${ret_is_all_ascii1842_v0}"
    if [ "$(( ! ${ret_is_all_ascii1842_v0__150_12} ))" != 0 ]; then
        # Try using perl
        perl_get_cjk_width__1780_v0 "${stripped_401}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            __length_360="${stripped_401}"
            ret_get_visible_len1843_v0="${#__length_360}"
            return 0
        fi
        ret_get_visible_len1843_v0="${ret_perl_get_cjk_width1780_v0}"
        return 0
    else
        __length_361="${stripped_401}"
        ret_get_visible_len1843_v0="${#__length_361}"
        return 0
    fi
}

truncate_text__1844_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__1843_v0 "${text}"
    visible_len_407="${ret_get_visible_len1843_v0}"
    if [ "$(( ${visible_len_407} <= ${max_width} ))" != 0 ]; then
        ret_truncate_text1844_v0="${text}"
        return 0
    fi
    is_all_ascii__1842_v0 "${text}"
    ret_is_all_ascii1842_v0__167_12="${ret_is_all_ascii1842_v0}"
    if [ "$(( ! ${ret_is_all_ascii1842_v0__167_12} ))" != 0 ]; then
        perl_truncate_cjk__1781_v0 "${text}" "${max_width}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            printf "%s" "${text}" | cut -c1-${max_width}
            __status=$?
        fi
        ret_truncate_text1844_v0="${ret_perl_truncate_cjk1781_v0}"
        return 0
    fi
    command_362="$(printf "%s" "${text}" | cut -c1-${max_width})"
    __status=$?
    ret_truncate_text1844_v0="${command_362}"
    return 0
}

truncate_ansi__1845_v0() {
    local text=$1
    local max_width=$2
    has_ansi_escape__1839_v0 "${text}"
    ret_has_ansi_escape1839_v0__179_12="${ret_has_ansi_escape1839_v0}"
    if [ "$(( ! ${ret_has_ansi_escape1839_v0__179_12} ))" != 0 ]; then
        truncate_text__1844_v0 "${text}" "${max_width}"
        ret_truncate_ansi1845_v0="${ret_truncate_text1844_v0}"
        return 0
    fi
    # Check if text starts with \x1b[
    command_363="$([[ "${text}" == '\x1b['* ]] && echo "1" || echo "0")"
    __status=$?
    starts_with_ansi_409="${command_363}"
    # Replace \x1b[ with newline, then split
    command_364="$(t="${text}"; printf '%s' "${t//\\x1b[/
}")"
    __status=$?
    replaced_410="${command_364}"
    split__5_v0 "${replaced_410}" "
"
    parts_411=("${ret_split5_v0[@]}")
    result_412=""
    remaining_width_413="${max_width}"
    from=0
    __length_365=("${parts_411[@]}")
    to="${#__length_365[@]}"
    for idx_414 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        part_415="${parts_411[${idx_414}]}"
        # If text starts with ANSI, all parts are "ANSIparams m text" format
        # If not, first part is pure text
        if [ "$(( $(( ${idx_414} == 0 )) && $([ "_${starts_with_ansi_409}" != "_0" ]; echo $?) ))" != 0 ]; then
            # First part is pure text (before any ANSI)
            if [ "$(( $([ "_${part_415}" == "_" ]; echo $?) && $(( ${remaining_width_413} > 0 )) ))" != 0 ]; then
                truncate_text__1844_v0 "${part_415}" "${remaining_width_413}"
                truncated_416="${ret_truncate_text1844_v0}"
                result_412+="${truncated_416}"
                get_visible_len__1843_v0 "${truncated_416}"
                ret_get_visible_len1843_v0__203_36="${ret_get_visible_len1843_v0}"
                remaining_width_413="$(( ${remaining_width_413} - ${ret_get_visible_len1843_v0__203_36} ))"
            fi
        else
            # Part is "ANSIparams m text" format - find first 'm'
            command_366="$(__p="${part_415}"; for ((i=0; i<${#__p}; i++)); do [[ "${__p:$i:1}" == "m" ]] && echo $i && break; done)"
            __status=$?
            m_idx_417="${command_366}"
            if [ "$([ "_${m_idx_417}" == "_" ]; echo $?)" != 0 ]; then
                # Reconstruct ANSI sequence
                command_367="$(__p="${part_415}"; printf "%s" "${__p:0:${m_idx_417}}")"
                __status=$?
                ansi_params_418="${command_367}"
                result_412+="\\x1b[""${ansi_params_418}""m"
                # Rest is text content
                parse_int__14_v0 "${m_idx_417}"
                __status=$?
                m_idx_num_419="${ret_parse_int14_v0}"
                text_start_420="$(( ${m_idx_num_419} + 1 ))"
                command_368="$(__p="${part_415}"; printf "%s" "${__p:${text_start_420}}")"
                __status=$?
                text_part_421="${command_368}"
                if [ "$(( $([ "_${text_part_421}" == "_" ]; echo $?) && $(( ${remaining_width_413} > 0 )) ))" != 0 ]; then
                    truncate_text__1844_v0 "${text_part_421}" "${remaining_width_413}"
                    truncated_422="${ret_truncate_text1844_v0}"
                    result_412+="${truncated_422}"
                    get_visible_len__1843_v0 "${truncated_422}"
                    ret_get_visible_len1843_v0__220_40="${ret_get_visible_len1843_v0}"
                    remaining_width_413="$(( ${remaining_width_413} - ${ret_get_visible_len1843_v0__220_40} ))"
                fi
            else
                # No 'm' found, treat as text
                if [ "$(( $([ "_${part_415}" == "_" ]; echo $?) && $(( ${remaining_width_413} > 0 )) ))" != 0 ]; then
                    truncate_text__1844_v0 "${part_415}" "${remaining_width_413}"
                    truncated_423="${ret_truncate_text1844_v0}"
                    result_412+="${truncated_423}"
                    get_visible_len__1843_v0 "${truncated_423}"
                    remaining_width_413="$(( ${remaining_width_413} - ${ret_get_visible_len1843_v0__227_40} ))"
                fi
            fi
        fi
    done
    ret_truncate_ansi1845_v0="${result_412}"
    return 0
}

cutoff_text__1846_v0() {
    local text=$1
    local max_width=$2
    get_visible_len__1843_v0 "${text}"
    visible_len_405="${ret_get_visible_len1843_v0}"
    if [ "$(( ${visible_len_405} <= ${max_width} ))" != 0 ]; then
        ret_cutoff_text1846_v0="${text}"
        return 0
    fi
    truncate_ansi__1845_v0 "${text}" "$(( ${max_width} - 3 ))"
    ret_truncate_ansi1845_v0__243_12="${ret_truncate_ansi1845_v0}"
    ret_cutoff_text1846_v0="${ret_truncate_ansi1845_v0__243_12}""..."
    return 0
}

# // Application Utilities /////
render_tooltip__1847_v0() {
    local items=("${!1}")
    local total_len=$2
    local term_width=$3
    separator_429=" • "
    separator_len_430=3
    # Fast path: no truncation needed
    if [ "$(( ${total_len} <= ${term_width} ))" != 0 ]; then
        iter_431=0
        while :
        do
            __length_369=("${items[@]}")
            if [ "$(( ${iter_431} >= ${#__length_369[@]} ))" != 0 ]; then
                break
            elif [ "$(( ${iter_431} > 0 ))" != 0 ]; then
                eprintf_colored__1827_v0 "${separator_429}" 90
            fi
            colored__1828_v0 "${items[$(( ${iter_431} + 1 ))]}" 2
            ret_colored1828_v0__268_41="${ret_colored1828_v0}"
            array_370=("")
            eprintf__1826_v0 "${items[${iter_431}]}"" ""${ret_colored1828_v0__268_41}" array_370[@]
            iter_431="$(( ${iter_431} + 2 ))"
        done
    else
        # Slow path: truncate
        current_len_432=0
        first_433=1
        iter_434=0
        while :
        do
            __length_371=("${items[@]}")
            if [ "$(( ${iter_434} >= ${#__length_371[@]} ))" != 0 ]; then
                break
            fi
            key_435="${items[${iter_434}]}"
            action_436="${items[$(( ${iter_434} + 1 ))]}"
            __length_372="${key_435}"
            __length_373="${action_436}"
            part_len_437="$(( $(( ${#__length_372} + 1 )) + ${#__length_373} ))"
            needed_438="${part_len_437}"
            if [ "$(( ! ${first_433} ))" != 0 ]; then
                needed_438="$(( ${needed_438} + ${separator_len_430} ))"
            fi
            if [ "$(( $(( ${current_len_432} + ${needed_438} )) > ${term_width} ))" != 0 ]; then
                break
            fi
            if [ "$(( ! ${first_433} ))" != 0 ]; then
                eprintf_colored__1827_v0 "${separator_429}" 90
            fi
            colored__1828_v0 "${action_436}" 2
            ret_colored1828_v0__296_33="${ret_colored1828_v0}"
            array_374=("")
            eprintf__1826_v0 "${key_435}"" ""${ret_colored1828_v0__296_33}" array_374[@]
            current_len_432="$(( ${current_len_432} + ${needed_438} ))"
            first_433=0
            iter_434="$(( ${iter_434} + 2 ))"
        done
    fi
}

get_page_options__1897_v0() {
    local options=("${!1}")
    local page=$2
    local page_size=$3
    start_439="$(( ${page} * ${page_size} ))"
    end_440="$(( ${start_439} + ${page_size} ))"
    __length_375=("${options[@]}")
    if [ "$(( ${end_440} > ${#__length_375[@]} ))" != 0 ]; then
        __length_376=("${options[@]}")
        end_440="${#__length_376[@]}"
    fi
    result_441=()
    from="${start_439}"
    to="${end_440}"
    for i_442 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        result_441+=("${options[${i_442}]}")
    done
    ret_get_page_options1897_v0=("${result_441[@]}")
    return 0
}

render_choose_page__1899_v0() {
    local page_options=("${!1}")
    local sel=$2
    local cursor=$3
    local display_count=$4
    local term_width=$5
    __length_379="${cursor}"
    cursor_len_444="${#__length_379}"
    max_option_width_445="$(( $(( ${term_width} - ${cursor_len_444} )) - 1 ))"
    from=0
    __length_380=("${page_options[@]}")
    to="${#__length_380[@]}"
    for i_446 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
        cutoff_text__1846_v0 "${page_options[${i_446}]}" "${max_option_width_445}"
        truncated_option_447="${ret_cutoff_text1846_v0}"
        if [ "$(( ${i_446} == ${sel} ))" != 0 ]; then
            colored_secondary__1809_v0 "${cursor}""${truncated_option_447}""
"
            ret_colored_secondary1809_v0__28_21="${ret_colored_secondary1809_v0}"
            array_381=("")
            eprintf__1826_v0 "${ret_colored_secondary1809_v0__28_21}" array_381[@]
        else
            print_blank__1832_v0 "${cursor_len_444}"
            array_382=("")
            eprintf__1826_v0 "${truncated_option_447}""
" array_382[@]
        fi
    done
    __length_383=("${page_options[@]}")
    remaining_slots_456="$(( ${display_count} - ${#__length_383[@]} ))"
    if [ "$(( ${remaining_slots_456} > 0 ))" != 0 ]; then
        # Amber bug gaurd
        from=0
        to="${remaining_slots_456}"
        for ____457 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
            array_384=("")
            eprintf__1826_v0 "\\x1b[K
" array_384[@]
        done
    fi
}

render_page_indicator__1901_v0() {
    local page=$1
    local total_pages=$2
    if [ "$(( ${total_pages} > 1 ))" != 0 ]; then
        array_385=("")
        eprintf__1826_v0 "\\x1b[9999D\\x1b[K" array_385[@]
        eprintf_colored__1827_v0 "Page $(( ${page} + 1 ))/${total_pages}" 90
        array_386=("")
        eprintf__1826_v0 "\\x1b[9999D" array_386[@]
    fi
}

xyl_choose__1902_v0() {
    local options=("${!1}")
    local cursor=$2
    local header=$3
    local page_size=$4
    __length_387=("${options[@]}")
    if [ "$(( ${#__length_387[@]} == 0 ))" != 0 ]; then
        eprintf_colored__1827_v0 "ERROR: No options provided.
" 31
        exit 1
    fi
    stty_lock__1788_v0 
    hide_cursor__1837_v0 
    term_width__1792_v0 
    term_width_398="${ret_term_width1792_v0}"
    term_height__1793_v0 
    term_height_399="${ret_term_height1793_v0}"
    max_page_size_400="$(( ${term_height_399} - $(if [ "$([ "_${header}" != "_" ]; echo $?)" != 0 ]; then echo 2; else echo 3; fi) ))"
    if [ "$(( ${page_size} > ${max_page_size_400} ))" != 0 ]; then
        page_size="${max_page_size_400}"
    fi
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        cutoff_text__1846_v0 "${header}" "${term_width_398}"
        ret_cutoff_text1846_v0__107_17="${ret_cutoff_text1846_v0}"
        array_388=("")
        eprintf__1826_v0 "${ret_cutoff_text1846_v0__107_17}""
" array_388[@]
    fi
    __length_389=("${options[@]}")
    math_floor__416_v0 "$(( $(( $(( ${#__length_389[@]} + ${page_size} )) - 1 )) / ${page_size} ))"
    total_pages_424="${ret_math_floor416_v0}"
    current_page_425=0
    selected_426=0
    display_count_427="${page_size}"
    __length_390=("${options[@]}")
    if [ "$(( ${#__length_390[@]} < ${page_size} ))" != 0 ]; then
        __length_391=("${options[@]}")
        display_count_427="${#__length_391[@]}"
    fi
    new_line__1833_v0 "${display_count_427}"
    array_392=("")
    eprintf__1826_v0 "\\x1b[9999D" array_392[@]
    if [ "$(( ${total_pages_424} > 1 ))" != 0 ]; then
        eprintf_colored__1827_v0 "Page $(( ${current_page_425} + 1 ))/${total_pages_424}" 90
    fi
    new_line__1833_v0 1
    # "↑↓ select • enter confirm" = 9 + 3 + 13 = 25
    # "↑↓ select • ←→ page • enter confirm" = 9 + 3 + 8 + 3 + 13 = 36
    if [ "$(( ${total_pages_424} > 1 ))" != 0 ]; then
        array_393=("↑↓" "select" "←→" "page" "enter" "confirm")
        render_tooltip__1847_v0 array_393[@] 36 "${term_width_398}"
    else
        array_394=("↑↓" "select" "enter" "confirm")
        render_tooltip__1847_v0 array_394[@] 25 "${term_width_398}"
    fi
    go_up__1834_v0 "$(( ${display_count_427} + 1 ))"
    array_395=("")
    eprintf__1826_v0 "\\x1b[9999D" array_395[@]
    get_page_options__1897_v0 options[@] "${current_page_425}" "${page_size}"
    page_options_443=("${ret_get_page_options1897_v0[@]}")
    render_choose_page__1899_v0 page_options_443[@] "${selected_426}" "${cursor}" "${display_count_427}" "${term_width_398}"
    while :
    do
        get_key__1824_v0 
        key_459="${ret_get_key1824_v0}"
        prev_selected_460="${selected_426}"
        prev_page_461="${current_page_425}"
        up_paged_462=0
        if [ "$(( $([ "_${key_459}" != "_UP" ]; echo $?) || $([ "_${key_459}" != "_k" ]; echo $?) ))" != 0 ]; then
            if [ "$(( $(( ${selected_426} == 0 )) && $(( ${total_pages_424} > 1 )) ))" != 0 ]; then
                if [ "$(( ${current_page_425} > 0 ))" != 0 ]; then
                    current_page_425="$(( ${current_page_425} - 1 ))"
                else
                    current_page_425="$(( ${total_pages_424} - 1 ))"
                fi
                up_paged_462=1
            elif [ "$(( ${selected_426} == 0 ))" != 0 ]; then
                __length_396=("${page_options_443[@]}")
                selected_426="$(( ${#__length_396[@]} - 1 ))"
            else
                selected_426="$(( ${selected_426} - 1 ))"
            fi
        elif [ "$(( $([ "_${key_459}" != "_DOWN" ]; echo $?) || $([ "_${key_459}" != "_j" ]; echo $?) ))" != 0 ]; then
            __length_397=("${page_options_443[@]}")
            if [ "$(( ${selected_426} == $(( ${#__length_397[@]} - 1 )) ))" != 0 ]; then
                if [ "$(( ${current_page_425} < $(( ${total_pages_424} - 1 )) ))" != 0 ]; then
                    current_page_425="$(( ${current_page_425} + 1 ))"
                    selected_426=0
                else
                    current_page_425=0
                    selected_426=0
                fi
            else
                selected_426="$(( ${selected_426} + 1 ))"
            fi
        elif [ "$(( $([ "_${key_459}" != "_LEFT" ]; echo $?) || $([ "_${key_459}" != "_h" ]; echo $?) ))" != 0 ]; then
            if [ "$(( ${current_page_425} > 0 ))" != 0 ]; then
                current_page_425="$(( ${current_page_425} - 1 ))"
                selected_426=0
            else
                selected_426=0
            fi
        elif [ "$(( $([ "_${key_459}" != "_RIGHT" ]; echo $?) || $([ "_${key_459}" != "_l" ]; echo $?) ))" != 0 ]; then
            if [ "$(( ${current_page_425} < $(( ${total_pages_424} - 1 )) ))" != 0 ]; then
                current_page_425="$(( ${current_page_425} + 1 ))"
                selected_426=0
            else
                __length_398=("${page_options_443[@]}")
                selected_426="$(( ${#__length_398[@]} - 1 ))"
            fi
        elif [ "$([ "_${key_459}" != "_INPUT" ]; echo $?)" != 0 ]; then
            break
        else
            continue
        fi
        __length_399="${cursor}"
        max_option_width_463="$(( $(( ${term_width_398} - ${#__length_399} )) - 1 ))"
        if [ "$(( ${prev_page_461} != ${current_page_425} ))" != 0 ]; then
            get_page_options__1897_v0 options[@] "${current_page_425}" "${page_size}"
            page_options_443=("${ret_get_page_options1897_v0[@]}")
            if [ "${up_paged_462}" != 0 ]; then
                __length_400=("${page_options_443[@]}")
                selected_426="$(( ${#__length_400[@]} - 1 ))"
            fi
            go_up__1834_v0 1
            remove_line__1830_v0 "$(( ${display_count_427} - 1 ))"
            remove_current_line__1831_v0 
            array_401=("")
            eprintf__1826_v0 "\\x1b[9999D" array_401[@]
            render_choose_page__1899_v0 page_options_443[@] "${selected_426}" "${cursor}" "${display_count_427}" "${term_width_398}"
            render_page_indicator__1901_v0 "${current_page_425}" "${total_pages_424}"
        elif [ "$(( ${prev_selected_460} != ${selected_426} ))" != 0 ]; then
            go_up__1834_v0 "$(( ${display_count_427} - ${prev_selected_460} ))"
            array_402=("")
            eprintf__1826_v0 "\\x1b[K" array_402[@]
            __length_403="${cursor}"
            print_blank__1832_v0 "${#__length_403}"
            cutoff_text__1846_v0 "${page_options_443[${prev_selected_460}]}" "${max_option_width_463}"
            ret_cutoff_text1846_v0__218_25="${ret_cutoff_text1846_v0}"
            array_404=("")
            eprintf__1826_v0 "${ret_cutoff_text1846_v0__218_25}" array_404[@]
            diff_466="$(( ${selected_426} - ${prev_selected_460} ))"
            go_up_or_down__1836_v0 "${diff_466}"
            array_405=("")
            eprintf__1826_v0 "\\x1b[9999D" array_405[@]
            array_406=("")
            eprintf__1826_v0 "\\x1b[K" array_406[@]
            cutoff_text__1846_v0 "${page_options_443[${selected_426}]}" "${max_option_width_463}"
            ret_cutoff_text1846_v0__224_52="${ret_cutoff_text1846_v0}"
            colored_secondary__1809_v0 "${cursor}""${ret_cutoff_text1846_v0__224_52}"
            ret_colored_secondary1809_v0__224_25="${ret_colored_secondary1809_v0}"
            array_407=("")
            eprintf__1826_v0 "${ret_colored_secondary1809_v0__224_25}" array_407[@]
            go_down__1835_v0 "$(( ${display_count_427} - ${selected_426} ))"
            array_408=("")
            eprintf__1826_v0 "\\x1b[9999D" array_408[@]
        fi
    done
    total_lines_467="$(( ${display_count_427} + 2 ))"
    if [ "$([ "_${header}" == "_" ]; echo $?)" != 0 ]; then
        total_lines_467="$(( ${total_lines_467} + 1 ))"
    fi
    go_down__1835_v0 1
    remove_line__1830_v0 "$(( ${total_lines_467} - 1 ))"
    remove_current_line__1831_v0 
    stty_unlock__1789_v0 
    show_cursor__1838_v0 
    global_selected_470="$(( $(( ${current_page_425} * ${page_size} )) + ${selected_426} ))"
    ret_xyl_choose1902_v0="${options[${global_selected_470}]}"
    return 0
}

format_entry_display__1906_v0() {
    local entry=("${!1}")
    name_387="${entry[0]}"
    file_type_388="${entry[1]}"
    if [ "$([ "_${file_type_388}" != "_d" ]; echo $?)" != 0 ]; then
        colored_primary__1613_v0 "/"
        ret_colored_primary1613_v0__13_23="${ret_colored_primary1613_v0}"
        ret_format_entry_display1906_v0="${name_387}""${ret_colored_primary1613_v0__13_23}"
        return 0
    fi
    if [ "$([ "_${file_type_388}" != "_l" ]; echo $?)" != 0 ]; then
        colored_accent__1615_v0 " > "
        ret_colored_accent1615_v0__16_23="${ret_colored_accent1615_v0}"
        colored_primary__1613_v0 "${entry[2]}"
        ret_colored_primary1613_v0__16_47="${ret_colored_primary1613_v0}"
        ret_format_entry_display1906_v0="${name_387}""${ret_colored_accent1615_v0__16_23}""${ret_colored_primary1613_v0__16_47}"
        return 0
    fi
    ret_format_entry_display1906_v0="${name_387}"
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
    current_path_368="${start_path}"
    if [ "$([ "_${current_path_368}" != "_" ]; echo $?)" != 0 ]; then
        get_cwd__1572_v0 
        current_path_368="${ret_get_cwd1572_v0}"
    fi
    normalize_path__1573_v0 "${current_path_368}"
    current_path_368="${ret_normalize_path1573_v0}"
    while :
    do
        colored_primary__1613_v0 "Loading files..."
        ret_colored_primary1613_v0__47_17="${ret_colored_primary1613_v0}"
        array_410=("")
        eprintf__1631_v0 "${ret_colored_primary1613_v0__47_17}" array_410[@]
        # Get directory entries
        get_directory_entries__1570_v0 "${current_path_368}"
        raw_entries_380=("${ret_get_directory_entries1570_v0[@]}")
        # Build options list and parallel entries list
        options_381=()
        entries_382=()
        # Add parent directory entry (..)
        if [ "$([ "_${current_path_368}" == "_/" ]; echo $?)" != 0 ]; then
            options_381+=("..")
            entries_382+=("..	d")
        fi
        for raw_entry_383 in "${raw_entries_380[@]}"; do
            parse_entry__1571_v0 "${raw_entry_383}"
            entry_384=("${ret_parse_entry1571_v0[@]}")
            name_385="${entry_384[0]}"
            # Skip hidden files if not showing them
            command_415="$(echo "${name_385}" | cut -c1)"
            __status=$?
            first_char_386="${command_415}"
            if [ "$(( $(( ! ${show_hidden} )) && $([ "_${first_char_386}" != "_." ]; echo $?) ))" != 0 ]; then
                continue
            fi
            format_entry_display__1906_v0 entry_384[@]
            ret_format_entry_display1906_v0__70_25="${ret_format_entry_display1906_v0}"
            options_381+=("${ret_format_entry_display1906_v0__70_25}")
            entries_382+=("${raw_entry_383}")
        done
        __length_418=("${entries_382[@]}")
        if [ "$(( ${#__length_418[@]} == 0 ))" != 0 ]; then
            eprintf_colored__1632_v0 "ERROR: Directory is empty or inaccessible.
" 31
            stty_unlock__1594_v0 
            ret_xyl_file1907_v0=""
            return 0
        fi
        # Use xyl_choose with current path as header
        colored_primary__1613_v0 "${current_path_368}"
        header_391="${ret_colored_primary1613_v0}"
        remove_current_line__1636_v0 
        xyl_choose__1902_v0 options_381[@] "${cursor}" "${header_391}" "${page_size}"
        selected_option_471="${ret_xyl_choose1902_v0}"
        # Find selected entry index
        selected_idx_472=-1
        from=0
        __length_419=("${options_381[@]}")
        to="${#__length_419[@]}"
        for i_473 in $(if [ "${from}" -gt "${to}" ]; then seq -- "${from}" -1 "$(( ${to} + 1 ))"; elif [ "${from}" -lt "${to}" ]; then seq -- "${from}" "$(( ${to} - 1 ))"; fi); do
            if [ "$([ "_${options_381[${i_473}]}" != "_${selected_option_471}" ]; echo $?)" != 0 ]; then
                selected_idx_472="${i_473}"
                break
            fi
        done
        if [ "$(( ${selected_idx_472} < 0 ))" != 0 ]; then
            ret_xyl_file1907_v0=""
            return 0
        fi
        parse_entry__1571_v0 "${entries_382[${selected_idx_472}]}"
        entry_474=("${ret_parse_entry1571_v0[@]}")
        name_475="${entry_474[0]}"
        file_type_476="${entry_474[1]}"
        if [ "$([ "_${name_475}" != "_.." ]; echo $?)" != 0 ]; then
            get_parent_dir__1576_v0 "${current_path_368}"
            current_path_368="${ret_get_parent_dir1576_v0}"
        elif [ "$([ "_${file_type_476}" != "_d" ]; echo $?)" != 0 ]; then
            path_join__1575_v0 "${current_path_368}" "${name_475}"
            current_path_368="${ret_path_join1575_v0}"
            normalize_path__1573_v0 "${current_path_368}"
            current_path_368="${ret_normalize_path1573_v0}"
        elif [ "$([ "_${file_type_476}" != "_l" ]; echo $?)" != 0 ]; then
            # Resolve symlink target path
            target_478="${entry_474[2]}"
            target_path_479="${target_478}"
            starts_with__23_v0 "${target_478}" "/"
            ret_starts_with23_v0__115_24="${ret_starts_with23_v0}"
            if [ "$(( ! ${ret_starts_with23_v0__115_24} ))" != 0 ]; then
                path_join__1575_v0 "${current_path_368}" "${target_478}"
                target_path_479="${ret_path_join1575_v0}"
            fi
            # Follow symlink if it points to a directory, otherwise return path
            is_directory__1574_v0 "${target_path_479}"
            ret_is_directory1574_v0__119_20="${ret_is_directory1574_v0}"
            if [ "${ret_is_directory1574_v0__119_20}" != 0 ]; then
                current_path_368="${target_path_479}"
                normalize_path__1573_v0 "${current_path_368}"
                current_path_368="${ret_normalize_path1573_v0}"
            else
                stty_unlock__1594_v0 
                path_join__1575_v0 "${current_path_368}" "${name_475}"
                ret_xyl_file1907_v0="${ret_path_join1575_v0}"
                return 0
            fi
        else
            stty_unlock__1594_v0 
            path_join__1575_v0 "${current_path_368}" "${name_475}"
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
    array_420=("")
    printf__106_v0 "${ret_colored_primary1613_v0__7_12}" array_420[@]
    array_421=("")
    printf__106_v0 " - Browse filesystem and select a file." array_421[@]
    echo ""
    echo ""
    colored_secondary__1614_v0 "Arguments: "
    ret_colored_secondary1614_v0__11_12="${ret_colored_secondary1614_v0}"
    array_422=("")
    printf__106_v0 "${ret_colored_secondary1614_v0__11_12}""
" array_422[@]
    echo "  [<path>]               Starting directory path (default: current directory)"
    echo ""
    colored_secondary__1614_v0 "Flags: "
    ret_colored_secondary1614_v0__14_12="${ret_colored_secondary1614_v0}"
    array_423=("")
    printf__106_v0 "${ret_colored_secondary1614_v0__14_12}""
" array_423[@]
    echo "  -h, --help             Show this help message"
    echo "  -a, --all              Show hidden files"
    echo "  --cursor=\"<text>\"      Set the cursor text (default: '> ')"
    echo "  --path=\"<path>\"        Set the starting directory path"
    echo "  --page-size=<number>   Set the number of entries per page (default: 10)"
    echo ""
}

execute_file__2034_v0() {
    local parameters=("${!1}")
    cursor_344="> "
    start_path_345=""
    show_hidden_346=0
    page_size_347=10
    for param_348 in "${parameters[@]:2:9997}"; do
        match_regex__20_v0 "${param_348}" "^-h\$" 0
        ret_match_regex20_v0__14_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_348}" "^--help\$" 0
        ret_match_regex20_v0__14_43="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_348}" "^--cursor=.*\$" 0
        ret_match_regex20_v0__18_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_348}" "^--path=.*\$" 0
        ret_match_regex20_v0__22_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_348}" "^-a\$" 0
        ret_match_regex20_v0__26_13="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_348}" "^--all\$" 0
        ret_match_regex20_v0__26_43="${ret_match_regex20_v0}"
        match_regex__20_v0 "${param_348}" "^--page-size=.*\$" 0
        ret_match_regex20_v0__29_13="${ret_match_regex20_v0}"
        if [ "$(( ${ret_match_regex20_v0__14_13} || ${ret_match_regex20_v0__14_43} ))" != 0 ]; then
            print_file_help__1983_v0 
            exit 0
        elif [ "${ret_match_regex20_v0__18_13}" != 0 ]; then
            split__5_v0 "${param_348}" "="
            result_357=("${ret_split5_v0[@]}")
            cursor_344="${result_357[1]}"
        elif [ "${ret_match_regex20_v0__22_13}" != 0 ]; then
            split__5_v0 "${param_348}" "="
            result_358=("${ret_split5_v0[@]}")
            start_path_345="${result_358[1]}"
        elif [ "$(( ${ret_match_regex20_v0__26_13} || ${ret_match_regex20_v0__26_43} ))" != 0 ]; then
            show_hidden_346=1
        elif [ "${ret_match_regex20_v0__29_13}" != 0 ]; then
            split__5_v0 "${param_348}" "="
            result_359=("${ret_split5_v0[@]}")
            parse_int__14_v0 "${result_359[1]}"
            __status=$?
            if [ "${__status}" != 0 ]; then
                eprintf_colored__1632_v0 "ERROR: Invalid page-size value: ""${result_359[1]}""
" 31
                exit 1
            fi
            page_size_347="${ret_parse_int14_v0}"
        else
            # Treat as start path if not a flag
            start_path_345="${param_348}"
        fi
    done
    xyl_file__1907_v0 "${start_path_345}" "${cursor_344}" "${show_hidden_346}" "${page_size_347}"
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
        array_424=("")
        eprintf__212_v0 "bc is not installed. Please install bc to use xylitol.
" array_424[@]
        array_425=("")
        eprintf__212_v0 "  For Debian/Ubuntu: sudo apt install bc
" array_425[@]
        array_426=("")
        eprintf__212_v0 "  For Fedora: sudo dnf install bc
" array_426[@]
        array_427=("")
        eprintf__212_v0 "  For Arch Linux: sudo pacman -S bc
" array_427[@]
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
__length_429=("${args_59[@]}")
if [ "$(( $(( $(( $(( ${#__length_429[@]} < 2 )) || $([ "_${args_59[1]}" != "_help" ]; echo $?) )) || $([ "_${args_59[1]}" != "_--help" ]; echo $?) )) || $([ "_${args_59[1]}" != "_-h" ]; echo $?) ))" != 0 ]; then
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
    result_343="${ret_execute_confirm1452_v0}"
    if [ "$([ "_${result_343}" != "_yes" ]; echo $?)" != 0 ]; then
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
    array_430=("")
    printf__106_v0 "${ret_colored_primary194_v0__55_20}" array_430[@]
    array_431=("")
    printf__106_v0 " version: " array_431[@]
    colored_accent__196_v0 "${__VERSION_57}"
    ret_colored_accent196_v0__57_20="${ret_colored_accent196_v0}"
    array_432=("")
    printf__106_v0 "${ret_colored_accent196_v0__57_20}" array_432[@]
    echo ""
    printf_colored__211_v0 "written in Amber: " 90
    printf_colored__211_v0 "  ""${__AMBER_VERSION_58}" 90
else
    print_help__358_v0 
    printf_colored__211_v0 "ERROR: Unknown command '""${args_59[1]}""'" 91
fi
