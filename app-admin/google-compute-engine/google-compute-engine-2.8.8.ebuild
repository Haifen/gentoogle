# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{6,7}} pypy{,3} )

inherit distutils-r1 systemd

GITHUB_USER="GoogleCloudPlatform"
MY_PN="compute-image-packages"
MY_TAG="20181023"

DESCRIPTION="Scripts and tools for Google Compute Engine Linux images."
HOMEPAGE="https://github.com/GoogleCloudPlatform/compute-image-packages"
SRC_URI="https://github.com/GoogleCloudPlatform/compute-image-packages/archive/${MY_TAG}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
    dev-python/boto[${PYTHON_USEDEP}]
    dev-python/distro[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}
    dev-python/setuptools[${PYTHON_USEDEP}]
"

INIT=(
	"google-accounts-daemon"
	"google-clock-skew-daemon"
	"google-instance-setup"
	"google-network-daemon"
	"google-shutdown-scripts"
	"google-startup-scripts")

python_install_all() {
	for _s in "${INIT[@]}"
	do
		newinitd "${DISTDIR}/${_s}.${MY_TAG}" "${S}/google_compute_engine_init/sysvinit/${_s}"
		systemd_newunit "${DISTDIR}/${_s}.service.${MY_TAG}" "${S}/google_compute_engine_init/systemd/${_s}.service"
	done

	# Install google-compute-engine python modules.
	distutils-r1_python_install_all
}

pkg_postinst() {
	ewarn
	ewarn "Systems using systemd can do the following:"
	ewarn "    # Stop existing daemons."
	ewarn "    systemctl stop --no-block google-accounts-daemon"
	ewarn "    systemctl stop --no-block google-clock-skew-daemon"
	ewarn "    systemctl stop --no-block google-network-daemon"
	ewarn
	ewarn "    # Enable systemd services."
	ewarn "    systemctl enable google-accounts-daemon.service"
	ewarn "    systemctl enable google-clock-skew-daemon.service"
	ewarn "    systemctl enable google-instance-setup.service"
	ewarn "    systemctl enable google-network-daemon.service"
	ewarn "    systemctl enable google-shutdown-scripts.service"
	ewarn "    systemctl enable google-startup-scripts.service"
	ewarn
	ewarn "    # Run instance setup manually to prevent startup script execution."
	ewarn "    /usr/bin/google_instance_setup"
	ewarn
	ewarn "    # Start daemons."
	ewarn "    systemctl start --no-block google-network-daemon"
	ewarn "    systemctl start --no-block google-accounts-daemon"
	ewarn "    systemctl start --no-block google-clock-skew-daemon"
	ewarn
}
