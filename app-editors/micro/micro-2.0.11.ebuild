# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGO_SUM=(
)

go-module_set_globals

SRC_URI="https://github.com/zyedidia/micro/tarball/225927b9a25f0d50ea63ea18bc7bb68e404c0cfd -> micro-2.0.11-225927b.tar.gz"

DESCRIPTION="A modern and intuitive terminal-based text editor"
HOMEPAGE="https://micro-editor.github.io https://github.com/zyedidia/micro"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="wayland"

RDEPEND="|| (
	!wayland? (
		x11-misc/xsel
		x11-misc/xclip
	)
	wayland? ( gui-apps/wl-clipboard )
)"

post_src_unpack() {
	mv ${WORKDIR}/zyedidia-* ${S} || die
}

src_compile() {
	go build -mod=mod ./cmd/micro || die "compile failed"
}

src_install() {
	dobin ${PN}
	dodoc README.md
}