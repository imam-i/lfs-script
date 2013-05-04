#######################################
#local _name=$(echo ${PACMAN_LFS} | cut -d\; -f2)
#local _version=$(echo ${PACMAN_LFS} | cut -d\; -f3)
#local _url=$(echo ${PACMAN_LFS} | cut -d\; -f5 | sed -e s/_name/${_name}/g -e s/_version/${_version}/g)

pushd ${BUILD_DIR}
unarch || return 1
cd ./${PACK}

./configure --prefix=/tools --with-libcurl=/tools || return 1
make || return 1
#make -C "./" check || return 1
make install || return 1
# Настройка makepkg.conf
sed -e "s/\/usr\/bin\/curl/\/tools\/bin\/curl/g" -i /tools/etc/makepkg.conf
sed -e 's/{man,info}/man/g' -i /tools/etc/makepkg.conf
sed -e 's/{doc,gtk-doc}/{doc,gtk-doc,info}/g' -i /tools/etc/makepkg.conf
sed -e 's/OPTIONS=(strip docs libtool emptydirs zipman purge !upx)/OPTIONS=(strip !docs libtool emptydirs zipman purge !upx)/g' \
    -i /tools/etc/makepkg.conf
#sed -e 's@/bin/du@/du@g' \
#    -i /tools/bin/makepkg
popd

#######################################
