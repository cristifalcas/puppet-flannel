# Installs default flannel packages
class flannel::install {
  package { ['flanneld',]: ensure => $flannel::ensure, }
}
