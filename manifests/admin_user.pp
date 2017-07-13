class collabora::admin_user (
  $username,
  $password) {
  augeas{ "collabora_admin_user":
    incl => "/etc/loolwsd/loolwsd.xml",
    lens => "Xml.lns",
    context => "/files/etc/loolwsd/loolwsd.xml/config",
    changes => [
      "set admin_console/username/#text $username",
      "set admin_console/password/#text $password"
    ],
    notify => Service["loolwsd"]
  }

}
