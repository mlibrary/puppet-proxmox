class proxmox (
  String $debian_mirror = 'http://deb.debian.org/debian',
  Enum['pve-test', 'pve-no-subscription', 'pve-enterprise'] $pve_repo = 'pve-no-subscription',
  Optional[Enum['reef','squid','tentacle']] $ceph_release = undef,
  Boolean $remove_subscription_nag = true,
) {
  $pve_url_base = $pve_repo ? {
    'pve-enterprise' => 'https://enterprise.proxmox.com/debian',
    default => 'http://download.proxmox.com/debian'
  }

  apt::source {
    default:
      source_format => 'sources',
      repos         => ['main', 'contrib', 'non-free-firmware'],
      keyring       => '/usr/share/keyrings/debian-archive-keyring.gpg',
    ;
    'debian':
      location => [$debian_mirror],
      release  => [
        $facts['os']['distro']['codename'],
        "${facts['os']['distro']['codename']}-updates",
      ],
    ;
    'debian-security':
      location => ['http://security.debian.org/debian-security'],
      release  => ["${facts['os']['distro']['codename']}-security"],
    ;
  }

  apt::source { 'proxmox':
    source_format => 'sources',
    keyring       => '/usr/share/keyrings/proxmox-archive-keyring.gpg',
    repos         => [$pve_repo],
    location      => ["${pve_url_base}/pve"],
  }

  if $ceph_release {
    apt::source { 'ceph':
      source_format => 'sources',
      keyring       => '/usr/share/keyrings/proxmox-archive-keyring.gpg',
      repos         => [$pve_repo],
      location      => ["${pve_url_base}/ceph-${ceph_release}"],
    }
  }

  if $remove_subscription_nag {
    file {
      default:
        owner => 'root',
        group => 'root',
      ;
      '/usr/local/bin/pve-remove-nag.sh':
        mode   => '0755',
        source => 'puppet:///modules/proxmox/pve-remove-nag.sh',
        notify => Exec['pve-remove-nag.sh'],
      ;
      '/etc/apt/apt.conf.d/no-nag-script':
        mode => '0644',
        content => @(EOT)
          DPkg::Post-Invoke { "/usr/local/bin/pve-remove-nag.sh"; };
          | EOT
      ;
    }
    exec { 'pve-remove-nag.sh':
      command     => ['/usr/local/bin/pve-remove-nag.sh'],
      refreshonly => true,
    }
  }
  else {
    file { default: ensure => absent;
      '/usr/local/bin/pve-remove-nag.sh': ;
      '/etc/apt/apt.conf.d/no-nag-script': ;
    }
  }
}
