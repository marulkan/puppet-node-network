require 'spec_helper'

describe 'node_network', :type => 'define' do
    context "Admin interface only" do
        let :facts do
            {
                :interfaces     => 'lo,em1,em2,em3,em4,p2p1,p2p2',
                :osfamily       => 'RedHat',
                :macaddress_em1 => 'fe:fe:fe:aa:aa:aa',
            }
        end
        let :params do
            {
                :admin_interface   => 'em1',
                :admin_ipaddress   => '1.2.3.4',
                :admin_netmask     => '255.255.255.0',
                :route_ipaddress   => ['4.3.2.1'],
                :route_netmask     => ['255.255.255.0'],
                :route_gateway     => ['4.3.2.254'],
            }
        end
        it { should contain_file('route-em1').with(
            :ensure => 'present',
            :mode   => '0644',
            :owner  => 'root',
            :group  => 'root',
            :path   => '/etc/sysconfig/network-scripts/route-em1',
            :content => \
/ADDRESS0=4.3.2.1
NETMASK0=255.255.255.0
GATEWAY0=4.3.2.254/
        )}
        it { should contain_file('ifcfg-em1').with(
            :ensure => 'present',
            :mode   => '0644',
            :owner  => 'root',
            :group  => 'root',
            :path   => '/etc/sysconfig/network-scripts/ifcfg-em1',
            :content => \
/DEVICE=em1
BOOTPROTO=none
HWADDR=fe:fe:fe:aa:aa:aa
ONBOOT=yes
HOTPLUG=yes
TYPE=Ethernet
IPADDR=1.2.3.4
NETMASK=255.255.255.0
PEERDNS=no
NM_CONTROLLED=no/
        )}
        it { should_not contain_file('ifcfg-em2') }
        it { should_not contain_file('ifcfg-em3') }
        it { should_not contain_file('ifcfg-em4') }
        it { should_not contain_file('ifcfg-p2p1') }
        it { should_not contain_file('ifcfg-p2p2') }
    end


    context "Admin interface with no specced ip" do
        let :facts do
            {
                :interfaces     => 'lo,em1,em2,em3,em4,p2p1,p2p2',
                :osfamily       => 'RedHat',
                :macaddress_em1 => 'fe:fe:fe:aa:aa:aa',
                :ipaddress      => '1.2.3.4',
                :netmask        => '255.255.255.0',
            }
        end
        let :params do
            {
                :admin_interface => 'em1',
                :route_ipaddress => ['4.3.2.1'],
                :route_netmask   => ['255.255.255.0'],
                :route_gateway   => ['4.3.2.254'],
            }
        end
        it { should contain_file('route-em1').with(
            :ensure => 'present',
            :mode   => '0644',
            :owner  => 'root',
            :group  => 'root',
            :path   => '/etc/sysconfig/network-scripts/route-em1',
            :content => \
/ADDRESS0=4.3.2.1
NETMASK0=255.255.255.0
GATEWAY0=4.3.2.254/
        )}
        it { should contain_file('ifcfg-em1').with(
            :ensure => 'present',
            :mode   => '0644',
            :owner  => 'root',
            :group  => 'root',
            :path   => '/etc/sysconfig/network-scripts/ifcfg-em1',
            :content => \
/DEVICE=em1
BOOTPROTO=none
HWADDR=fe:fe:fe:aa:aa:aa
ONBOOT=yes
HOTPLUG=yes
TYPE=Ethernet
IPADDR=1.2.3.4
NETMASK=255.255.255.0
PEERDNS=no
NM_CONTROLLED=no/
        )}
        it { should_not contain_file('ifcfg-em2') }
        it { should_not contain_file('ifcfg-em3') }
        it { should_not contain_file('ifcfg-em4') }
        it { should_not contain_file('ifcfg-p2p1') }
        it { should_not contain_file('ifcfg-p2p2') }
    end

    context "Traffic interfaces only" do
        let :facts do
            {
                :interfaces     => 'lo,em1,em2,em3,em4,p2p1,p2p2',
                :osfamily       => 'RedHat',
                :macaddress_em1 => 'fe:fe:fe:aa:aa:aa',
            }
        end
        let :params do
            {
                :traffic_interfaces  => ['p2p1', 'p2p2'],
                :admin_ipaddress   => '1.2.3.4',
                :admin_netmask     => '255.255.255.0',
            }
        end
        it { should contain_file('ifcfg-p2p1').with(
            :ensure => 'present',
            :mode   => '0644',
            :owner  => 'root',
            :group  => 'root',
            :path   => '/etc/sysconfig/network-scripts/ifcfg-p2p1',
            :content => \
/DEVICE=p2p1
BOOTPROTO=dhcp
ONBOOT=yes
HOTPLUG=yes
TYPE=Ethernet
PEERDNS=no
NM_CONTROLLED=no/
        )}
        it { should contain_file('ifcfg-p2p2').with(
            :ensure => 'present',
            :mode   => '0644',
            :owner  => 'root',
            :group  => 'root',
            :path   => '/etc/sysconfig/network-scripts/ifcfg-p2p2',
            :content => \
/DEVICE=p2p2
BOOTPROTO=dhcp
ONBOOT=yes
HOTPLUG=yes
TYPE=Ethernet
PEERDNS=no
NM_CONTROLLED=no/
        )}
        it { should_not contain_file('ifcfg-em1') }
        it { should_not contain_file('route-em1') }
        it { should_not contain_file('ifcfg-em2') }
        it { should_not contain_file('ifcfg-em3') }
        it { should_not contain_file('ifcfg-em4') }
    end


    context "Disabled interfaces" do
        let :facts do
            {
                :interfaces     => 'lo,em1,em2,em3,em4,p2p1,p2p2',
                :osfamily       => 'RedHat',
                :macaddress_em1 => 'fe:fe:fe:aa:aa:aa',
            }
        end
        let :params do
            {
                :disabled_interfaces => ['em2', 'em3'],
                :admin_ipaddress   => '1.2.3.4',
                :admin_netmask     => '255.255.255.0',
            }
        end
        it { should contain_file('ifcfg-em2').with(
            :ensure => 'present',
            :mode   => '0644',
            :owner  => 'root',
            :group  => 'root',
            :path   => '/etc/sysconfig/network-scripts/ifcfg-em2',
            :content => \
/DEVICE=em2
BOOTPROTO=dhcp
ONBOOT=no
HOTPLUG=no
TYPE=Ethernet
PEERDNS=no
NM_CONTROLLED=no/
        )}
        it { should contain_file('ifcfg-em3').with(
            :ensure => 'present',
            :mode   => '0644',
            :owner  => 'root',
            :group  => 'root',
            :path   => '/etc/sysconfig/network-scripts/ifcfg-em3',
            :content => \
/DEVICE=em3
BOOTPROTO=dhcp
ONBOOT=no
HOTPLUG=no
TYPE=Ethernet
PEERDNS=no
NM_CONTROLLED=no/
        )}
        it { should_not contain_file('ifcfg-em1') }
        it { should_not contain_file('route-em1') }
        it { should_not contain_file('ifcfg-em4') }
        it { should_not contain_file('ifcfg-p2p1') }
        it { should_not contain_file('ifcfg-p2p2') }
    end


    context "Everything enabled." do
        let :facts do
            {
                :interfaces     => 'lo,em1,em2,em3,em4,p2p1,p2p2',
                :osfamily       => 'RedHat',
                :macaddress_em1 => 'fe:fe:fe:aa:aa:aa',
            }
        end
        let :params do
            {
                :disabled_interfaces => ['em2', 'em3'],
                :traffic_interfaces  => ['p2p1', 'p2p2'],
                :admin_interface     => 'em1',
                :admin_ipaddress     => '1.2.3.4',
                :admin_netmask       => '255.255.255.0',
                :route_ipaddress     => ['4.3.2.1'],
                :route_netmask       => ['255.255.255.0'],
                :route_gateway       => ['4.3.2.254'],
            }
        end

        it { should contain_file('ifcfg-em1').with(
            :ensure => 'present',
            :mode   => '0644',
            :owner  => 'root',
            :group  => 'root',
            :path   => '/etc/sysconfig/network-scripts/ifcfg-em1',
            :content => \
/DEVICE=em1
BOOTPROTO=none
HWADDR=fe:fe:fe:aa:aa:aa
ONBOOT=yes
HOTPLUG=yes
TYPE=Ethernet
IPADDR=1.2.3.4
NETMASK=255.255.255.0
PEERDNS=no
NM_CONTROLLED=no/
        )}
        it { should contain_file('route-em1').with(
            :ensure => 'present',
            :mode   => '0644',
            :owner  => 'root',
            :group  => 'root',
            :path   => '/etc/sysconfig/network-scripts/route-em1',
            :content => \
/ADDRESS0=4.3.2.1
NETMASK0=255.255.255.0
GATEWAY0=4.3.2.254/
        )}
        it { should contain_file('ifcfg-em2').with(
            :ensure => 'present',
            :mode   => '0644',
            :owner  => 'root',
            :group  => 'root',
            :path   => '/etc/sysconfig/network-scripts/ifcfg-em2',
            :content => \
/DEVICE=em2
BOOTPROTO=dhcp
ONBOOT=no
HOTPLUG=no
TYPE=Ethernet
PEERDNS=no
NM_CONTROLLED=no/
        )}
        it { should contain_file('ifcfg-em3').with(
            :ensure => 'present',
            :mode   => '0644',
            :owner  => 'root',
            :group  => 'root',
            :path   => '/etc/sysconfig/network-scripts/ifcfg-em3',
            :content => \
/DEVICE=em3
BOOTPROTO=dhcp
ONBOOT=no
HOTPLUG=no
TYPE=Ethernet
PEERDNS=no
NM_CONTROLLED=no/
        )}
        it { should contain_file('ifcfg-p2p1').with(
            :ensure => 'present',
            :mode   => '0644',
            :owner  => 'root',
            :group  => 'root',
            :path   => '/etc/sysconfig/network-scripts/ifcfg-p2p1',
            :content => \
/DEVICE=p2p1
BOOTPROTO=dhcp
ONBOOT=yes
HOTPLUG=yes
TYPE=Ethernet
PEERDNS=no
NM_CONTROLLED=no/
        )}
        it { should contain_file('ifcfg-p2p2').with(
            :ensure => 'present',
            :mode   => '0644',
            :owner  => 'root',
            :group  => 'root',
            :path   => '/etc/sysconfig/network-scripts/ifcfg-p2p2',
            :content => \
/DEVICE=p2p2
BOOTPROTO=dhcp
ONBOOT=yes
HOTPLUG=yes
TYPE=Ethernet
PEERDNS=no
NM_CONTROLLED=no/
        )}
    end
end
