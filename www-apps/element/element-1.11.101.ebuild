# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp

DESCRIPTION="A glossy Matrix collaboration client for the web"
HOMEPAGE="https://element.io/"
SRC_URI="https://github.com/element-hq/element-web/releases/download/v${PV}/${PN}-v${PV}.tar.gz"
S=${WORKDIR}/${PN}-v${PV}

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~riscv ~x86"

need_httpd

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	dodir "${MY_HTDOCSDIR}"/home
	dodir "${MY_HTDOCSDIR}"/sites

	webapp_serverowned "${MY_HTDOCSDIR}"/home
	webapp_serverowned "${MY_HTDOCSDIR}"/sites
	#webapp_configfile "${MY_HTDOCSDIR}"/config.json

	webapp_src_install
}
