# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

MY_P=textX-${PV}
DESCRIPTION="Meta-language for DSL implementation inspired by Xtext"
HOMEPAGE="
	https://pypi.org/project/textX/
	https://github.com/textX/textX/
"
SRC_URI="
	https://github.com/textX/textX/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/arpeggio-2.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/html5lib[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	cp -a "${BUILD_DIR}"/{install,test} || die
	local -x PATH=${BUILD_DIR}/test/usr/bin:${PATH}

	# Update the shebang
	sed -e "s:install/usr/bin/${EPYTHON}:test/usr/bin/${EPYTHON}:" \
		-i "${BUILD_DIR}"/test/usr/bin/textx || die

	# Install necessary plugins
	local plugins=(
		tests/functional/subcommands/example_project
		tests/functional/registration/projects/*
	)
	local p
	for p in "${plugins[@]}"; do
		pushd "${p}" >/dev/null || die
		distutils_pep517_install "${BUILD_DIR}"/test
		popd >/dev/null || die
	done

	epytest tests/functional
}
