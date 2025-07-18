# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A post-modern modal text editor"
HOMEPAGE="https://github.com/helix-editor/helix"
SRC_URI="https://github.com/helix-editor/helix/tarball/fb192d0d0d97df989e9afa7485876251b96c58f4 -> helix-25.07-fb192d0.tar.gz
https://direct.funtoo.org/f5/c6/ee/f5c6eed5cf3cd41c44de277dd2215e3f8c9b8dbdfa2daa81e32463abec2952a838649a3705dca7971116baf49322a3b91505dc1cb87e47056e2eec1dc293cec6 -> helix-25.07-funtoo-crates-bundle-0d3c6efae77f63ccb6e04c5e189551e8126c8043d8ed0b3d92f549c53c158fa22d7d25820752e4e709eb8e91654abf26262e34c09ffce1cf441615fdf0755e43.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="doc"

S="${WORKDIR}/helix-editor-helix-fb192d0"

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