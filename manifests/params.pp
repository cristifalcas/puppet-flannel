# Default parameters for flannel module
class flannel::params {
  $ensure = 'present'
  $service_state = 'running'
  $service_enable = true

  if $::osfamily == 'Debian' {
    $package_name = 'flanneld'
  } elsif $::osfamily == 'RedHat' {
    $package_name = 'flannel'
  } else {
    fail("Unsupported OS: ${::osfamily}")
  }

  $etcd_endpoints = 'http://127.0.0.1:4001'
  $etcd_prefix = '/coreos.com/network'
  $etcd_cafile = undef
  $etcd_certfile = undef
  $etcd_keyfile = undef
  $manage_docker = true
  $alsologtostderr = false
  $public_ip = undef
  $iface = undef
  $subnet_dir = '/run/flannel/networks'
  $subnet_file = '/run/flannel/subnet.env'
  $ip_masq = false
  $listen = undef
  $log_dir = undef
  $remote = undef
  $remote_keyfile = undef
  $remote_certfile = undef
  $remote_cafile = undef
  $networks = undef

  $journald_forward_enable = false
}
