# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A complete text editor for your terminal"
HOMEPAGE="https://github.com/jmacdonald/amp"
SRC_URI="https://github.com/jmacdonald/amp/tarball/c5ac4d2e659844f54c47998317dfc8041b45c386 -> amp-0.6.2-c5ac4d2.tar.gz
https://direct.funtoo.org/e4/6a/e2/e46ae2dacd1bd6cd18628086292818064379a90f70515d4db340badaae4232267793cbf1c95d8e90535e5516b89d79e31fa25a8154984f7cfb3034ef1676cc5b -> amp-0.6.2-funtoo-crates-bundle-9353a5b47bc891623783f3a0433a9a798ddf84c26a1a71860a45982f8c567d2e9d989a5804de80e53807db54e15238932ce5fb7ce88f03a0d92e0ae2f517de98.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
IUSE="X"

BDEPEND="
	virtual/rust
	dev-util/cmake
"

RDEPEND="
	dev-vcs/git
	X? ( x11-libs/libxcb )
	dev-libs/openssl
	sys-libs/zlib
"

post_src_unpack() {
	mv ${WORKDIR}/jmacdonald-amp-*/* ${S} || die
}

src_install() {
	cargo_src_install
	dodoc README.md
}