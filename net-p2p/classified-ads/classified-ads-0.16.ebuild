# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils virtualx xdg

DESCRIPTION="Program for displaying classified advertisement items"
HOMEPAGE="http://katiska.org/classified-ads/"
SRC_URI="https://github.com/operatornormal/classified-ads/archive/${PV}.tar.gz
	-> classified-ads-${PV}.tar.gz
	https://github.com/operatornormal/classified-ads/blob/graphics/preprocessed.tar.gz?raw=true
	-> classified-ads-graphics-${PV}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="app-arch/bzip2
	dev-lang/tcl:=
	dev-lang/tk:=
	dev-libs/openssl:0=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5[widgets]
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtprintsupport:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtwidgets:5
	media-libs/opus
	net-libs/libnatpmp
	net-libs/miniupnpc:=
	sys-apps/file
	sys-libs/zlib
	virtual/libintl"

DEPEND="${RDEPEND}
	test? ( dev-libs/libgcrypt:0
		dev-qt/qttest:5
		dev-debug/gdb:0 )"

BDEPEND="sys-devel/gettext
	doc? ( app-text/doxygen )"

PATCHES=( "${FILESDIR}/${P}-miniupnpc-2.2.8.patch" ) # bug 934332, git master

src_prepare() {
	# preprocessed graphics are unpacked into wrong directory
	# so lets move them into correct location:
	mv ../ui/* ui/ || die
	default
}

src_configure() {
	eqmake5 examplefiles.path=/usr/share/doc/${PF}/examples
	if use test; then
		cd testca || die
		eqmake5
	fi
}

src_compile() {
	emake
	if use doc; then
		pushd doc > /dev/null || die
		doxygen || die
		popd > /dev/null || die
	fi
	if use test; then
		emake -C testca
	fi
}

src_test() {
	# testca will return 0 if all unit tests pass
	virtx ./testca/testca || die
}

src_install() {
	docompress -x /usr/share/doc/
	emake install INSTALL_ROOT="${D}" DESTDIR="${D}"
	use doc && dodoc -r doc/doxygen.generated/html/.
}
