require 'spec_helper'

describe 'node_network', :type => 'define' do
    context "6 interfaces, 2 disabled, 2 traffic, 1 admin and 1 untouched." do
        let :facts do
            {
                :interfaces => 'lo,em1,em2,em3,em4,p2p1,p2p2',
                :osfamily   => 'RedHat',
            }
        end
        let :params do
            {
                :disabled_interfaces => ['em2', 'em3'],
                :traffic_interfaces  => ['p2p1', 'p2p2'],
                :admin_interface     => 'em1',
                :admin_ipaddress     => '10.132.172.85',
                :admin_netmask       => '255.255.0.0',
                :route_ipaddress     => ['10.132.0.0'],
                :route_netmask       => ['255.255.0.0'],
                :route_gateway       => ['10.132.175.254'],
            }
        end

        it { should contain_file('ifcfg-em1') }
        it { should contain_file('ifcfg-em2') }
        it { should contain_file('ifcfg-em3') }
        it { should contain_file('ifcfg-p2p1') }
        it { should contain_file('ifcfg-p2p2') }
    end
end
