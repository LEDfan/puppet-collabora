define profile_openssl::self_signed_certificate  (
  $key_bits=1024,
  $key_owner="root",
  $key_group="root",
  $key_mode="0600",
  $cert_days=365,
  $cert_country=undef,
  $cert_state=undef,
  $cert_locality=undef,
  $cert_organization=undef,
  $cert_common_names=[],
  $cert_email_address=undef,
  $key_path=undef,
  $cert_path=undef) {

  openssl::self_signed_certificate { $title:
    key_bits => $key_bits,
    key_owner => $key_owner,
    key_group => $key_group,
    key_mode => $key_mode,
    cert_days => $cert_days,
    cert_country => $cert_country,
    cert_state => $cert_state,
    cert_locality => $cert_locality,
    cert_organization => $cert_organization,
    cert_common_names => $cert_common_names,
    cert_email_address => $cert_email_address
  }


  $orginial_key_path = "/etc/ssl/private/${name}.key"
  $original_cert_path = "/etc/ssl/${name}.pem"

  if ($key_path) {
    file { $key_path:
      require => Openssl::Self_signed_certificate[$title],
      owner => $key_owner,
      group => $key_group,
      mode => $key_mode,
      source => $orginial_key_path
    }
  }
  if ($cert_path) {
    file { $cert_path:
      require => Openssl::Self_signed_certificate[$title],
      owner => root,
      group => root,
      mode => "0644",
      source => $original_cert_path
    }
  }

}
