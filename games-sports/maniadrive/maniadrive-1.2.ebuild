# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit eutils 

SRC="ManiaDrive-${PV}-src"
# we keep the old binary package because there is no change in data
# MAIN="ManiaDrive-${PV}-linux-i386"
MAIN="ManiaDrive-1.2-linux-i386"
#ODE="ode.tar.gz"
#PHP="php5.2-latest.tar.gz"

DESCRIPTION="ManiaDrive is a clone of Trackmania: 3D, stunts and skills!"
HOMEPAGE="http://maniadrive.raydium.org/"
SRC_URI="mirror://sourceforge/${PN}/${MAIN}.tar.gz
	mirror://sourceforge/${PN}/${SRC}.tar.gz"
	#http://freeway.raydium.org/data/stable_mirrors/${ODE}
	#http://snaps.php.net/${PHP}"

LICENSE="CCPL-Attribution-2.0
	GPL-2"
SLOT="0"
KEYWORDS="~x86 amd64"
IUSE=""

DEPEND="media-libs/openal
	virtual/glu
	virtual/jpeg
	media-libs/libvorbis
	media-libs/glew
	dev-games/ode"

S=${WORKDIR}/${SRC}
RAY=${S}/raydium
dir=${DATADIR}/${PN}

src_unpack() {
	unpack "${MAIN}.tar.gz"
	unpack "${SRC}.tar.gz"

	# Delete binary files
	rm "${WORKDIR}/${MAIN}"/game/*.static

	# Copy game data in build directory
	cp -r "${WORKDIR}/${MAIN}"/game/* "${S}" || die

	cd "${S}"
	epatch "${FILESDIR}/${PN}-1.2-no-download.patch"
	epatch "${FILESDIR}/${PN}-1.2-ocomp-fix.patch"
	epatch "${FILESDIR}/${PN}-1.2-remove-openal-test.patch"

	# Change version to allow to send scores
	sed -i "s/ManiaDrive ${PV}custom/ManiaDrive ${PV}/" mania_drive.c \
		|| die 'sed failed'
}

src_compile() {
	addwrite /dev/nvidiactl
	addwrite /dev/nvidia0

	econf --no-download || die "econf failed"
	emake || die "emake failed"

	# The Makefile compiles only the engine (raydium).
	# We can compile the game binaries with the ocomp script
	# (static using ode).
	local f
	for f in mania{_drive,_server,2}.c ; do
		./ocomp.sh "${f}" || die "ocomp.sh ${f} failed"
	done
}

src_install() {
	local f
	for f in mania{_drive,_server,2} ; do
		dobin "${S}/${f}" "${f}.bin" \
			|| die "newgamesbin ${f} failed"
	#	games_make_wrapper "${f}" "${f}.bin" "${dir}"
	done

	insinto "${dir}"
	doins -r "${WORKDIR}/${MAIN}"/game/*

	dodoc "${WORKDIR}/${MAIN}"/README
}
