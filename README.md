# mlibrary/puppet-proxmox

Puppet module to setup Proxmox VE

## Usage

```puppet
include proxmox
```

```yaml
# default Debian mirror
proxmox::debian_mirror: http://deb.debian.org/debian
# Proxmox repo. Options are: test, no-subscription, or enterprise
proxmox::pve_repo: no-subscription
# Ceph release is set automatically to match Proxmox version
# override to hold back or upgrade
#proxmox::ceph_release: squid
#proxmox::ceph_release: tentacle
# set to false to disable ceph repo
proxmox::configure_ceph: true
# self-explanatory, I hope
proxmox::remove_subscription_nag: true
```

You should probably explicitly set `ceph_release` if you're using Ceph, since you don't want a
module upgrade to suddenly change the Ceph version.

You'll want to set `pve_repo` if you need enterprise or test.
