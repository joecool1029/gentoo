# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Image and video texturing library"
HOMEPAGE="https://github.com/coin3d/simage/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/coin3d/simage.git"
else
	SRC_URI="https://github.com/coin3d/simage/releases/download/v${PV}/${P}-src.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ppc ppc64 ~sparc x86"
	S="${WORKDIR}/${PN}"
fi

LICENSE="BSD-1"
SLOT="0"
IUSE="gif jpeg png qt6 sndfile test tiff vorbis zlib"
RESTRICT="!test? ( test )"

RDEPEND="
	gif? ( media-libs/giflib:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	png? ( media-libs/libpng:= )
	qt6? ( dev-qt/qtbase:6[gui] )
	sndfile? (
		media-libs/libsndfile
		media-libs/flac:=
	)
	tiff? (
		media-libs/tiff:=[lzma,zstd]
		app-arch/xz-utils
		app-arch/zstd:=
	)
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
		media-libs/opus
	)
	zlib? ( sys-libs/zlib:= )
"
DEPEND="${RDEPEND}"
BDEPEND="test? ( media-libs/libsndfile )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.8.1-0001-Gentoo-specific-remove-RELEASE-flag-from-pkg-config.patch
	"${FILESDIR}"/${P}-cmake4.patch # bug 952022
)

DOCS=( AUTHORS ChangeLog NEWS README )

src_configure() {
	local mycmakeargs=(
		-DSIMAGE_BUILD_SHARED_LIBS=ON
		-DSIMAGE_BUILD_EXAMPLES=OFF
		-DSIMAGE_BUILD_TESTS=$(usex test)
		-DSIMAGE_BUILD_DOCUMENTATION=OFF
		-DSIMAGE_USE_AVIENC=OFF # Windows only
		-DSIMAGE_USE_GDIPLUS=OFF # Windows
		-DSIMAGE_USE_CGIMAGE=OFF # OS X only
		-DSIMAGE_USE_QUICKTIME=OFF # OS X only
		-DSIMAGE_USE_QIMAGE=$(usex qt6)
		-DSIMAGE_USE_QT5=OFF
		-DSIMAGE_USE_QT6=$(usex qt6)
		-DSIMAGE_USE_CPACK=OFF
		-DSIMAGE_USE_STATIC_LIBS=OFF
		-DSIMAGE_LIBJASPER_SUPPORT=OFF
		-DSIMAGE_LIBSNDFILE_SUPPORT=$(usex sndfile)
		-DSIMAGE_OGGVORBIS_SUPPORT=$(usex vorbis)
		-DSIMAGE_EPS_SUPPORT=ON
		-DSIMAGE_MPEG2ENC_SUPPORT=ON
		-DSIMAGE_PIC_SUPPORT=ON
		-DSIMAGE_RGB_SUPPORT=ON
		-DSIMAGE_TGA_SUPPORT=ON
		-DSIMAGE_XWD_SUPPORT=ON
		-DSIMAGE_ZLIB_SUPPORT=$(usex zlib)
		-DSIMAGE_GIF_SUPPORT=$(usex gif)
		-DSIMAGE_JPEG_SUPPORT=$(usex jpeg)
		-DSIMAGE_PNG_SUPPORT=$(usex png)
		-DSIMAGE_TIFF_SUPPORT=$(usex tiff)
	)
	cmake_src_configure
}
