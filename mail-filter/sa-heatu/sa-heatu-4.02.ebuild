# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

DESCRIPTION="Heuristic Email Address Tracker Utility for SpamAssassin"
HOMEPAGE="https://github.com/truxoft/sa-heatu"
SRC_URI="https://api.github.com/repos/truxoft/sa-heatu/tarball/170f1e503f36b7d81db5f65febd615d03e900089 -> ${P}.tar.gz"
S="${WORKDIR}/truxoft-${PN}-170f1e5"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="mail-filter/spamassassin"
RDEPEND="${DEPEND}"

src_install() {
	exeinto /usr/bin
	doexe sa-heatu
}

