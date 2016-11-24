# Takes care of starting flannel service
class flannel::service {
  service { 'flanneld':
    ensure => $::flannel::service_state,
    enable => $::flannel::service_enable,
  }
}
