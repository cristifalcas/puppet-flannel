# Installs default flannel packages
class flannel::install {
  package { [$::flannel::package_name]: ensure => $::flannel::ensure, }
}
