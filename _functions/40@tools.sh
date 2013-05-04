#!/bin/bash
################################################################################
# Функция "tools_lfs"
# Version: 0.1

tools_lfs ()
{
[ "${ERR_FLAG}" -gt 0 ] && return ${?}
color-echo "tools_lfs" ${YELLOW}

date > "${LFS_LOG}/tools_lfs.log"

# Основные каталоги и ссылки
install -dv "${LFS}/tools" ${LFS_SRC} || return ${?}
ln -sv "${LFS}/tools" / || return ${?}

# Очистка сборочной папки
rm -Rf ${BUILD_DIR} || return ${?}
install -dv ${LFS}${BUILD_DIR} ${BUILD_DIR}
mount --bind ${LFS}${BUILD_DIR} ${BUILD_DIR} || return ${?}

# Устанавливаем нужное окружение для сборки статической системы
set +h
umask 022
export LFS=/mnt/lfs
export LC_ALL=POSIX
export LFS_TGT=$(uname -m)-lfs-linux-gnu
export PATH=/tools/bin:/bin:/usr/bin

# lfs
export PS1="[\u@\h \W]\$"
export SHLVL=1
#++++++++++++++++
export HOME=/root
export TERM=xterm

unset CFLAGS CXXFLAGS CXX CPP LD_LIBRARY_PATH LD_PRELOAD
unset SHELL SSH_CLIENT SSH_TTY USER MC_TMPDIR MAIL EDITOR LANG HISTCONTROL MC_SID LOGNAME SSH_CONNECTION G_BROKEN_FILENAMES OLDPWD

if [ ${J2_LFS_FLAG} -gt 0 ]; then
	export MAKEFLAGS="-j ${J2_LFS_FLAG}"
fi

chmod -R a+wt ${LFS_SRC} || return ${?}

echo 'tools_lfs:' >> "${LFS_LOG}/tools_lfs.log"
echo '+++++++++++++++++++++++++++++++++++++++' >> "${LFS_LOG}/tools_lfs.log"
env >> "${LFS_LOG}/tools_lfs.log"
echo '+++++++++++++++++++++++++++++++++++++++' >> "${LFS_LOG}/tools_lfs.log"

# Каталог для хронения лог-файлов tools
local _LOG="${LFS_LOG}/tools"
install -d ${_LOG}

case ${TOOLS_LFS_FLAG} in
	3)	# 11
		scripts_tools '05.Constructing Cross-Compile Tools' || return ${?}	#-1
		scripts_tools 'pm.Pacman' || return ${?}		#1-
		;;
	2)	# 10
		scripts_tools 'pm.Pacman' '05.Constructing Cross-Compile Tools' || return ${?}	#1-
		;;
	1)	# -1
		scripts_tools '05.Constructing Cross-Compile Tools' || return ${?}		#-1
		;;
	0)	# 00
		if [ "${CHROOT_FLAG}" -gt 0 ] || [ "${SYSTEM_LFS_FLAG}" -gt 0 ] || [ "${BLFS_FLAG}" -gt 0 ]; then
			untar_lfs 'pm.Pacman' '05.Constructing Cross-Compile Tools' || return ${?}	#1-
		fi
		;;
	*) echo 'Не верный параметер константы "TOOLS_LFS_FLAG"' && return 1 ;;
esac

# Возврашяем PATH
export PATH=/bin:/sbin:/usr/bin:/usr/sbin

umount -v ${BUILD_DIR} || return ${?}
rm -Rf ${LFS}${BUILD_DIR} ${BUILD_DIR}

date >> "${LFS_LOG}/tools_lfs.log"
}

################################################################################
