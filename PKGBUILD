# Maintainer: Forrest Dunlap <forrestmdunlap@gmail.com>

pkgname=split-tunnel-ovpn
pkgver=1.0.3
pkgrel=1
pkgdesc="A package for configuring split tunneling with OpenVPN"
arch=('any')
url="https://github.com/fmdunlap/split-tunnel-ovpn"
license=('MIT')
depends=('openvpn' 'bind' 'go')
backup=('etc/split-tunnel-ovpn/config.ovpn'
        'etc/split-tunnel-ovpn/data/exclude_ips.txt'
        'etc/split-tunnel-ovpn/data/target_domains.txt')
source=("${pkgname}-${pkgver}.tar.gz")
sha256sums=('SKIP')

package() {
    cd "${pkgname}-${pkgver}"

    # Install scripts
    install -Dm755 "usr/local/bin/split-tunnel-ovpn-generate.sh" "${pkgdir}/usr/local/bin/split-tunnel-ovpn-generate"
    install -Dm755 "usr/local/bin/split-tunnel-ovpn-route-up.sh" "${pkgdir}/usr/local/bin/split-tunnel-ovpn-route-up"
    install -Dm755 "usr/local/bin/split-tunnel-ovpn-configure.sh" "${pkgdir}/usr/local/bin/split-tunnel-ovpn-configure"
    install -Dm755 "usr/local/bin/split-tunnel-ovpn-start.sh" "${pkgdir}/usr/local/bin/split-tunnel-ovpn-start"

    # Install configuration files
    install -Dm644 "etc/split-tunnel-ovpn/config.ovpn" "${pkgdir}/etc/split-tunnel-ovpn/config.ovpn"
    install -Dm644 "etc/split-tunnel-ovpn/data/exclude_ips.txt" "${pkgdir}/etc/split-tunnel-ovpn/data/exclude_ips.txt"
    install -Dm644 "etc/split-tunnel-ovpn/data/ip_addresses.txt" "${pkgdir}/etc/split-tunnel-ovpn/data/ip_addresses.txt"
    install -Dm644 "etc/split-tunnel-ovpn/data/target_domains.txt" "${pkgdir}/etc/split-tunnel-ovpn/data/target_domains.txt"

    # Install systemd service and timer
    install -Dm644 "etc/systemd/system/split-tunnel-ovpn-subdomains.service" "${pkgdir}/etc/systemd/system/split-tunnel-ovpn-subdomains.service"
    install -Dm644 "etc/systemd/system/split-tunnel-ovpn-subdomains.timer" "${pkgdir}/etc/systemd/system/split-tunnel-ovpn-subdomains.timer"

    # Create directories for credentials and data
    install -dm755 "${pkgdir}/etc/split-tunnel-ovpn/creds"
    install -dm755 "${pkgdir}/etc/split-tunnel-ovpn/data"

    GOBIN="${pkgdir}/usr/local/bin" go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
    install -Dm755 "${pkgdir}/usr/local/bin/subfinder" "${pkgdir}/usr/local/bin/split-tunnel-subfinder"
}

post_remove() {
    # Remove the systemd service and timer after package removal
    rm /etc/systemd/system/split-tunnel-ovpn-subdomains.service
    rm /etc/systemd/system/split-tunnel-ovpn-subdomains.timer
    systemctl daemon-reload
}