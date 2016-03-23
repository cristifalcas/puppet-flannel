# configures flannel
class flannel::config {
  file { '/etc/sysconfig/flanneld':
    ensure  => file,
    content => template("${module_name}/sysconfig/flanneld.erb"),
    mode    => '0644',
  }

  if $flannel::manage_docker {
    $docker_dropin_ensure = 'file'
    include ::docker
    File['/usr/lib/systemd/system/docker.service.d/flannel.conf'] ~> Service['flanneld'] ~> Service['docker']
  } else {
    $docker_dropin_ensure = 'absent'
  }

  file { '/usr/lib/systemd/system/docker.service.d/flannel.conf':
    ensure  => $docker_dropin_ensure,
    content => template("${module_name}/service_flannel.conf"),
    mode    => '0644',
  } ~>
  exec { 'reload systemctl daemon for flannel':
    command     => '/bin/systemctl daemon-reload',
    refreshonly => true,
  }
}
