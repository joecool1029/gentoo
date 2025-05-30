# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools flag-o-matic toolchain-funcs xdg

DESCRIPTION="Programs and library containing GTK widgets and C++ classes related to chemistry"
HOMEPAGE="https://gchemutils.nongnu.org/"
SRC_URI="
	https://download.savannah.gnu.org/releases/gchemutils/$(ver_cut 1-2)/${P/_p*}.tar.xz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p*}-${PV/*_p}.debian.tar.xz
"
S="${WORKDIR}/${P/_p*}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnumeric"

RDEPEND="
	>=dev-libs/glib-2.36.0:2
	>=dev-libs/libxml2-2.4.16:2=
	>=gnome-extra/libgsf-1.14.9:=
	media-libs/libglvnd[X]
	>=sci-chemistry/bodr-5
	>=sci-chemistry/chemical-mime-data-0.1.94
	>=sci-chemistry/openbabel-2.3.0:0=
	>=x11-libs/cairo-1.6.0
	>=x11-libs/gdk-pixbuf-2.22.0:2
	>=x11-libs/goffice-0.10.12:0.10
	x11-libs/gtk+:3[X]
	>=x11-libs/libX11-1.0.0
	x11-libs/pango
	gnumeric? ( >=app-office/gnumeric-1.12.42 )
"
DEPEND="${RDEPEND}
	virtual/glu"
BDEPEND="
	app-text/doxygen
	app-text/yelp-tools
	dev-util/glib-utils
	dev-util/intltool
	virtual/pkgconfig
"

src_prepare() {
	default

	if has_version '<sci-chemistry/openbabel-3'; then
		sed -i -e '/openbabel-v3/d' "${WORKDIR}"/debian/patches/series || die
	fi

	# Debian patches
	for p in $(<"${WORKDIR}"/debian/patches/series) ; do
		eapply -p1 "${WORKDIR}/debian/patches/${p}"
	done

	# From Fedora
	eapply "${FILESDIR}"/${PN}-fix_pointer_types.patch

	# Disable tests for manpages
	eapply "${FILESDIR}"/${PN}-disable_tests_man.patch

	sed -e "s:pkg-config:$(tc-getPKG_CONFIG):g" \
		-i configure.ac || die

	eautoreconf
}

src_configure() {
	# bug #790023
	append-cxxflags -std=c++14

	# lasem is not in the tree
	econf \
		--without-lasem \
		--disable-mozilla-plugin \
		--disable-update-databases
}

src_install() {
	default

	mv "${ED}"/usr/share/appdata "${ED}"/usr/share/metainfo || die
	rm -rf "${ED}"/usr/share/mimelnk/ || die

	find "${D}" -name '*.la' -type f -delete || die
}
