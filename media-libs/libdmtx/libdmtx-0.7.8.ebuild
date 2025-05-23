# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Barcode data matrix reading and writing library"
HOMEPAGE="https://libdmtx.sourceforge.net/"
SRC_URI="https://github.com/dmtx/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ppc ppc64 ~riscv x86"
IUSE=""

src_prepare() {
	#bug 663346
	sed -i -e "s/-ansi//" test/*/Makefile.am || die

	default
	eautoreconf
}

src_install() {
	default
	find "${ED}" -name '*.la' -exec rm -f {} + || die
}
