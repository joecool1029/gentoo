# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Low-level CFFI bindings for the Argon2 password hashing library"
HOMEPAGE="
	https://github.com/hynek/argon2-cffi-bindings/
	https://pypi.org/project/argon2-cffi-bindings/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="cpu_flags_x86_sse2"

DEPEND="
	app-crypt/argon2:=
"
BDEPEND="
	>=dev-python/setuptools-scm-6.2[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/cffi[${PYTHON_USEDEP}]
	' 'python*')
"
RDEPEND="
	${DEPEND}
	$(python_gen_cond_dep '
		dev-python/cffi[${PYTHON_USEDEP}]
	' 'python*')
"

DOCS=( CHANGELOG.md README.md )

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_configure() {
	export ARGON2_CFFI_USE_SYSTEM=1
	# We cannot call usex in global scope, so we invoke it in src_configure
	export ARGON2_CFFI_USE_SSE2=$(usex cpu_flags_x86_sse2 1 0)
	distutils-r1_src_configure
}
