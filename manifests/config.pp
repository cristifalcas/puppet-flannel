# configures flannel
class flannel::config {
  if $::osfamily == 'Debian' {
    file { '/etc/flanneld':
      ensure => directory,
      mode   => '0755',
    }

    file { '/etc/flanneld/flanneld.conf':
      ensure  => file,
      content => template("${module_name}/sysconfig/flanneld.erb"),
      mode    => '0644',
    }

    file { '/etc/default/flanneld':
      ensure  => file,
      content => template("${module_name}/default/flanneld.erb"),
      mode    => '0644',
    }
  } elsif $::osfamily == 'RedHat' {
    file { '/etc/sysconfig/flanneld':
      ensure  => file,
      content => template("${module_name}/sysconfig/flanneld.erb"),
      mode    => '0644',
    }

    if $::operatingsystemmajrelease == 7 {
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

      if $flannel::journald_forward_enable {
        file { '/etc/systemd/system/flanneld.service.d':
          ensure => 'directory',
          owner  => 'root',
          group  => 'root',
          mode   => '0755',
        }
        file { '/etc/systemd/system/flanneld.service.d/journald.conf':
          ensure  => file,
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          content => template("${module_name}/journald.conf.erb"),
        } ~>
        Exec['reload systemctl daemon for flannel']
      }
    }
  } else {
    fail("Unsupported OS: ${::osfamily}")
  }
}
