include netwok

class puppet_node_network (
  $ipaddress  = '',
  $subnet  = '',
  $gateway = '',
  $disabled_interfaces = '',
  $trafic_interfaces = '',
  $admin_interface = '',
) {
  each($::interfaces) |$interface| {
    if $interface != 'lo' {
      if $interface =~ $running_interfaces {
        network::if::static { "$interface":
          ensure    => 'up',
          ipaddress => $ipaddress,
          netmask   => '',
        }
      }
      if $interface =~ $disabled_interfaces {
        network::if::static { "$interface":
          ensure    => 'up',
          ipaddress => $ipaddress,
          netmask   => '',
        }
      }
    }
  }
  network::route { "$admin_interface":
    ipaddress => $admin_ipaddress,
    netmask   => '',
    gateway   => '',
  }
}
