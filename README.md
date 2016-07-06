# flannel #
[![Build Status](https://travis-ci.org/cristifalcas/puppet-flannel.png?branch=master)](https://travis-ci.org/cristifalcas/puppet-flannel)

This module installs and configures flannel.


## Usage: ##

    include flannel

Or:

    class { 'flannel':
      etcd_endpoints => "http://${::fqdn}:2379",
      etcd_prefix    => '/coreos.com/network',
    }

Or using certificates:

	  class { '::etcd':
	    ensure                      => 'latest',
	    etcd_name                   => $::hostname,
	    # clients
	    listen_client_urls          => 'https://0.0.0.0:2379',
	    advertise_client_urls       => "https://${::fqdn}:2379",
	    # clients ssl
	    cert_file                   => "${::settings::ssldir}/certs/${::clientcert}.pem",
	    key_file                    => "${::settings::ssldir}/private_keys/${::clientcert}.pem",
	    trusted_ca_file             => "${::settings::ssldir}/certs/ca.pem",
	    # authorize clients
	    client_cert_auth            => true,
	    # cluster
	    initial_cluster             => $initial_cluster,
	    listen_peer_urls            => 'https://0.0.0.0:7001',
	    initial_advertise_peer_urls => "https://${::fqdn}:7001",
	    # peers ssl
	    peer_cert_file              => "${::settings::ssldir}/certs/${::clientcert}.pem",
	    peer_key_file               => "${::settings::ssldir}/private_keys/${::clientcert}.pem",
	    peer_trusted_ca_file        => "${::settings::ssldir}/certs/ca.pem",
	    # authorize peers
	    peer_client_cert_auth       => true,
	  }

	  class { '::flannel':
	    ensure         => 'latest',
	    etcd_endpoints => "http://${::fqdn}:2379",
	    etcd_keyfile   => "${::settings::ssldir}/private_keys/${::clientcert}.pem",
	    etcd_certfile  => "${::settings::ssldir}/certs/${::clientcert}.pem",
	    etcd_cafile    => "${::settings::ssldir}/certs/ca.pem",
	    etcd_prefix    => '/coreos.com/network',
	  }

## Create the etcd node:

	  	class { '::flannel::etcd_key':
	  		network   => '172.16.0.0/16',
    		subnetmin => '172.16.100.0',
  		}

## Journald forward:

The class support a parameter called journald_forward_enable.

This was added because of the PIPE signal that is sent to go programs when systemd-journald dies.

For more information read here: https://github.com/projectatomic/forward-journald

### Usage:

	  include ::forward_journald
	  Class['forward_journald'] -> Class['flannel']
