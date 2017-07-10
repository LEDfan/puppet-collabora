class collabora::storage_backend (
  $type,
  $wopi_host=undef,
  $webdav_host=undef) {
    validate_re($type, '^(filesystem|wopi|webdav)$', "${type} is not supported for ensure. Allowed values are 'filesystem', 'wopi' and 'webdav'.")


    if ($type == "filesystem") {
      augeas{ "collabora_storage_filesystem":
        incl => "/etc/loolwsd/loolwsd.xml",
        lens => "Xml.lns",
        context => "/files/etc/loolwsd/loolwsd.xml/config",
        changes => [
          "set storage/filesystem/#attribute/allow true",
          "set storage/wopi/#attribute/allow false",
          "set storage/webdav/#attribute/allow false",
        ],
        notify => Service["loolwsd"]
      }
    } elsif ($type == "wopi") {
      augeas{ "collabora_storage_filesystem":
        incl => "/etc/loolwsd/loolwsd.xml",
        lens => "Xml.lns",
        context => "/files/etc/loolwsd/loolwsd.xml/config",
        changes => [
          "set storage/filesystem/#attribute/allow false",
          "set storage/wopi/#attribute/allow true",
          "rm  storage/wopi/host",
          "set storage/wopi/host/#attribute/allow true",
          "set storage/wopi/host/#text $wopi_host",
          "set storage/webdav/#attribute/allow false",
        ],
        notify => Service["loolwsd"]
      }
    } elsif ($type == "webdav") {
      augeas{ "collabora_storage_filesystem":
        incl => "/etc/loolwsd/loolwsd.xml",
        lens => "Xml.lns",
        context => "/files/etc/loolwsd/loolwsd.xml/config",
        changes => [
          "set storage/filesystem/#attribute/allow false",
          "set storage/wopi/#attribute/allow false",
          "set storage/webdav/#attribute/allow true",
          "set storage/webdav/host/#text $webdav_host",
          "set storage/webdav/host/#attribute/allow true",
        ],
        notify => Service["loolwsd"]
      }
    }
}
