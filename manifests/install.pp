# Installs default flannel packages
class flannel::install {
  package { ['flannel',]: ensure => $flannel::ensure, }
}
