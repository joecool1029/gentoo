# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

inherit desktop python-any-r1 readme.gentoo-r1 toolchain-funcs xdg

DESCRIPTION="MSX emulator that aims for perfection"
HOMEPAGE="https://openmsx.org/"
SRC_URI="https://github.com/openMSX/openMSX/releases/download/RELEASE_${PV//./_}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+joystick"

RDEPEND="dev-lang/tcl:0=
	media-libs/alsa-lib
	media-libs/freetype:2
	media-libs/libogg
	media-libs/libpng:0=
	media-libs/libsdl2[joystick=,sound,video]
	media-libs/libtheora:=
	media-libs/libvorbis
	media-libs/sdl2-ttf
	>=media-libs/glew-1.3.2:0=
	sys-libs/zlib
	virtual/opengl"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}"

DOC_CONTENTS="If you want to if you want to emulate real MSX systems and not only the free C-BIOS machines, put the system ROMs in one of the following directories: ${EPREFIX}/usr/share/${PN}/systemroms or ~/.openMSX/share/systemroms"

PATCHES=(
	# Drop this after 20.0
	"${FILESDIR}"/${P}-template.patch
)

src_prepare() {
	default
	sed -i -e 's/-fsanitize=address//' build/flavour-unittest.mk || die
	sed -i -e '/SYMLINK/s:true:false:' build/custom.mk || die # Can't be overridden
	sed -i -e 's/GPL\.txt//' doc/node.mk || die

	# Build system only configured to use bundled version - but not from the
	# directory it's distributed in
	cp "${S}/Contrib/catch2/catch.hpp" "${S}/src/unittest" || die
}

my_emake() {
	emake \
		V=1 \
		CXX="$(tc-getCXX)" \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		LINK_FLAGS_PREFIX= \
		OPENMSX_STRIP=false \
		"${@}"
}

src_compile() {
	my_emake \
		INSTALL_SHARE_DIR="${EPREFIX}/usr/share/${PN}"
}

src_test() {
	# To get tests, we need to build with OPENMSX_FLAVOUR=unittest and then the
	# build is stored in a directory of the pattern
	# ${WORKDIR}/derived/*-unittest/. This is separate from the actual build,
	# stored in ${WORKDIR}/derived/*-opt. The unittest binary and the workdir
	# binary are in each of these directories under their `bin` directories.
	my_emake \
		OPENMSX_FLAVOUR=unittest

	# There will only ever be one *-unittest directory
	"${S}"/derived/*-unittest/bin/openmsx || die
}

src_install() {
	# To guarantee installing the proper binary in case tests were built,
	# specify the default OPENMSX_FLAVOUR
	my_emake \
		INSTALL_BINARY_DIR="${ED}/usr/bin" \
		INSTALL_SHARE_DIR="${ED}/usr/share/${PN}" \
		INSTALL_DOC_DIR="${ED}/usr/share/doc/${PF}" \
		OPENMSX_FLAVOUR=opt \
		install

	einstalldocs
	readme.gentoo_create_doc

	local i
	for i in 16 32 48 64 128 256 ; do
		newicon -s "${i}" "share/icons/openMSX-logo-${i}.png" "${PN}.png"
	done
	make_desktop_entry "${PN}" "openMSX"
}

pkg_postinst() {
	readme.gentoo_print_elog
	xdg_pkg_postinst
}
