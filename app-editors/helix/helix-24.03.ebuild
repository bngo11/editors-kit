# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A post-modern modal text editor"
HOMEPAGE="https://github.com/helix-editor/helix"
SRC_URI="https://github.com/helix-editor/helix/tarball/e027942d42d9ba17c612948785ca743a9e80488f -> helix-24.03-e027942.tar.gz
https://direct.funtoo.org/50/14/b1/5014b1419beb2f19a69e7b8212b4ab98ad17fc423529f442722cc214590c759d9ea6c684ee1ea69549fac4aaed56cfa581149522d9786a8dce7ee3317c53eb1b -> helix-24.03-funtoo-crates-bundle-3cc54e9d9f461ccce665ca94c388c68b82cbec462a3305223498251c3d39140c663100e8c8f65b633211212bdc426c3cf35b3a7bb10da69fdb1d9fac8a2d2f35.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="doc"

S="${WORKDIR}/helix-editor-helix-e027942"

src_compile() {
	export HELIX_DISABLE_AUTO_GRAMMAR_BUILD=1

	cargo_src_compile
}

src_install() {
	rm -rf ${S}/runtime/grammars/sources

	insinto /usr/share/helix
	doins -r runtime
 
	use doc && dodoc README.md CHANGELOG.md
	use doc && dodoc -r docs/

	cargo_src_install --path helix-term
}

pkg_postinst() {
	elog "You will need to copy /usr/share/helix/runtime into your \$HELIX_RUNTIME"
	elog "For syntax highlighting and other features. "
	elog ""
	elog "Run: "
	elog "cp -r /usr/share/helix/runtime ~/.config/helix/runtime"
	elog ""
	elog "To install tree-sitter grammars for helix run the following:"
	elog "hx -g fetch"
	elog "hx -g build"
}