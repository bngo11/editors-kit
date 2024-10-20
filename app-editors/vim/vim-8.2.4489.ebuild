# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{6,7,8} )
inherit eutils vim-doc flag-o-matic fdo-mime versionator bash-completion-r1 python-r1
VIM_VERSION="$(get_version_component_range 1-2)"

SRC_URI="https://github.com/vim/vim/archive/v8.2.4489/v8.2.4489.tar.gz -> vim-8.2.4489.tar.gz"
KEYWORDS="*"

DESCRIPTION="Vim, an improved vi-style text editor"
HOMEPAGE="http://www.vim.org/ https://github.com/vim/vim"

SLOT="0"
LICENSE="vim"
IUSE="X acl cscope debug gpm lua luajit minimal nls perl python racket ruby selinux tcl vim-pager"
REQUIRED_USE="
	luajit? ( lua )
	python? (
	|| ( $(python_gen_useflags '*') )
	?? ( $(python_gen_useflags 'python2*') )
	?? ( $(python_gen_useflags 'python3*') )
	)
"

RDEPEND="
	>=app-eselect/eselect-vi-1.1
	>=sys-libs/ncurses-5.2-r2:0=
	nls? ( virtual/libintl )
	acl? ( kernel_linux? ( sys-apps/acl ) )
	cscope? ( dev-util/cscope )
	gpm? ( >=sys-libs/gpm-1.19.3 )
	lua? (
	luajit? ( dev-lang/luajit:2= )
		!luajit? ( dev-lang/lua:0[deprecated] )
	)
	!minimal? (
		~app-editors/vim-core-${PV}
		dev-util/ctags
	)
	perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS} )
	racket? ( dev-scheme/racket )
	ruby? ( dev-lang/ruby:= )
	selinux? ( sys-libs/libselinux )
	tcl? ( dev-lang/tcl:0= )
	X? ( x11-libs/libXt )
"
DEPEND="${RDEPEND}
	sys-devel/autoconf
	nls? ( sys-devel/gettext )
"

pkg_setup() {
	# people with broken alphabets run into trouble. bug 82186.
	unset LANG LC_ALL
	export LC_COLLATE="C"

	# Gnome sandbox silliness. bug #114475.
	mkdir -p "${T}"/home
	export HOME="${T}"/home
}

src_prepare() {
	epatch "${FILESDIR}/002_all_vim-7.3-apache-83565.patch"
	epatch "${FILESDIR}/004_all_vim-7.0-grub-splash-96155.patch"
	epatch "${FILESDIR}/005_all_vim_7.1-ada-default-compiler.patch"
	epatch "${FILESDIR}/006-vim-8.0-crosscompile.patch"

	# Fixup a script to use awk instead of nawk
	sed -i '1s|.*|#!'"${EPREFIX}"'/usr/bin/awk -f|' "${S}"/runtime/tools/mve.awk || die "mve.awk sed failed"

	# Read vimrc and gvimrc from /etc/vim
	echo '#define SYS_VIMRC_FILE "'${EPREFIX}'/etc/vim/vimrc"' >> "${S}"/src/feature.h
	echo '#define SYS_GVIMRC_FILE "'${EPREFIX}'/etc/vim/gvimrc"' >> "${S}"/src/feature.h

	# Use exuberant ctags which installs as /usr/bin/exuberant-ctags.
	# Hopefully this pattern won't break for a while at least.
	# This fixes bug 29398 (27 Sep 2003 agriffis)
	sed -i 's/\<ctags\("\| [-*.]\)/exuberant-&/g' \
	"${S}"/runtime/doc/syntax.txt \
	"${S}"/runtime/doc/tagsrch.txt \
	"${S}"/runtime/doc/usr_29.txt \
	"${S}"/runtime/menu.vim \
	"${S}"/src/configure.ac || die 'sed failed'

	# Don't be fooled by /usr/include/libc.h.  When found, vim thinks
	# this is NeXT, but it's actually just a file in dev-libs/9libs
	# This fixes bug 43885 (20 Mar 2004 agriffis)
	sed -i 's/ libc\.h / /' "${S}"/src/configure.ac || die 'sed failed'

	# gcc on sparc32 has this, uhm, interesting problem with detecting EOF
	# correctly. To avoid some really entertaining error messages about stuff
	# which isn't even in the source file being invalid, we'll do some trickery
	# to make the error never occur. bug 66162 (02 October 2004 ciaranm)
	find "${S}" -name '*.c' | while read c ; do echo >> "$c" ; done

	# conditionally make the manpager.sh script
	if use vim-pager ; then
		cat <<-END > "${S}"/runtime/macros/manpager.sh
			#!/bin/sh
			sed -e 's/\x1B\[[[:digit:]]\+m//g' | col -b | \\
					vim \\
						-c 'let no_plugin_maps = 1' \\
						-c 'set nolist nomod ft=man ts=8' \\
						-c 'let g:showmarks_enable=0' \\
						-c 'runtime! macros/less.vim' -
			END
	fi

	# Try to avoid sandbox problems. Bug #114475.
	if [[ -d "${S}"/src/po ]] ; then
		sed -i '/-S check.vim/s,..VIM.,ln -s $(VIM) testvim \; ./testvim -X,' \
		"${S}"/src/po/Makefile
	fi

	if version_is_at_least 7.3.122 ; then
		cp "${S}"/src/config.mk.dist "${S}"/src/auto/config.mk
	fi

	# Bug #378.17 - Build properly with >=perl-core/ExtUtils-ParseXS-3.20.0
	if version_is_at_least 7.3 ; then
		sed -i "s:\\\$(PERLLIB)/ExtUtils/xsubpp:${EPREFIX}/usr/bin/xsubpp:"	\
		"${S}"/src/Makefile || die 'sed for ExtUtils-ParseXS failed'
	fi

	eapply_user
}

src_configure() {
	local myconf=()

	# Fix bug 37354: Disallow -funroll-all-loops on amd64
	# Bug 57859 suggests that we want to do this for all archs
	filter-flags -funroll-all-loops

	# Fix bug 76331: -O3 causes problems, use -O2 instead. We'll do this for
	# everyone since previous flag filtering bugs have turned out to affect
	# multiple archs...
	replace-flags -O3 -O2

	# Fix bug 18245: Prevent "make" from the following chain:
	# (1) Notice configure.ac is newer than auto/configure
	# (2) Rebuild auto/configure
	# (3) Notice auto/configure is newer than auto/config.mk
	# (4) Run ./configure (with wrong args) to remake auto/config.mk
	sed -i 's# auto/config\.mk:#:#' src/Makefile || die "Makefile sed failed"
	rm -f src/auto/configure
	emake -j1 -C src autoconf

	# This should fix a sandbox violation (see bug 24447). The hvc
	# things are for ppc64, see bug 86433.
	for file in /dev/pty/s* /dev/console /dev/hvc/* /dev/hvc* ; do
		[[ -e ${file} ]] && addwrite $file
	done

	if use minimal ; then
		myconf=(
			--with-features=tiny
			--disable-nls
			--disable-multibyte
			--disable-acl
			--enable-gui=no
			--without-x
			--disable-darwin
			--disable-luainterp
			--disable-perlinterp
			--disable-pythoninterp
			--disable-mzschemeinterp
			--disable-rubyinterp
			--disable-selinux
			--disable-tclinterp
			--disable-gpm
		)
	else
		use debug && append-flags "-DDEBUG"

		myconf=(
			--with-features=huge
			--enable-multibyte
			$(use_enable acl)
			$(use_enable cscope)
			$(use_enable gpm)
			$(use_enable lua luainterp)
			$(usex lua "--with-lua-prefix=${EPREFIX}/usr" "")
			$(use_with luajit)
			$(use_enable nls)
			$(use_enable perl perlinterp)
			$(use_enable racket mzschemeinterp)
			$(use_enable ruby rubyinterp)
			$(use_enable selinux)
			$(use_enable tcl tclinterp)
		)

		if use python ; then
		py_add_interp() {
			local v
			[[ ${EPYTHON} == python3* ]] && v=3
			myconf+=(
				--enable-python${v}interp
				vi_cv_path_python${v}="${PYTHON}"
			)
		}

		   python_foreach_impl py_add_interp
		else
		myconf+=(
			--disable-pythoninterp
			--disable-python3interp
		)
		fi

		# --with-features=huge forces on cscope even if we --disable it. We need
		# to sed this out to avoid screwiness. (1 Sep 2004 ciaranm)
		if ! use cscope ; then
			sed -i '/# define FEAT_CSCOPE/d' src/feature.h || \
			die "couldn't disable cscope"
		fi

		# don't test USE=X here ... see bug #19115
		# but need to provide a way to link against X ... see bug #20093
		myconf+=(
			--enable-gui=no
			--disable-darwin
			$(use_with X x)
		)
	fi

	# let package manager strip binaries
	export ac_cv_prog_STRIP="$(type -P true ) faking strip"

	# keep prefix env contained within the EPREFIX
	use prefix && myconf+=( --without-local-dir )

	econf \
		--with-modified-by=Gentoo-${PVR} \
		"${myconf[@]}"
}

src_compile() {
	# The following allows emake to be used
	emake -j1 -C src auto/osdef.h objects

	emake
}

src_test() {
	echo
	einfo "Starting vim tests. Several error messages will be shown"
	einfo "while the tests run. This is normal behaviour and does not"
	einfo "indicate a fault."
	echo
	ewarn "If the tests fail, your terminal may be left in a strange"
	ewarn "state. Usually, running 'reset' will fix this."
	echo

	# Don't let vim talk to X
	unset DISPLAY

	emake -j1 -C src/testdir nongui
}

# Make convenience symlinks, hopefully without stepping on toes.  Some
# of these links are "owned" by the vim ebuild when it is installed,
# but they might be good for gvim as well (see bug 45828)
update_vim_symlinks() {
	local f syms
	syms="vimdiff rvim rview"
	einfo "Calling eselect vi update..."
	# Call this with --if-unset to respect user's choice (bug 187449)
	eselect vi update --if-unset

	# Make or remove convenience symlink, vim -> gvim
	if [[ -f "${EROOT}"/usr/bin/gvim ]]; then
		ln -s gvim "${EROOT}"/usr/bin/vim 2>/dev/null
	elif [[ -L "${EROOT}"/usr/bin/vim && ! -f "${EROOT}"/usr/bin/vim ]]; then
		rm "${EROOT}"/usr/bin/vim
	fi

	# Make or remove convenience symlinks to vim
	if [[ -f "${EROOT}"/usr/bin/vim ]]; then
		for f in ${syms}; do
			ln -s vim "${EROOT}"/usr/bin/${f} 2>/dev/null
		done
	else
		for f in ${syms}; do
			if [[ -L "${EROOT}"/usr/bin/${f} && ! -f "${EROOT}"/usr/bin/${f} ]]; then
				rm -f "${EROOT}"/usr/bin/${f}
			fi
		done
	fi

	# This will still break if you merge then remove the vi package,
	# but there's only so much you can do, eh?	Unfortunately we don't
	# have triggers like are done in rpm-land.
}

src_install() {
	local vimfiles=/usr/share/vim/vim${VIM_VERSION/.}

	# Note: Do not install symlinks for 'vi', 'ex', or 'view', as these are
	#	 managed by eselect-vi
	dobin src/vim
	dosym vim /usr/bin/vimdiff
	dosym vim /usr/bin/rvim
	dosym vim /usr/bin/rview
	if use vim-pager ; then
		dosym ${vimfiles}/macros/less.sh /usr/bin/vimpager
		dosym ${vimfiles}/macros/manpager.sh /usr/bin/vimmanpager
		insinto ${vimfiles}/macros
		doins runtime/macros/manpager.sh
		fperms a+x ${vimfiles}/macros/manpager.sh
	fi

	newbashcomp "${FILESDIR}"/${PN}-completion ${PN}
	# keep in sync with 'complete ... -F' list
	bashcomp_alias vim ex vi view rvim rview vimdiff

	# We shouldn't be installing the ex or view man page symlinks, as they
	# are managed by eselect-vi
	rm -f "${ED}"/usr/share/man/man1/{ex,view}.1
}

pkg_postinst() {
	# Update documentation tags (from vim-doc.eclass)
	update_vim_helptags

	# Make convenience symlinks
	update_vim_symlinks
}

pkg_postrm() {
	# Update documentation tags (from vim-doc.eclass)
	update_vim_helptags

	# Make convenience symlinks
	update_vim_symlinks
}

