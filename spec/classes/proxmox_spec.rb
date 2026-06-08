# frozen_string_literal: true

require "spec_helper"

describe "proxmox" do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # apt repos
      it "configures proxmox apt repo" do
        is_expected.to contain_apt__source("proxmox").with_location(["http://download.proxmox.com/debian/pve"])
      end
      it "configures debian apt repo" do
        is_expected.to contain_apt__source("debian").with_location(["http://deb.debian.org/debian"])
      end
      it "configures debian-security apt repo" do
        is_expected.to contain_apt__source("debian-security").with_location(["http://security.debian.org/debian-security"])
      end
      context "ceph disabled" do
        let(:params) { {:configure_ceph => false} }
        it "does not configure ceph apt repo" do
          is_expected.not_to contain_apt__source("ceph")
        end
      end

      # license nag
      it "installs and executes /usr/local/bin/pve-remove-nag.sh" do
        is_expected.to contain_file("/usr/local/bin/pve-remove-nag.sh").that_notifies("Exec[pve-remove-nag.sh]")
        is_expected.to contain_exec("pve-remove-nag.sh").with_command(["/usr/local/bin/pve-remove-nag.sh"])
      end
      it "configures apt to re-run pve-remove-nag.sh" do
        is_expected.to contain_file("/etc/apt/apt.conf.d/no-nag-script")
          .with_content('DPkg::Post-Invoke { "/usr/local/bin/pve-remove-nag.sh"; };'+"\n")
      end

      case os
      when "debian-13-x86_64"
        # Proxmox VE 9
        it "defaults to ceph-tentacle" do
          is_expected.to contain_apt__source("ceph").with_location(["http://download.proxmox.com/debian/ceph-tentacle"])
        end
      when "debian-12-x86_64"
        # Proxmox VE 8
        it "defaults to ceph-squid" do
          is_expected.to contain_apt__source("ceph").with_location(["http://download.proxmox.com/debian/ceph-squid"])
        end
      else
        raise "unsupported os"
      end
    end
  end
end
