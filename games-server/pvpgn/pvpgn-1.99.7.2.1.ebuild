# Copyright 1999-2015 Gentoo Foundation
# Copyright 2019 Memleek
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils

DESCRIPTION="A gaming server for Battle.Net compatible clients"
HOMEPAGE="https://pvpgn.pro/"
SRC_URI="https://github.com/pvpgn/pvpgn-server/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-server-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bnetd d2cs d2dbs lua mysql postgres sqlite"

DEPEND="lua? ( dev-lang/lua:* )
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql:*[server] )
	sqlite? ( dev-db/sqlite )"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e 's/\-O3//g' CMakeLists.txt
	sed -i -e 's/\-march=native//g' CMakeLists.txt
	sed -i -e 's/\-mtune=native//g' CMakeLists.txt
	sed -i -e 's/\-pedantic//g' CMakeLists.txt
	sed -i -e 's/^\(subdirs.*\)man/\1/' CMakeLists.txt
	rm man/CMakeLists.txt

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWITH_BNETD="$(usex bnetd)"
		-DWITH_D2CS="$(usex d2cs)"
		-DWITH_D2DBS="$(usex d2dbs)"
		-DWITH_LUA="$(usex lua)"
		-DWITH_MYSQL="$(usex mysql)"
		-DWITH_SQLITE3="$(usex sqlite)"
		-DWITH_PGSQL="$(usex postgres)"
		-DCMAKE_INSTALL_PREFIX=""
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	dodoc README.md README.DEV CREDITS NEWS UPDATE version-history.txt
	dodoc docs/*
	doman man/*.1
	doman man/*.5

	for f in bnetd d2cs d2dbs ; do
		use ${f} || continue
		newinitd "${FILESDIR}/${PN}.rc" ${f}
		sed -i -e "s/NAME/${f}/g" "${D}/etc/init.d/${f}" || die
	done

	keepdir $(find "${D}/var/${PN}" -type d -printf "/var/${PN}/%P ")
}
