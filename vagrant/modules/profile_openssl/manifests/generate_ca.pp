define profile_openssl::generate_ca  (
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

    profile_openssl::self_signed_certificate { 'root':
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
      cert_email_address => $cert_email_address,
      key_path => $key_path,
      cert_path => $cert_path
    }

}
