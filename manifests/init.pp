# Class: flannel
#
# installs, configures and starts the service for flannel.
#
# Parameters:
#
# [*ensure*]
#   Passed to the docker package.
#   Defaults to present
#
# [*service_state*]
#   Whether you want to kube daemons to start up
#   Defaults to running
#
# [*service_enable*]
#   Whether you want to kube daemons to start up at boot
#   Defaults to true
#
# [*public_ip*]
#   IP accessible by other nodes for inter-host communication.
#   Defaults to the IP of the interface being used for communication.
#
# [*etcd_endpoints*]
#   a comma-delimited list of etcd endpoints.
#   Defaults to http://127.0.0.1:4001:
#
# [*etcd_prefix*]
#   etcd prefix.
#   Defaults to /coreos.com/network
#
# [*etcd_keyfile*]
#   SSL key file used to secure etcd communication.
#   Defaults to ""
#
# [*etcd_certfile*]
#   SSL certification file used to secure etcd communication.
#   Defaults to ""
#
# [*etcd_cafile*]
#   SSL Certificate Authority file used to secure etcd communication.
#   Defaults to ""
#
# [*iface*]
#   interface to use (IP or name) for inter-host communication.
#   Defaults to the interface for the default route on the machine.
#   Defaults to ""
#
# [*subnet_file*]
#   filename where env variables (subnet and MTU values) will be written to.
#   Defaults to /run/flannel/subnet.env
#
# [*ip_masq*]
#   setup IP masquerade for traffic destined for outside the flannel network.
#   Defaults to false
#
# [*listen*]
#   if specified, will run in server mode. Value is IP and port (e.g. `0.0.0.0:8888`) to
#   listen on or `fd://` for [socket activation](http://www.freedesktop.org/software/systemd/man/systemd.socket.html).
#   Defaults to ""
#
# [*remote*]
#   if specified, will run in client mode. Value is IP and port of the server.
#   Defaults to ""
#
# [*remote_keyfile*]
#   SSL key file used to secure client/server communication.
#   Defaults to ""
#
# [*remote_certfile*]
#   SSL certification file used to secure client/server communication.
#   Defaults to ""
#
# [*remote_cafile*]
#   SSL Certificate Authority file used to secure client/server communication.
#   Defaults to ""
#
# [*networks*]
#   if specified, will run in multi-network mode. Value is comma separate list of networks to join.
#   Defaults to ""
#
# [*configure_etcd*]
#   if we should use the etcd module to insert the etcd_key
#   Defaults to false
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

class flannel (
  $ensure          = $flannel::params::ensure,
  $service_state   = $flannel::params::service_state,
  $service_enable  = $flannel::params::service_enable,
  # flannel parameters
  $public_ip       = $flannel::params::public_ip,
  $etcd_endpoints  = $flannel::params::etcd_endpoints,
  $etcd_prefix     = $flannel::params::etcd_prefix,
  $etcd_keyfile    = $flannel::params::etcd_keyfile,
  $etcd_certfile   = $flannel::params::etcd_certfile,
  $etcd_cafile     = $flannel::params::etcd_cafile,
  $iface           = $flannel::params::iface,
  $subnet_file     = $flannel::params::subnet_file,
  $ip_masq         = $flannel::params::ip_masq,
  $listen          = $flannel::params::listen,
  $remote          = $flannel::params::remote,
  $remote_keyfile  = $flannel::params::remote_keyfile,
  $remote_certfile = $flannel::params::remote_certfile,
  $remote_cafile   = $flannel::params::remote_cafile,
  $networks        = $flannel::params::networks,
  # etcd network definition
  $configure_etcd  = $flannel::params::configure_etcd,
  $network         = $flannel::params::network,
  $subnetlen       = $flannel::params::subnetlen,
  $subnetmin       = $flannel::params::subnetmin,
  $subnetmax       = $flannel::params::subnetmax,
  $backend_type    = $flannel::params::backend_type,
  $backend_port    = $flannel::params::backend_port,
) inherits flannel::params {
  contain flannel::install
  contain flannel::config
  contain flannel::service

  Class['flannel::install'] ->
  Class['flannel::config'] ~>
  Class['flannel::service']
}
