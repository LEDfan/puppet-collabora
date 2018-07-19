class collabora::vhost (
  $servername,
  $certfile,
  $keyfile,
  $serveraliases = [],
  $setup_ssl) {
  if ($setup_ssl) {
    file { '/etc/httpd/conf.d/collabora_80.conf':
      path    => '/etc/httpd/conf.d/collabora_80.conf',
      ensure  => file,
      notify  => Service['httpd'],
      content => template('collabora/collabora-vhots_80-ssl.conf.erb'),
    }
    file { '/etc/httpd/conf.d/collabora_443.conf':
      path    => '/etc/httpd/conf.d/collabora_443.conf',
      ensure  => file,
      notify  => Service['httpd'],
      content => template('collabora/collabora-vhots_443-ssl.conf.erb'),
    }
  } else {
    file { '/etc/httpd/conf.d/collabora_80.conf':
      path    => '/etc/httpd/conf.d/collabora_80.conf',
      ensure  => file,
      notify  => Service['httpd'],
      content => template('collabora/collabora-vhots_80.conf.erb'),
    }
  }
}
