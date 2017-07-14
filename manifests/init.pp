# class collabora
class collabora (
  $servername,
  $manage_repos = true,
  $storage_backend = 'filesystem',
  $wopi_host    = undef,
  $webdav_host  = undef,
  ){
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
  package { 'CODE-brand':
    ensure => present
  }->
  file { '/etc/loolwsd':
    ensure => directory
  }->
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

  class { 'apache': }
  class { 'apache::mod::ssl': }
  class { 'apache::mod::proxy': }
  class { 'apache::mod::proxy_http': }
  class { 'apache::mod::proxy_wstunnel': }
  apache::listen { '443': }

  file { ['/etc/httpd', '/etc/httpd/certs']:
    ensure  => directory,
  }->
  profile_openssl::self_signed_certificate { 'collabora':
    key_owner         => 'root',
    key_group         => 'root',
    key_mode          => '0600',
    cert_country      => 'BE',
    cert_state        => 'BE',
    cert_common_names => [$servername],
    key_path          => '/etc/httpd/certs/collabora.key',
    cert_path         => '/etc/httpd/certs/collabora.cert',
    notify            => Service['httpd'],
  }->
  class {'collabora::admin_user':
    username => 'admin',
    password => 'admin'
  }->
  class {'collabora::storage_backend':
    type        => $storage_backend,
    wopi_host   => $wopi_host,
    webdav_host => $webdav_host
  }

  class {'collabora::vhost':
    servername => $servername,
    certfile   => '/etc/httpd/certs/collabora.cert',
    keyfile    => '/etc/httpd/certs/collabora.key'
  }

  package { 'iptables-services':
    ensure  => installed,
  }->
  firewall{'015 httpd':
    dport  => '443',
    action => 'accept',
  }

}
