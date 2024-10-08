# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=VIPUL
DIST_VERSION=1.4
inherit perl-module

DESCRIPTION="Convert binary octets into ASCII armoured messages"

SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~mips ~ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="virtual/perl-IO-Compress
	virtual/perl-Digest-MD5
	virtual/perl-MIME-Base64"
BDEPEND="${RDEPEND}"
