#!/bin/bash
set -e

# Синхронизируем основное дерево
emerge-webrsync

# Ставим eselect-repository и подключаем GURU
emerge --quiet app-eselect/eselect-repository
eselect repository enable guru
emaint sync -r guru

# Настройки make.conf для твоего Ryzen и RX 570
echo 'COMMON_FLAGS="-O2 -pipe"' > /etc/portage/make.conf
echo 'CFLAGS="${COMMON_FLAGS}"' >> /etc/portage/make.conf
echo 'CXXFLAGS="${COMMON_FLAGS}"' >> /etc/portage/make.conf
echo 'MAKEOPTS="-j2"' >> /etc/portage/make.conf
echo 'BINPKG_FORMAT="xpak"' >> /etc/portage/make.conf
echo 'FEATURES="buildpkg"' >> /etc/portage/make.conf
echo 'ACCEPT_LICENSE="*"' >> /etc/portage/make.conf

# Разрешаем ключевые слова (пробуем оба варианта имени для AGS)
mkdir -p /etc/portage/package.accept_keywords
echo "gui-wm/swayfx ~amd64" >> /etc/portage/package.accept_keywords/build
echo "gui-libs/wlroots ~amd64" >> /etc/portage/package.accept_keywords/build
echo "gui-apps/ags ~amd64" >> /etc/portage/package.accept_keywords/build
echo "gui-apps/aylurs-gtk-shell ~amd64" >> /etc/portage/package.accept_keywords/build
echo "dev-libs/gjs ~amd64" >> /etc/portage/package.accept_keywords/build

# Настройка USE-флагов для Wayland и Material
mkdir -p /etc/portage/package.use
echo "*/* wayland" >> /etc/portage/package.use/build
echo "gui-libs/wlroots x11-backend" >> /etc/portage/package.use/build

# Пытаемся собрать всё из GURU. Если ags не найдется, пробуем полное имя.
emerge --verbose gui-wm/swayfx || exit 1
emerge --verbose gui-apps/aylurs-gtk-shell || emerge --verbose gui-apps/ags
