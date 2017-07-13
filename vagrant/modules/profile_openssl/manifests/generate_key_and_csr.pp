define profile_openssl::generate_key_and_csr  (
  $csr_path=undef,
  $key_path=undef) {

  $openssl_cnf = "${::puppet_vardir}/openssl/${name}.cnf"

  exec { "openssl generate key ${key_path}":
    command => "/usr/bin/openssl genrsa -out ${key_path} 2048 -key ${key_path}",
    user => root,
    group => root,
  } ->
  exec { "openssl generate csr ${csr_path}":
    command => "/usr/bin/openssl req -key ${key_path} -new -sha256 -out ${csr_path} -subj \"/C=DE/ST=BW/L=Stuttgart/O=Dummy Authority/CN=localhost\"",
    user => root,
    group => root,
  }


}
