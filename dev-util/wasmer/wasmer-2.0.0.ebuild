# Copyright 2017-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# rq -tJ <Cargo.lock | jq -r '.package[] | "\(.name)-\(.version)"'
# Not sure if all of these are required
CRATES="
addr2line-0.15.2
adler-1.0.2
ahash-0.4.7
aho-corasick-0.7.18
ansi_term-0.11.0
anyhow-1.0.40
arbitrary-1.0.1
arrayref-0.3.6
arrayvec-0.5.2
assert_cmd-1.0.5
atty-0.2.14
autocfg-1.0.1
backtrace-0.3.60
bincode-1.3.3
bindgen-0.56.0
bitflags-1.2.1
blake3-0.3.8
bstr-0.2.16
build-deps-0.1.4
bumpalo-3.7.0
byteorder-1.4.3
bytesize-1.0.1
cast-0.2.6
cbindgen-0.18.0
cc-1.0.68
cexpr-0.4.0
cfg-if-0.1.10
cfg-if-1.0.0
clang-sys-1.2.0
clap-2.33.3
cmake-0.1.45
colored-1.9.3
colored-2.0.0
compiletest_rs-0.6.0
constant_time_eq-0.1.5
cranelift-bforest-0.74.0
cranelift-codegen-0.74.0
cranelift-codegen-meta-0.74.0
cranelift-codegen-shared-0.74.0
cranelift-entity-0.74.0
cranelift-frontend-0.74.0
crc32fast-1.2.1
criterion-0.3.4
criterion-plot-0.4.3
crossbeam-channel-0.5.1
crossbeam-deque-0.8.0
crossbeam-epoch-0.9.5
crossbeam-utils-0.8.5
crypto-mac-0.8.0
csv-1.1.6
csv-core-0.1.10
ctor-0.1.20
darling-0.12.4
darling_core-0.12.4
darling_macro-0.12.4
derive_arbitrary-1.0.1
diff-0.1.12
difference-2.0.0
digest-0.9.0
dirs-next-2.0.0
dirs-sys-next-0.1.2
distance-0.4.0
doc-comment-0.3.3
downcast-rs-1.2.0
dynasm-1.1.0
dynasmrt-1.1.0
either-1.6.1
encoding_rs-0.8.28
enumset-1.0.6
enumset_derive-0.5.4
env_logger-0.8.3
erased-serde-0.3.15
fallible-iterator-0.2.0
fern-0.6.0
field-offset-0.3.4
filetime-0.2.14
flate2-1.0.20
float-cmp-0.8.0
fnv-1.0.7
generational-arena-0.2.8
generic-array-0.14.4
getopts-0.2.21
getrandom-0.2.3
ghost-0.1.2
gimli-0.24.0
glob-0.3.0
half-1.7.1
hashbrown-0.9.1
heck-0.3.3
hermit-abi-0.1.18
hex-0.4.3
humantime-2.1.0
ident_case-1.0.1
indexmap-1.6.2
inkwell_internals-0.3.0
inline-c-0.1.6
inline-c-macro-0.1.5
instant-0.1.9
inventory-0.1.10
inventory-impl-0.1.10
itertools-0.9.0
itertools-0.10.0
itoa-0.4.7
js-sys-0.3.51
lazy_static-1.4.0
lazycell-1.3.0
leb128-0.2.4
libc-0.2.95
libfuzzer-sys-0.4.2
libloading-0.7.0
llvm-sys-110.0.1
lock_api-0.4.4
log-0.4.14
loupe-0.1.2
loupe-derive-0.1.2
mach-0.3.2
maybe-uninit-2.0.0
memchr-2.4.0
memmap2-0.2.3
memoffset-0.6.4
minifb-0.19.3
miniz_oxide-0.4.4
miow-0.3.7
more-asserts-0.2.1
nix-0.20.0
nom-5.1.2
nom-6.1.2
normalize-line-endings-0.3.0
num-traits-0.2.14
num_cpus-1.13.0
object-0.25.2
once_cell-1.7.2
oorandom-11.1.3
orbclient-0.3.31
output_vt100-0.1.2
parking_lot-0.11.1
parking_lot_core-0.8.3
paste-1.0.5
peeking_take_while-0.1.2
pest-2.1.3
pin-project-lite-0.2.6
pkg-config-0.3.19
plotters-0.3.1
plotters-backend-0.3.0
plotters-svg-0.3.0
ppv-lite86-0.2.10
predicates-1.0.8
predicates-core-1.0.2
predicates-tree-1.0.2
pretty_assertions-0.6.1
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro2-1.0.27
ptr_meta-0.1.3
ptr_meta_derive-0.1.2
quote-1.0.9
rand-0.8.3
rand_chacha-0.3.0
rand_core-0.6.2
rand_hc-0.3.0
raw-window-handle-0.3.3
rayon-1.5.1
rayon-core-1.9.1
redox_syscall-0.2.8
redox_users-0.4.0
ref_thread_local-0.1.0
regalloc-0.0.31
regex-1.5.4
regex-automata-0.1.10
regex-syntax-0.6.25
region-2.2.0
remove_dir_all-0.5.3
rkyv-0.6.6
rkyv_derive-0.6.3
rustc-demangle-0.1.19
rustc-hash-1.1.0
rustc_version-0.2.3
rustc_version-0.3.3
rustfix-0.5.1
rustversion-1.0.5
ryu-1.0.5
same-file-1.0.6
scopeguard-1.1.0
sdl2-0.34.5
sdl2-sys-0.34.5
seahash-4.1.0
semver-0.9.0
semver-0.11.0
semver-1.0.3
semver-parser-0.7.0
semver-parser-0.10.2
serde-1.0.126
serde_bytes-0.11.5
serde_cbor-0.11.1
serde_derive-1.0.126
serde_json-1.0.64
serial_test-0.5.1
serial_test_derive-0.5.1
shlex-0.1.1
smallvec-1.6.1
stable_deref_trait-1.2.0
strsim-0.8.0
strsim-0.10.0
structopt-0.3.21
structopt-derive-0.4.14
subtle-2.4.0
syn-1.0.72
tar-0.4.35
target-lexicon-0.11.2
target-lexicon-0.12.0
tempfile-3.2.0
term-0.7.0
termcolor-1.1.2
test-generator-0.1.0
tester-0.9.0
textwrap-0.11.0
thiserror-1.0.25
thiserror-impl-1.0.25
time-0.1.43
tinytemplate-1.2.1
toml-0.5.8
tracing-0.1.26
tracing-attributes-0.1.15
tracing-core-0.1.18
treeline-0.1.0
trybuild-1.0.42
typenum-1.13.0
typetag-0.1.7
typetag-impl-0.1.7
ucd-trie-0.1.3
unicode-segmentation-1.7.1
unicode-width-0.1.8
unicode-xid-0.2.2
unidiff-0.3.3
vec_map-0.8.2
version-compare-0.0.10
version_check-0.9.3
wait-timeout-0.2.0
walkdir-2.3.2
wasi-0.10.2+wasi-snapshot-preview1
wasm-bindgen-0.2.74
wasm-bindgen-backend-0.2.74
wasm-bindgen-macro-0.2.74
wasm-bindgen-macro-support-0.2.74
wasm-bindgen-shared-0.2.74
wasm-encoder-0.4.1
wasm-smith-0.4.5
wasmer_inkwell-0.2.0-alpha.2
wasmparser-0.78.2
wasmprinter-0.2.26
wast-35.0.2
wat-1.0.37
wayland-client-0.28.5
wayland-commons-0.28.5
wayland-cursor-0.28.5
wayland-protocols-0.28.5
wayland-scanner-0.28.5
wayland-sys-0.28.5
web-sys-0.3.51
which-3.1.1
which-4.1.0
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
x11-dl-2.18.5
xattr-0.2.2
xcursor-0.3.3
xkb-0.2.1
xkbcommon-sys-0.7.5
xml-rs-0.8.3
"

inherit cargo eutils

DESCRIPTION="universal web assembly runtime"
HOMEPAGE="https://wasmer.io"
SRC_URI="https://github.com/wasmerio/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="MIT Apache-2.0 BSD-2 ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="llvm +cranelift +singlepass debug-wasm +executable c-api headless"
REQUIRED_USE=""

BDEPEND="
	dev-util/cmake
	>=virtual/rust-1.37.0
	llvm? ( || (
		sys-devel/llvm:10[llvm_targets_X86,llvm_targets_AArch64]
		sys-devel/llvm:11[llvm_targets_X86,llvm_targets_AArch64]
	) )
"
# rust version is probably not sufficient, but wasmer doesn't indicate a minimum
# inkwell seems to have some odd link dependencies on llvm.

wasmer_env() {
	export ENABLE_LLVM=$(usex llvm 1 0)
	export ENABLE_CRANELIFT=$(usex cranelift 1 0)
	export ENABLE_SINGLEPASS=$(usex singlepass 1 0)
	export WASMER_INSTALL_PREFIX=/usr/share/wasmer
	export DESTDIR="${ED}/usr"
	if use llvm; then
		export RUSTFLAGS="$(echo "$RUSTFLAGS" $(llvm-config --ldflags) $(llvm-config --libs engine))"
		# For some reason, inkwell doesn't pick up the llvm link flags correctly
	fi
	export RUSTFLAGS="$RUSTFLAGS -C link-arg=-Wl,-soname,libwasmer.so"
}

src_prepare() {
	[[ "${PV}" == *9999* ]] || ln -s ../${P}-git-deps "${ECARGO_HOME}"/git
	if $(usex debug-wasm true false); then # limited ebuild knowledge...
		# Upstream wasmer doesn't expose it, but it's such an incredibly useful feature, that I just can't...
		eapply "${FILESDIR}/debug-wasm.patch" || die "patch debug-wasm"
	fi
	#eapply "${FILESDIR}/fix-soname.patch" || die "patch soname"
	default
}

src_compile() {
	wasmer_env
	make \
		$(usex executable $(usex debug build-wasmer-debug build-wasmer) "") \
		$(usex c-api build-capi "") \
	|| die "make failed"
	if $(usex headless true false); then
		cargo build --locked $(usex debug "" --release) --manifest-path=lib/cli/Cargo.toml --no-default-features --features headless-minimal --bin wasmer-headless
	fi
}

src_install() {
	wasmer_env
	make \
		$(usex executable "install-wasmer" "") \
		$(usex c-api "install-capi-headers install-capi-lib install-pkgconfig install-capi-staticlib" "") \
		$(usex headless install-wasmer-headless-minimal "") \
		install-misc \
	|| die "make install failed"
	mv "$DESTDIR/lib" "$DESTDIR/lib64"
	# Wasmer insists that its lib folder is $WASMER_INSTALL_DIR/lib, which doesn't go down well with multilib_strict_check. Uuuu hack around!
	if $(usex c-api true false); then
		dodir /usr/share/wasmer
		dosym ../../bin /usr/share/wasmer/bin
		dosym ../../lib64 /usr/share/wasmer/lib
		dosym ../../include /usr/share/wasmer/include
		# For good measure
		dosym .. /usr/share/wasmer/include/wasmer
	fi
}
