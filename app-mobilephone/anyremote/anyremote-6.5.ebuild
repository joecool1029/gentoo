# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Bluetooth, infrared or cable remote control service"
HOMEPAGE="http://anyremote.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="bluetooth dbus zeroconf"

RDEPEND="
	dev-libs/glib:2
	x11-libs/libX11
	x11-libs/libXtst
	bluetooth? ( net-wireless/bluez )
	dbus? (
		dev-libs/dbus-glib
		sys-apps/dbus
	)
	zeroconf? ( net-dns/avahi )
"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README )

src_configure() {
	econf \
		--docdir="/usr/share/doc/${PF}/" \
		$(use_enable bluetooth) \
		$(use_enable dbus) \
		$(use_enable zeroconf avahi)
}

src_install() {
	default
	mv "${ED}"/usr/share/doc/${PF}/{doc-html,html} || die
}
