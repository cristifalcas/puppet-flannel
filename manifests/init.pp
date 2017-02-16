# Class: flannel
#
# installs, configures and starts the service for flannel.
#
# Parameters:
#
# [*ensure*]
#   Passed to the flannel package.
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
# [*manage_docker*]
#   Whether you want to keep /usr/lib/systemd/system/docker.service.d/flannel.conf
#   Defaults to true
#
## flanneld options
#
# [*public_ip*]
#   IP accessible by other nodes for inter-host communication.
#   Defaults to the IP of the interface being used for communication.
#
# [*etcd_endpoints*]
#   a comma-delimited list of etcd endpoints.
#   Type: Array or String
#   Defaults to http://127.0.0.1:4001
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
# [*subnet_lease_renew_margin*]
#   subnet lease renewal margin, in minutes.
#   Defaults to undef
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
# [*log_dir*]
#   If non-empty, write log files in this directory
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
# [*kube_subnet_mgr*]
#   The Kubernetes API server can now be used as a datastore instead of etcd. This makes deployment easier as flannel
#   no longer directly relies on the presence of an etcd server.
#   Defaults to undef
#
# [*journald_forward_enable*]
#   Enable log forwarding via journald_forward_enable
#
class flannel (
  $ensure                    = $flannel::params::ensure,
  $service_state             = $flannel::params::service_state,
  $service_enable            = $flannel::params::service_enable,
  # flannel parameters
  $manage_docker             = $flannel::params::manage_docker,
  $public_ip                 = $flannel::params::public_ip,
  $etcd_endpoints            = $flannel::params::etcd_endpoints,
  $etcd_prefix               = $flannel::params::etcd_prefix,
  $etcd_keyfile              = $flannel::params::etcd_keyfile,
  $etcd_certfile             = $flannel::params::etcd_certfile,
  $etcd_cafile               = $flannel::params::etcd_cafile,
  $iface                     = $flannel::params::iface,
  $subnet_lease_renew_margin = $flannel::params::subnet_lease_renew_margin,
  $subnet_file               = $flannel::params::subnet_file,
  $ip_masq                   = $flannel::params::ip_masq,
  $listen                    = $flannel::params::listen,
  $log_dir                   = $flannel::params::log_dir,
  $remote                    = $flannel::params::remote,
  $remote_keyfile            = $flannel::params::remote_keyfile,
  $remote_certfile           = $flannel::params::remote_certfile,
  $remote_cafile             = $flannel::params::remote_cafile,
  $networks                  = $flannel::params::networks,
  $kube_subnet_mgr           = $flannel::params::kube_subnet_mgr,
  $journald_forward_enable   = $flannel::params::journald_forward_enable,
) inherits flannel::params {
  validate_bool($service_enable, $manage_docker, $journald_forward_enable, $kube_subnet_mgr)

  contain '::flannel::install'
  contain '::flannel::config'
  contain '::flannel::service'

  Class['flannel::install'] ->
  Class['flannel::config'] ~>
  Class['flannel::service']
}
