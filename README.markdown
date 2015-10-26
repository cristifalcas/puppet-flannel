# kubernetes #

This module installs and configures flannel.



Usage:

    include etcd
    include flannel

Or:

    class { 'flannel':
      etcd_endpoints => "http://${::fqdn}:2379",
      etcd_prefix    => '/coreos.com/network',
      configure_etcd => true,
      network        => '172.16.0.0/16',
    }
