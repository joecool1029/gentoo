# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1

DESCRIPTION="Pagination support for flask"
HOMEPAGE="
	https://flask-paginate.readthedocs.io/
	https://github.com/lixxu/flask-paginate/
	https://pypi.org/project/flask-paginate/
"
SRC_URI="
	https://github.com/lixxu/flask-paginate/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/flask[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	epytest tests/tests.py
}
