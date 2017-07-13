class collabora::vhost (
  $servername,
  $certfile,
  $keyfile) {
  file { '/etc/httpd/conf.d/collabora.conf':
    path    => '/etc/httpd/conf.d/collabora.conf',
    ensure  => file,
    notify  => Service['httpd'],
    content => template('collabora/collabora-vhots.conf.erb'),
  }
}
