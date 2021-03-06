#!/bin/bash
################################################################################
# Функция "packages_lfs"
# Version: 0.1

packages_lfs ()
{
local LFS_FLAG='packages-lfs'

if [ "${PACKAGES_LFS_FLAG}" -eq 0 ]; then
        return 0
fi

color-echo "packages_lfs" ${YELLOW}

local _log="${LFS_LOG}/packages.log"
:> ${_log}

for (( i=0; i <= ${#lfs_var_arr[@]} - 1; i++ ))
do
	pak="lfs_var_arr[${i}]"

	local ${!pak}

	# Проверка пакета на включение
	if [ "${status}" -eq 0 ] || [[ -z "${lfs}" && -n "${blfs}" ]]; then
		# Очистка переменных
		clear_per "${!pak}"
		# Продолжаем
		continue
	fi

	if [ -n "${url}" ] && [ "${url}" != 'NONE' ] ; then
		local url=$(echo ${url} | sed -e "s@_version@${version}@g")
		f_download
	fi
	unset url md5
	if [ -n "${urlconf}" ]; then
		local urlconf=$(echo ${urlconf} | sed -e "s@_version@${verconf}@g")
		f_download "${urlconf}" "${md5conf}"
	fi
	for (( n=1; n <= 9; n++ ))
	do
		local urlpatch="urlpatch${n}"
		if [ -n "${!urlpatch}" ]; then
			local _urlpatch=$(echo ${!urlpatch} | sed -e "s@_version@${version}@g")
			local md5patch="md5patch${n}"
			f_download "${_urlpatch}" "${!md5patch}"
		fi
	done

	# Очистка переменных
	clear_per "${!pak} pak"
done
}

################################################################################
