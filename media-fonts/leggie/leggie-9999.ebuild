# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit git-r3 font

DESCRIPTION="A pretty, legible bitmap font with a wide selection of glyphs"
HOMEPAGE="https://wiktorb.eu/leggie/"
EGIT_REPO_URI="https://github.com/wiktor-b/leggie.git"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS=""
IUSE="dotted-zero l10n_sr l10n_mk +psf"

DEPEND="psf? ( app-arch/gzip app-text/bdf2psf )"
RDEPEND=""

DOCS="README LICENSE"

src_compile() {
	use dotted-zero && eapply "${S}/patches/dotted-zero.patch"
	use l10n_sr || use l10n_mk && eapply "${S}/patches/serbian.patch"
	use psf && emake psf
}

src_install() {
	use X && emake BDFDEST="${D}/usr/share/fonts" installbdf
	use psf && emake PSFDEST="${D}/usr/share/consolefonts" installpsf
}
