# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="A least recently used (LRU) cache for Python"
HOMEPAGE="
	https://github.com/jlhutch/pylru/
	https://pypi.org/project/pylru/
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

python_test() {
	"${EPYTHON}" test.py || die "tests failed under ${EPYTHON}"
}
