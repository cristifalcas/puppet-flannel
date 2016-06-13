# flannel #
[![Build Status](https://travis-ci.org/cristifalcas/puppet-flannel.png?branch=master)](https://travis-ci.org/cristifalcas/puppet-flannel)

This module installs and configures flannel.


## Usage: ##

    include etcd
    include flannel

Or:

    class { 'flannel':
      etcd_endpoints => "http://${::fqdn}:2379",
      etcd_prefix    => '/coreos.com/network',
      network        => '172.16.0.0/16',
    }

Or using certificates:

	  class { '::etcd':
	    ensure                      => 'latest',
	    etcd_name                   => $::hostname,
	    # clients
	    listen_client_urls          => 'https://0.0.0.0:2379',
	    advertise_client_urls       => "https://${::fqdn}:2379",
	    # clients ssl
	    cert_file                   => '/etc/pki/puppet_certs/etcd/public_cert.pem',
	    key_file                    => '/etc/pki/puppet_certs/etcd/private_cert.pem',
	    trusted_ca_file             => '/etc/pki/puppet_certs/etcd/ca_cert.pem',
	    # authorize clients
	    client_cert_auth            => true,
	    # cluster
	    initial_cluster             => $initial_cluster,
	    listen_peer_urls            => 'https://0.0.0.0:7001',
	    initial_advertise_peer_urls => "https://${::fqdn}:7001",
	    # peers ssl
	    peer_cert_file              => '/etc/pki/puppet_certs/etcd/public_cert.pem',
	    peer_key_file               => '/etc/pki/puppet_certs/etcd/private_cert.pem',
	    peer_trusted_ca_file        => '/etc/pki/puppet_certs/etcd/ca_cert.pem',
	    # authorize peers
	    peer_client_cert_auth       => true,
	  }

## Journald forward:

The class support a parameter called journald_forward_enable.

This was added because of the PIPE signal that is sent to go programs when systemd-journald dies.

For more information read here: https://github.com/projectatomic/forward-journald
