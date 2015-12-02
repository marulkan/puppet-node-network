include network

class node_network (
  $disabled_interfaces = undef,
  $traffic_interfaces  = undef,
  $admin_interface     = undef,
  $admin_ipaddress     = undef,
  $admin_netmask       = undef,
  $route_ipaddress     = undef,
  $route_netmask       = undef,
  $route_gateway       = undef,
) {
  # Looping through all interfaces to determine which that should be disabled
  # and which should be configured as traffic interfaces.
  # This is configured in Hiera, if a interface is not present in Hiera it
  # should remain untouched.
  $interfaces_array = split($::interfaces, ',')
  each($interfaces_array) |$interface| {
    each($traffic_interfaces) |$traffic_interface| {
      if $interface == $traffic_interface {
        network::if::dynamic { $interface:
          ensure    => 'up',
        }
      }
    }
    each($disabled_interfaces) |$disabled_interface| {
      if $interface == $disabled_interface {
        network::if::dynamic { $interface:
          ensure    => 'down',
        }
      }
    }
  }
  # Configuring Admin interface, something that should always be pressent.
  network::if::static { $admin_interface:
    ensure    => 'up',
    ipaddress => $admin_ipaddress,
    netmask   => $admin_netmask,
  }
  network::route { $admin_interface:
    ipaddress => $route_ipaddress,
    netmask   => $route_netmask,
    gateway   => $route_gateway,
  }
}
