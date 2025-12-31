# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGO_SUM=(
	"github.com/blang/semver v3.5.1+incompatible"
	"github.com/blang/semver v3.5.1+incompatible/go.mod"
	"github.com/chzyer/logex v1.1.10/go.mod"
	"github.com/chzyer/readline v0.0.0-20180603132655-2972be24d48e/go.mod"
	"github.com/chzyer/test v0.0.0-20180213035817-a1ea475d72b1/go.mod"
	"github.com/creack/pty v1.1.18"
	"github.com/creack/pty v1.1.18/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/dustin/go-humanize v1.0.0"
	"github.com/dustin/go-humanize v1.0.0/go.mod"
	"github.com/gdamore/encoding v1.0.0"
	"github.com/gdamore/encoding v1.0.0/go.mod"
	"github.com/go-errors/errors v1.0.1"
	"github.com/go-errors/errors v1.0.1/go.mod"
	"github.com/kr/pretty v0.1.0"
	"github.com/kr/pretty v0.1.0/go.mod"
	"github.com/kr/pty v1.1.1/go.mod"
	"github.com/kr/text v0.1.0"
	"github.com/kr/text v0.1.0/go.mod"
	"github.com/kylelemons/godebug v1.1.0"
	"github.com/layeh/gopher-luar v1.0.11"
	"github.com/layeh/gopher-luar v1.0.11/go.mod"
	"github.com/lucasb-eyer/go-colorful v1.0.3"
	"github.com/lucasb-eyer/go-colorful v1.0.3/go.mod"
	"github.com/mattn/go-isatty v0.0.20"
	"github.com/mattn/go-isatty v0.0.20/go.mod"
	"github.com/mattn/go-runewidth v0.0.16"
	"github.com/mattn/go-runewidth v0.0.16/go.mod"
	"github.com/micro-editor/go-shellquote v0.0.0-20250101105543-feb6c39314f5"
	"github.com/micro-editor/go-shellquote v0.0.0-20250101105543-feb6c39314f5/go.mod"
	"github.com/micro-editor/json5 v1.0.1-micro"
	"github.com/micro-editor/json5 v1.0.1-micro/go.mod"
	"github.com/micro-editor/tcell/v2 v2.0.13"
	"github.com/micro-editor/tcell/v2 v2.0.13/go.mod"
	"github.com/micro-editor/terminal v0.0.0-20250324214352-e587e959c6b5"
	"github.com/micro-editor/terminal v0.0.0-20250324214352-e587e959c6b5/go.mod"
	"github.com/mitchellh/go-homedir v1.1.0"
	"github.com/mitchellh/go-homedir v1.1.0/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/rivo/uniseg v0.2.0"
	"github.com/rivo/uniseg v0.2.0/go.mod"
	"github.com/robertkrimen/otto v0.2.1"
	"github.com/sergi/go-diff v1.1.0"
	"github.com/sergi/go-diff v1.1.0/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.4.0"
	"github.com/stretchr/testify v1.4.0/go.mod"
	"github.com/yuin/gopher-lua v0.0.0-20190206043414-8bfc7677f583/go.mod"
	"github.com/yuin/gopher-lua v1.1.1"
	"github.com/yuin/gopher-lua v1.1.1/go.mod"
	"github.com/zyedidia/clipper v0.1.1"
	"github.com/zyedidia/clipper v0.1.1/go.mod"
	"github.com/zyedidia/glob v0.0.0-20170209203856-dd4023a66dc3"
	"github.com/zyedidia/glob v0.0.0-20170209203856-dd4023a66dc3/go.mod"
	"github.com/zyedidia/poller v1.0.1"
	"github.com/zyedidia/poller v1.0.1/go.mod"
	"golang.org/x/sys v0.0.0-20190204203706-41f3e6584952/go.mod"
	"golang.org/x/sys v0.6.0/go.mod"
	"golang.org/x/sys v0.30.0"
	"golang.org/x/sys v0.30.0/go.mod"
	"golang.org/x/term v0.29.0"
	"golang.org/x/term v0.29.0/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/text v0.4.0"
	"golang.org/x/text v0.4.0/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/check.v1 v1.0.0-20190902080502-41f04d3bba15"
	"gopkg.in/check.v1 v1.0.0-20190902080502-41f04d3bba15/go.mod"
	"gopkg.in/sourcemap.v1 v1.0.5"
	"gopkg.in/yaml.v2 v2.2.2/go.mod"
	"gopkg.in/yaml.v2 v2.2.4/go.mod"
	"gopkg.in/yaml.v2 v2.2.8"
	"gopkg.in/yaml.v2 v2.2.8/go.mod"
)

go-module_set_globals

SRC_URI="https://github.com/zyedidia/micro/tarball/6a62575bcfdf4965f187eedafceb3400316e612b -> micro-2.0.15-6a62575.tar.gz
https://direct.funtoo.org/bd/b7/9a/bdb79af1a1501343d4c7cfd99604cd1ecdd55e2c405f72fc6433d8ef51acfe9377039adbb6fe67f2661fedfb6d2cbb9af200bbc4c38a5d5632861632fff86ae4 -> micro-2.0.15-funtoo-go-bundle-824c44d4f5db94fc9988e1673c102c202bab9660a0844d5bf48415f0f031d5eb88a9958b25f14bcd81a34318f6bddbc138d4a8b31a685c7417310858922bccf6.tar.gz"

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