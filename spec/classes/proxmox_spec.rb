# frozen_string_literal: true

require "spec_helper"

describe "proxmox" do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to contain_apt__source("proxmox").with_location(["http://download.proxmox.com/debian/pve"]) }
      # it { is_expected.to contain_apt__source("ceph").with_location(["http://download.proxmox.com/debian/ceph-tentacle"]) }
      it { is_expected.to contain_apt__source("ceph") }
      it { is_expected.to contain_apt__source("debian").with_location(["http://deb.debian.org/debian"]) }
      it { is_expected.to contain_apt__source("debian-security").with_location(["http://security.debian.org/debian-security"]) }

      case os
      when "debian-13-x86_64"
        # Proxmox VE 9
        # it { is_expected.to contain_apt__source("ceph").with_location(["http://download.proxmox.com/debian/ceph-tentacle"]) }
      when "debian-12-x86_64"
        # Proxmox VE 8
        # it { is_expected.to contain_apt__source("ceph").with_location(["http://download.proxmox.com/debian/ceph-squid"]) }
      else
        raise "unsupported os"
      end
    end
  end
end
