# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..14} )

inherit flag-o-matic gnome.org meson python-any-r1 vala xdg

DESCRIPTION="Library providing a virtual terminal emulator widget"
HOMEPAGE="https://gitlab.gnome.org/GNOME/vte"

# Once SIXEL support ships (0.66 or later), might need xterm license (but code might be considered upgraded to LGPL-3+)
LICENSE="LGPL-3+ GPL-3+"

SLOT="2.91"      # vte_api_version in meson.build
KEYWORDS="amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv sparc x86"
IUSE="+crypt debug gtk-doc +icu +introspection systemd +vala"
REQUIRED_USE="
	gtk-doc? ( introspection )
	vala? ( introspection )
"

DEPEND="
	>=x11-libs/gtk+-3.24.22:3[introspection?]
	>=x11-libs/cairo-1.0
	>=dev-libs/fribidi-1.0.0
	>=dev-libs/glib-2.72:2
	crypt?  ( >=net-libs/gnutls-3.2.7:0= )
	icu? ( dev-libs/icu:= )
	>=x11-libs/pango-1.22.0
	>=dev-libs/libpcre2-10.21:=
	systemd? ( >=sys-apps/systemd-220:= )
	>=app-arch/lz4-1.9
	introspection? ( >=dev-libs/gobject-introspection-1.56:= )
	x11-libs/pango[introspection?]
"
RDEPEND="${DEPEND}
	~gui-libs/vte-common-${PV}[systemd?]
"
BDEPEND="
	${PYTHON_DEPS}
	dev-libs/libxml2:2
	dev-util/glib-utils
	gtk-doc? ( dev-util/gi-docgen )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

src_prepare() {
	default
	use vala && vala_setup
	xdg_environment_reset

	use elibc_musl && eapply "${FILESDIR}"/${PN}-0.66.2-musl-W_EXITCODE.patch

	# -Ddebug option enables various debug support via VTE_DEBUG, but also ggdb3; strip the latter
	sed -e '/ggdb3/d' -i meson.build || die
	sed -i 's/vte_gettext_domain = vte_api_name/vte_gettext_domain = vte_gtk3_api_name/' meson.build || die
}

src_configure() {
	# Upstream don't support LTO & error out on it in meson.build
	filter-lto

	local emesonargs=(
		-Da11y=true
		$(meson_use debug)
		$(meson_use gtk-doc docs)
		$(meson_use introspection gir)
		-Dfribidi=true # pulled in by pango anyhow
		-Dglade=true
		$(meson_use crypt gnutls)
		-Dgtk3=true
		-Dgtk4=false
		$(meson_use icu)
		$(meson_use systemd _systemd)
		$(meson_use vala vapi)
	)
	meson_src_configure
}

src_install() {
	# not meson_src_install because this would include einstalldocs, which
	# would result in file collisions with gui-libs/vte
	meson_install

	# Remove files that are provided by gui-libs/vte-common
	rm "${ED}"/usr/libexec/vte-urlencode-cwd || die
	rm "${ED}"/etc/profile.d/vte.sh || die
	rm "${ED}"/etc/profile.d/vte.csh || die
	if use systemd; then
		rm "${ED}"/usr/lib/systemd/user/vte-spawn-.scope.d/defaults.conf || die
	fi
	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/ || die
		mv "${ED}"/usr/share/doc/vte-${SLOT} "${ED}"/usr/share/gtk-doc/vte-${SLOT}-gtk3 || die
	fi
}
