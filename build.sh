#!/bin/bash
set -e

emerge-webrsync
emerge --quiet app-eselect/eselect-repository
eselect repository enable guru
eselect repository enable zugaina
emaint sync -r guru
emaint sync -r zugaina

# Настройки make.conf
echo 'COMMON_FLAGS="-O2 -pipe"' > /etc/portage/make.conf
echo 'CFLAGS="${COMMON_FLAGS}"' >> /etc/portage/make.conf
echo 'CXXFLAGS="${COMMON_FLAGS}"' >> /etc/portage/make.conf
echo 'MAKEOPTS="-j2"' >> /etc/portage/make.conf
echo 'BINPKG_FORMAT="xpak"' >> /etc/portage/make.conf
echo 'FEATURES="buildpkg"' >> /etc/portage/make.conf
echo 'ACCEPT_LICENSE="*"' >> /etc/portage/make.conf

mkdir -p /etc/portage/package.accept_keywords
echo "gui-wm/swayfx ~amd64" >> /etc/portage/package.accept_keywords/build
echo "gui-libs/wlroots ~amd64" >> /etc/portage/package.accept_keywords/build
echo "gui-apps/ags ~amd64" >> /etc/portage/package.accept_keywords/build
echo "dev-libs/gjs ~amd64" >> /etc/portage/package.accept_keywords/build

mkdir -p /etc/portage/package.use
echo "*/* wayland" >> /etc/portage/package.use/build
echo "gui-libs/wlroots x11-backend" >> /etc/portage/package.use/build

# Сборка
emerge --verbose gui-wm/swayfx gui-apps/ags
