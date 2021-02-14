# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/teamspeak-client-bin/teamspeak-client-bin-3.0.13.1.ebuild,v 1.1 2013/11/09 18:44:21 tomwij Exp $

EAPI="5"

inherit eutils unpacker

DESCRIPTION="TeamSpeak Client - Voice Communication Software"
HOMEPAGE="http://www.teamspeak.com/"
LICENSE="teamspeak3"

SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror strip"
IUSE="alsa pulseaudio"

REQUIRED_USE="|| ( alsa pulseaudio )"

SRC_URI="amd64? ( http://ftp.4players.de/pub/hosted/ts3/releases/${PV}/TeamSpeak3-Client-linux_amd64-${PV/_/-}.run )
	x86? ( http://ftp.4players.de/pub/hosted/ts3/releases/${PV}/TeamSpeak3-Client-linux_x86-${PV/_/-}.run )"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5[accessibility]
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtwidgets:5
	dev-libs/quazip
	sys-libs/glibc
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )"

S="${WORKDIR}"

pkg_nofetch() {
	if use amd64 ; then
		einfo "Please download TeamSpeak3-Client-linux_amd64-${PV/_/-}.run"
	elif use x86 ; then
		einfo "Please download TeamSpeak3-Client-linux_x86-${PV/_/-}.run"
	fi
	einfo "from ${HOMEPAGE}?page=downloads and place this"
	einfo "file in ${DISTDIR}"
}

src_prepare() {
	# Remove the qt-libraries as they just cause trouble with the system's Qt, see bug #328807.
	rm libQt* || die "Couldn't remove bundled Qt libraries."
	rm -r accessible platforms sqldrivers qt.conf || die "Couldn't remove bundle Qt files."

	# Remove unwanted soundbackends.
	if ! use alsa ; then
		rm soundbackends/libalsa* || die
	fi

	if ! use pulseaudio ; then
		rm soundbackends/libpulseaudio* || die
	fi
}

src_install() {
	dodir /opt/teamspeak3-client
	insinto /opt/teamspeak3-client
	doins -r *

	if use amd64 ; then
		fperms +x /opt/teamspeak3-client/ts3client_linux_amd64
	elif use x86 ; then
		fperms +x /opt/teamspeak3-client/ts3client_linux_x86
	fi
	fperms +x /opt/teamspeak3-client/ts3client_runscript.sh

	dosym "/opt/teamspeak3-client/ts3client_runscript.sh" /usr/bin/ts3client

	make_desktop_entry ts3client TeamSpeak3 \
		"/opt/teamspeak3-client/pluginsdk/docs/client_html/images/logo.png" \
		Network
}
