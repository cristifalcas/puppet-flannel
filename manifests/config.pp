# configures flannel
class flannel::config {
  file { '/etc/sysconfig/flanneld':
    ensure  => file,
    content => template("${module_name}/sysconfig/flanneld.erb"),
    mode    => '0644',
  }

  if $flannel::configure_etcd {
    if $flannel::etcd_keyfile and $flannel::etcd_certfile and $flannel::etcd_cafile {
      $key = $flannel::etcd_keyfile
      $cert = $flannel::etcd_certfile
      $ca = $flannel::etcd_cafile
    } else {
      $key = undef
      $cert = undef
      $ca = undef
    }

    #    $local_subnetlen
    #    if $subnetlen {
    #      $local_subnetlen = "\"SubnetLen\": ${$flannel::subnetlen},"
    #    }else {
    # $local_subnetlen = ''
    #    }
    # "{
    #    "Network": "${$flannel::network}",
    #
    #    "SubnetMin": "10.10.0.0",
    #    "SubnetMax": "10.99.0.0",
    #    "Backend": {
    #        "Type": "udp",
    #        "Port": 7890
    #    }
    # }"
    etcd_key { $flannel::etcd_prefix:
      value     => template("${module_name}/etcd_network_definition.erb"),
      peers     => $flannel::etcd_endpoints,
      cert_file => $cert,
      key_file  => $key,
      ca_file   => $ca,
    }
  }
}
