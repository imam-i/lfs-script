#######################################
#local _name=$(echo ${GAWK_LFS} | cut -d\; -f2)
#local _version=$(echo ${GAWK_LFS} | cut -d\; -f3)

pushd ${BUILD_DIR}
unarch || return ${?}
cd ./${PACK}

#unset MAKEFLAGS
./configure --prefix=/tools || return ${?}
make || return ${?}
make check || return ${?}
make install || return ${?}
#if [ ${J2_LFS_FLAG} -ne 0 ]; then
#	export MAKEFLAGS='-j 2'
#fi
popd

#######################################
