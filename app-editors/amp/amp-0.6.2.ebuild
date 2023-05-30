# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A complete text editor for your terminal"
HOMEPAGE="https://github.com/jmacdonald/amp"
SRC_URI="https://github.com/jmacdonald/amp/tarball/1485e4b25757df22f53af8109c39b6197c61de5a -> amp-0.6.2-1485e4b.tar.gz
https://direct.funtoo.org/0e/cb/f3/0ecbf3ecf47804a68502ca3b99907f2144dc4ff6ac56653586af296633bc9a57edf50447d57ef01c2b65a3cf365915f8e88d99ba62f7844508b5a3794c4b5149 -> amp-0.6.2-funtoo-crates-bundle-9353a5b47bc891623783f3a0433a9a798ddf84c26a1a71860a45982f8c567d2e9d989a5804de80e53807db54e15238932ce5fb7ce88f03a0d92e0ae2f517de98.tar.gz"

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