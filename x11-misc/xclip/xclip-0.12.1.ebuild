# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools git-r3

DESCRIPTION="Command-line utility to read data from standard in and place it in an X selection"
EGIT_REPO_URI="https://github.com/astrand/xclip"
EGIT_COMMIT="0a1bbcc10d1a17969587d5995e4d47ca543a129c"


LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXmu"
DEPEND="${RDEPEND}
	x11-libs/libXt"

src_configure() {
	eautoreconf
	econf
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc ChangeLog README
}
