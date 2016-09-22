class node_network (
  $disabled_interfaces          = undef,
  $traffic_interfaces           = undef,
  $traffic_bootproto            = undef,
  $admin_interface              = undef,
  $admin_ipaddress              = $::ipaddress,
  $admin_netmask                = $::netmask,
  $route_ipaddress              = undef,
  $route_netmask                = undef,
  $route_gateway                = undef,

  # Managed network module (optional)
  $manage_network               = true,
) {
  # Manage network module?
  if $manage_network {
    class { 'network': }
  }

  # Looping through all interfaces to determine which that should be disabled
  # and which should be configured as traffic interfaces.
  # This is configured in Hiera, if a interface is not present in Hiera it
  # should remain untouched.

  $interfaces_array = split($::interfaces, ',')
  if $traffic_interfaces {
    $existing_ti = []
    $t1 = inline_template('<%= @interfaces_array.each { |interface| @traffic_interfaces.each { |traffic_interface| @existing_ti << interface if traffic_interface == interface }} %>')
    network::if::dynamic { $existing_ti:
      ensure => 'up',
      bootproto => $traffic_bootproto,
    }
  }
  if $disabled_interfaces {
    $existing_di = []
    $t2 = inline_template('<%= @interfaces_array.each { |interface| @disabled_interfaces.each { |disabled_interface| @existing_di << interface if disabled_interface == interface }} %>')
    network::if::dynamic { $existing_di:
      ensure => 'down',
    }
  }
  # Configuring Admin interface, something that should always be pressent.
  if $admin_interface {
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
}
