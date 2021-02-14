# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Matrix group messaging app"
HOMEPAGE="https://wiki.gnome.org/Apps/Fractal"

inherit meson xdg-utils cargo

SRC_URI="https://gitlab.gnome.org/GNOME/fractal/uploads/ad6a483327c3e9ef5bb926b89fb26e2b/fractal-4.0.0.tar.xz
"
#	$(cargo_crate_uris ${CRATES})
#	${CARGO_DEPS[@]}
#"

KEYWORDS="~amd64 ~x86"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	>=app-text/gspell-1.8.1
	>=x11-libs/cairo-1.16.0
	x11-libs/gtksourceview
	dev-libs/libhandy"
	#>=virtual/rust-1.31.1
DEPEND="${RDEPEND}"
BDEPEND="dev-util/ninja
	dev-util/meson"


src_test() {
	cargo test || die "tests failed"
}
