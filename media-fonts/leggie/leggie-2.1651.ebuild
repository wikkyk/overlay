# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit font

DESCRIPTION="A pretty, legible bitmap font with a wide selection of glyphs"
HOMEPAGE="https://wiktorb.eu/leggie/"
SRC_URI="https://github.com/wiktor-b/${PN}/archive/${PV}.tar.gz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="dotted-zero +psf"

DEPEND="
	dotted-zero? ( sys-devel/patch )
	psf? ( app-arch/gzip app-text/bdf2psf )
"
RDEPEND=""

DOCS="README LICENSE"

src_compile() {
	if use dotted-zero; then
		eapply "${S}/patches/dotted-zero.patch"
	fi
	if use psf; then
		emake psf
	fi
}

src_install() {
	emake BDFDEST="${D}/usr/share/fonts" installbdf
	if use psf; then
		emake PSFDEST="${D}/usr/share/consolefonts" installpsf
	fi
}
