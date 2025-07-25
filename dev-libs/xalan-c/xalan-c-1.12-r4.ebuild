# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN=${PN/-/_}
DESCRIPTION="XSLT processor for transforming XML into HTML, text, or other XML types"
HOMEPAGE="https://apache.github.io/xalan-c/"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/apache/xalan-c.git"

	SLOT="0"
else
	inherit verify-sig
	SRC_URI="
		mirror://apache/xalan/xalan-c/sources/${MY_PN}-${PV}.tar.gz
		https://archive.apache.org/dist/xalan/xalan-c/sources/${MY_PN}-${PV}.tar.gz
		verify-sig? (
			mirror://apache/xalan/xalan-c/sources/${MY_PN}-${PV}.tar.gz.asc
			https://archive.apache.org/dist/xalan/xalan-c/sources/${MY_PN}-${PV}.tar.gz.asc
		)
	"
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/apache-xalan-c.asc

	SLOT="0/$(ver_cut 1-2)"
	KEYWORDS="amd64 ~ppc x86"
	S="${WORKDIR}/${MY_PN}-${PV}"
	BDEPEND="
		verify-sig? ( sec-keys/openpgp-keys-apache-xalan-c )
	"
fi

LICENSE="Apache-2.0"
IUSE="doc"

RDEPEND="
	dev-libs/icu:=
	dev-libs/xerces-c:=[icu]
"
DEPEND="${RDEPEND}"
BDEPEND+="
	doc? ( app-text/doxygen[dot] )
"

PATCHES=(
	"${FILESDIR}"/${P}-fix-lto.patch
	"${FILESDIR}"/${P}-fix-threads.patch
	"${FILESDIR}"/${P}-icu-75.patch
	"${FILESDIR}"/${P}-gcc-15.patch
	"${FILESDIR}"/${P}-cmake-4.patch
)

src_configure() {
	local mycmakeargs=(
		-Ddoxygen=$(usex doc)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use doc; then
		docinto examples
		dodoc -r samples/*/
	fi
}
