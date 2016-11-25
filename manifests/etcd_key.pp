# Class: flannel::etcd_key
#
# creates the network key in etcd
#
# Parameters:
#
# [*network*]
#   IPv4 network in CIDR format to use for the entire flannel network. This is the only mandatory key.
#   Defaults to 10.0.0.0/8
#
# [*subnetlen*]
#   The size of the subnet allocated to each host.
#   Defaults to 24 (i.e. /24) unless the Network was configured to be smaller than a /24
#   in which case it is one less than the network.
#
# [*subnetmin*]
#   The beginning of IP range which the subnet allocation should start with.
#   Defaults to the first subnet of Network.
#
# [*subnetmax*]
#   The end of the IP range at which the subnet allocation should end with.
#   Defaults to the last subnet of Network.
#
# [*backend_type*]
#   Type of backend to use
#   Defaults to "udp" backend.
#
# [*backend_port*]
#   what port to use for backend communication
#   Defaults to 7890
#
class flannel::etcd_key (
  # etcd network definition
  $network      = '10.0.0.0/8',
  $subnetlen    = undef,
  $subnetmin    = undef,
  $subnetmax    = undef,
  $backend_type = 'udp',
  $backend_port = 7890,
) {
  include ::etcd

  etcd_key { "${::flannel::etcd_prefix}/config":
    value     => template('flannel/etcd_network_definition.erb'),
    peers     => join($::flannel::etcd_endpoints, ','),
    cert_file => $::flannel::etcd_certfile,
    key_file  => $::flannel::etcd_keyfile,
    ca_file   => $::flannel::etcd_cafile,
    notify    => Service['flanneld'],
  }
}
