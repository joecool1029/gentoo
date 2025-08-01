# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_PN=${PN%-*}
MY_P=${MY_PN}-${PV}
DESCRIPTION="Jolly Good Neo Geo AES/MVS Emulator"
HOMEPAGE="https://gitlab.com/jgemu/geolith"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/jgemu/${MY_PN}.git"
else
	SRC_URI="https://gitlab.com/jgemu/${MY_PN}/-/archive/${PV}/${MY_P}.tar.bz2"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
fi

LICENSE="BSD MIT"
SLOT="1"

DEPEND="
	dev-libs/miniz:=
	media-libs/jg:1=
	media-libs/speexdsp
"
RDEPEND="
	${DEPEND}
	games-emulation/jgrf
"
BDEPEND="
	virtual/pkgconfig
"

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		PKG_CONFIG="$(tc-getPKG_CONFIG)" \
		USE_EXTERNAL_MINIZ=1
}

src_install() {
	emake install \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}"/usr \
		DOCDIR="${EPREFIX}"/usr/share/doc/${PF} \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		USE_EXTERNAL_MINIZ=1
}
