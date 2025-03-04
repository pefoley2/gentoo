# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_10 )

inherit distutils-r1

DESCRIPTION="Development tools for Lean's mathlib"
HOMEPAGE="https://github.com/leanprover-community/mathlib-tools"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/leanprover-community/${PN}.git"
else
	_PV=${PV/_p1/}
	SRC_URI="https://github.com/leanprover-community/${PN}/archive/v${_PV}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}"/${PN}-${_PV}
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"

BDEPEND="
	>=dev-python/GitPython-2.1.11[${PYTHON_USEDEP}]
	dev-python/PyGithub[${PYTHON_USEDEP}]
	dev-python/atomicwrites[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/pydot[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/tomli-w[${PYTHON_USEDEP}]
	dev-python/tomli[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
"
RDEPEND="
	${BDEPEND}
	sci-mathematics/lean:0/3
"

PATCHES=( "${FILESDIR}"/${PN}-1.3.2-pull-131.patch )

distutils_enable_tests pytest

src_prepare() {
	# Remove problematic tests (mainly issues with network)
	rm ./tests/test_functional.py || die

	distutils-r1_python_prepare_all
}
