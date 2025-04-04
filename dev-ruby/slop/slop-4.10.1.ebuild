# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="slop.gemspec"

inherit ruby-fakegem

DESCRIPTION="A simple option parser with an easy to remember syntax and friendly API"
HOMEPAGE="https://github.com/leejarvis/slop"
SRC_URI="https://github.com/leejarvis/${PN}/archive/v${PV}.tar.gz -> ${P}.tgz"

LICENSE="MIT"
SLOT="4"
KEYWORDS="~amd64 ~ppc64 ~x86"

IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/minitest )"

all_ruby_prepare() {
	sed -i -e '/git ls-files/d' slop.gemspec || die
}
