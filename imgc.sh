#!/usr/bin/bash

declare -a filename=("$@")
declare -x desired_extension

modifyArgPosition() {
    if printf "%s" "${1}" | grep -Eq "\-o"; then
        shift 1    
        desired_extension=".${1}"
    else
        desired_extension=".jpg"
    fi
}

checkingSw() {
    if ! cmdChk="$(yum list installed ImageMagick 2> /dev/null)"; then
        printf "%s\n\n" "Software (ImageMagick) used for image processing is not istalled. We gonna install it."
        yum install ImageMagick -y 2> /dev/null
        printf "%60s\n" " " | tr ' ' '-'
        printf "%s\n" "${cmdChk}"
        printf "%60s\n" " " | tr ' ' '-'
    fi
}

main() {
    modifyArgPosition "$@"
    checkingSw
    printf "\n"

    for ((i=2;i<${#filename[@]};i++)); do
        extension="${filename[i]#*.}"
        output_name="${filename[i]%.*}"

        if [[ "${extension}" == "${desired_extension}" ]]; then
            printf "\n\e[1;31m%s\e[0m\n\n" "*Image is already in JPG format."
        else
            convert "${filename[i]}" "${output_name}.jpg"
            printf "\e[1;32m%s\e[0m\n\n" "*${filename[i]} converted to ${output_name}${desired_extension}"
        fi
    done
}

main "${filename[@]}"