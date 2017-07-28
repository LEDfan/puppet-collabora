class collabora::vhost (
  $servername,
  $certfile,
  $keyfile,
  $serveraliases = []) {
  file { '/etc/httpd/conf.d/collabora_80.conf':
    path    => '/etc/httpd/conf.d/collabora_80.conf',
    ensure  => file,
    notify  => Service['httpd'],
    content => template('collabora/collabora-vhots_80.conf.erb'),
  }
  file { '/etc/httpd/conf.d/collabora_443.conf':
    path    => '/etc/httpd/conf.d/collabora_443.conf',
    ensure  => file,
    notify  => Service['httpd'],
    content => template('collabora/collabora-vhots_443.conf.erb'),
  }
}
