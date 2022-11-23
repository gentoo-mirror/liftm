# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{4,5,6,7,8,9,10} )

inherit distutils-r1

DESCRIPTION="Sophisticated chroot/build/flash tool to develop and install postmarketOS."
HOMEPAGE="https://postmarketos.org/ https://pypi.org/project/pmbootstrap/"
SRC_URI="https://files.pythonhosted.org/packages/98/9e/9889ff2be682a6d35cd42b528998464c67ac03cf7cf7ce4ff9fb1041da1b/pmbootstrap-1.50.0.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RDEPEND="app-admin/sudo"
