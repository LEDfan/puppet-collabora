class profile_openssl::setup {
  file { "/etc/ssl/private":
    ensure => directory,
  }
}
