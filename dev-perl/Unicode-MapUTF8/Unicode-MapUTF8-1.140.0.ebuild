# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SNOWHARE
DIST_VERSION=1.14
inherit perl-module

DESCRIPTION="Conversions to and from arbitrary character sets and UTF8"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~mips ppc ppc64 ~s390 sparc x86"
LICENSE="MIT"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Jcode
	dev-perl/Unicode-Map
	dev-perl/Unicode-Map8
	dev-perl/Unicode-String
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
"

PERL_RM_FILES=("t/99_pod.t" "t/98_pod_coverage.t" "t/97_distribution.t")
