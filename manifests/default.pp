#include apache

#include ::collectd

file { "/tmp/unlimited-loolwsd-2.1.2-6.el7.centos.x86_64.rpm":
  ensure => present,
  source => ['puppet:///modules/collabora/unlimited-loolwsd-2.1.2-6.el7.centos.x86_64.rpm']
}->
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
->
class {'openssl::setup':
}->
file { '/etc/loolwsd':
  ensure => directory
}->
profile_openssl::generate_ca { collabora:
  key_bits => 2048,
  cert_days => 365,
  cert_country => BE,
  cert_state => BE,
  cert_organization => Foobar,
  cert_common_names => ["collabora.local"],
  cert_email_address => "admin@collabora.local",
  key_path => '/etc/loolwsd/ca-private.key.pem',
  cert_path => '/etc/loolwsd/ca-chain.cert.pem'
}->
profile_openssl::generate_key_and_csr { collabora:
  key_path => '/etc/loolwsd/key.pem',
  csr_path => '/etc/loolwsd/csr.pem'
}->
profile_openssl::sign_cert_by_ca { collabora:
  #key_path => '/etc/loolwsd/key.pem',
  cert_path => '/etc/loolwsd/cert.pem',
  csr_path => '/etc/loolwsd/csr.pem',
  ca_key_path => '/etc/loolwsd/ca-private.key.pem',
  ca_cert_path => '/etc/loolwsd/ca-chain.cert.pem',
  cert_days => 365
}

service { 'loolwsd':
  name => 'loolwsd',
  ensure => running,
  enable => true
}
