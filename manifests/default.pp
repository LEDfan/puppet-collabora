#include apache

#include ::collectd

file { "/tmp/unlimited-loolwsd-2.1.2-6.el7.centos.x86_64.rpm":
  ensure => present,
  source => ['puppet:///modules/collabora/unlimited-loolwsd-2.1.2-6.el7.centos.x86_64.rpm']
}

yumrepo { 'collabora_online':
  descr => "Collabora online repo",
  enabled => '1',
  gpgcheck => '1',
  gpgkey => 'https://www.collaboraoffice.com/repos/CollaboraOnline/CODE-centos7/repodata/repomd.xml.key',
  baseurl => 'https://www.collaboraoffice.com/repos/CollaboraOnline/CODE-centos7/'
}->
yum::install { 'loolwsd':
  ensure => present,
  source => '/tmp/unlimited-loolwsd-2.1.2-6.el7.centos.x86_64.rpm',
}->
package { 'CODE-brand':
  ensure => present
}

service { 'loolwsd':
  name => 'loolwsd',
  ensure => running,
  enable => true
}
