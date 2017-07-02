# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils git-r3 savedconfig toolchain-funcs

DESCRIPTION="simple user privilege escalation"
HOMEPAGE="http://git.suckless.org/sup/"
EGIT_REPO_URI="http://git.suckless.org/sup"

LICENSE="freedist"
SLOT="0"
IUSE="savedconfig"

src_prepare() {
	default
	epatch "${FILESDIR}/modemask.patch"
	tc-export CC
	restore_config config.h
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install
	dodoc TODO
	save_config config.h
}
