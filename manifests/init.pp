# class collabora
class collabora (
  $servername,
  $admin_username,
  $admin_password,
  $manage_repos    = true,
  $storage_backend = 'filesystem',
  $wopi_host       = undef,
  $webdav_host     = undef,
  $manage_ca       = true,
  $ca_key_file     = undef,
  $ca_cert_file    = undef,
  $serveraliases   = [],
  $manage_vhost    = true){
  if ($manage_repos) {
    file { '/tmp/unlimited-loolwsd-2.1.2-6.el7.centos.x86_64.rpm':
      ensure => present,
      source => ['puppet:///modules/collabora/unlimited-loolwsd-2.1.2-6.el7.centos.x86_64.rpm'],
    }->
    yumrepo { 'collabora_online':
      descr    => 'Collabora online repo',
      enabled  => '1',
      gpgcheck => '1',
      gpgkey   => 'https://www.collaboraoffice.com/repos/CollaboraOnline/CODE-centos7/repodata/repomd.xml.key',
      baseurl  => 'https://www.collaboraoffice.com/repos/CollaboraOnline/CODE-centos7/'
    }->
    yum::install { 'loolwsd':
      ensure  => present,
      source  => '/tmp/unlimited-loolwsd-2.1.2-6.el7.centos.x86_64.rpm',
      timeout =>  0
    }
    Yum::Install['loolwsd']->Package['CODE-brand']
  } else {
    package { 'loolwsd':
      ensure => installed,
    }
    Package['loolwsd']->Package['CODE-brand']
  }

  if ($manage_ca) {
    profile_openssl::generate_ca { 'collabora':
      key_bits           => 2048,
      cert_days          => 365,
      cert_country       => 'BE',
      cert_state         => 'BE',
      cert_organization  => 'Foobar',
      cert_common_names  => [$servername],
      cert_email_address => "admin@${servername}",
      key_path           => '/etc/loolwsd/ca-private.key.pem',
      cert_path          => '/etc/loolwsd/ca-chain.cert.pem'
    }
    Profile_openssl::Generate_ca['collabora']->Profile_openssl::Generate_key_and_csr['collabora']
    Profile_openssl::Generate_ca['collabora']->Profile_openssl::Generate_key_and_csr['apache']
  } else {
    file { '/etc/loolwsd/ca-private.key.pem':
      ensure  => present,
      content => $ca_key_file
    }
    file { '/etc/loolwsd/ca-chain.cert.pem':
      ensure  => present,
      content => $ca_cert_file
    }
    File['/etc/loolwsd/ca-chain.cert.pem']->Profile_openssl::Generate_key_and_csr['collabora']
    File['/etc/loolwsd/ca-private.key.pem']->Profile_openssl::Generate_key_and_csr['collabora']
    File['/etc/loolwsd/ca-chain.cert.pem']->Profile_openssl::Generate_key_and_csr['apache']
    File['/etc/loolwsd/ca-private.key.pem']->Profile_openssl::Generate_key_and_csr['apache']
  }

  package { 'CODE-brand':
    ensure => present
  }->
  file { '/etc/loolwsd':
    ensure => directory
  }->
  profile_openssl::generate_key_and_csr { 'collabora':
    key_path => '/etc/loolwsd/key.pem',
    csr_path => '/etc/loolwsd/csr.pem'
  }->
  profile_openssl::sign_cert_by_ca { 'collabora':
    cert_path    => '/etc/loolwsd/cert.pem',
    csr_path     => '/etc/loolwsd/csr.pem',
    ca_key_path  => '/etc/loolwsd/ca-private.key.pem',
    ca_cert_path => '/etc/loolwsd/ca-chain.cert.pem',
    cert_days    => 365
  }

  service { 'loolwsd':
    ensure => running,
    name   => 'loolwsd',
    enable => true
  }

  include ::apache
  include ::apache::mod::ssl
  include ::apache::mod::proxy
  include ::apache::mod::proxy_http
  include ::apache::mod::proxy_wstunnel
  ::apache::listen { '443': }

  file { ['/etc/httpd', '/etc/httpd/certs']:
    ensure  => directory,
  }->
  profile_openssl::generate_key_and_csr { 'apache':
    common_name => $servername,
    key_path    => '/etc/httpd/certs/collabora.key.pem',
    csr_path    => '/etc/httpd/certs/collabora.csr.pem',
  }->
  profile_openssl::sign_cert_by_ca { 'apache':
    cert_path    => '/etc/httpd/certs/collabora.cert.pem',
    csr_path     => '/etc/httpd/certs/collabora.csr.pem',
    ca_key_path  => '/etc/loolwsd/ca-private.key.pem',
    ca_cert_path => '/etc/loolwsd/ca-chain.cert.pem',
    cert_days    => 365,
    notify       => Service['httpd'],
  }->
  class {'collabora::admin_user':
    username => $admin_username,
    password => $admin_password
  }->
  class {'collabora::storage_backend':
    type        => $storage_backend,
    wopi_host   => $wopi_host,
    webdav_host => $webdav_host
  }

  if ($manage_vhost) {
    class {'collabora::vhost':
      servername    => $servername,
      certfile      => '/etc/httpd/certs/collabora.cert.pem',
      keyfile       => '/etc/httpd/certs/collabora.key.pem',
      serveraliases => $serveraliases,
    }
  }

  if !defined(Class['firewall']) {
    class { 'firewall':
    }
    Class['firewall']->Firewall['21 - collabora-firewal-443-port']
  }
  firewall { '21 - collabora-firewal-443-port':
    dport  => '443',
    action => 'accept',
  }

}
