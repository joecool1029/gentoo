# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
KFMIN=6.10.0
QTMIN=6.8.1
inherit ecm plasma.kde.org xdg

DESCRIPTION="Backend implementation for xdg-desktop-portal that is using Qt/KDE Frameworks"

LICENSE="LGPL-2+"
SLOT="6"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

# dev-qt/qtbase:= slot op: Uses Qt::GuiPrivate for qtx11extras_p.h
# dev-qt/qtbase:=[cups]: includes specifically the cups private header
# dev-qt/qtgui: QtXkbCommonSupport is provided by either IUSE libinput or X
COMMON_DEPEND="
	>=dev-libs/wayland-1.15
	>=dev-qt/qtbase-${QTMIN}:6=[cups,dbus,gui,wayland,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	|| (
		>=dev-qt/qtbase-${QTMIN}:6[libinput]
		>=dev-qt/qtbase-${QTMIN}:6[X]
	)
	>=kde-frameworks/kcoreaddons-${KFMIN}:6[dbus]
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kglobalaccel-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-plasma/kwayland-${KDE_CATV}:6
	>=kde-plasma/plasma-workspace-${KDE_CATV}:6
	x11-libs/libxkbcommon
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/plasma-wayland-protocols-1.16.0
	>=dev-libs/wayland-protocols-1.25
	>=dev-qt/qtbase-${QTMIN}:6[concurrent]
"
RDEPEND="${COMMON_DEPEND}
	kde-misc/kio-fuse:6
	sys-apps/xdg-desktop-portal
"
RDEPEND+=" || ( >=dev-qt/qtbase-6.10:6[wayland] <dev-qt/qtwayland-6.10:6 )"
BDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[wayland]
	virtual/pkgconfig
"
BDEPEND+=" || ( >=dev-qt/qtbase-6.10:6[wayland] <dev-qt/qtwayland-6.10:6 )"

CMAKE_SKIP_TESTS=(
	# bugs: 926483, wants dbus/X11
	colorschemetest
)

PATCHES=( "${FILESDIR}"/${PN}-6.3.5-screencast-crash.patch ) # bug 957100
