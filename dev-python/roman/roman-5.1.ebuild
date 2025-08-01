# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="An Integer to Roman numerals converter"
HOMEPAGE="
	https://pypi.org/project/roman/
	https://github.com/zopefoundation/roman
"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

distutils_enable_tests unittest

python_test() {
	eunittest -s src
}
