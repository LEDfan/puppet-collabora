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
    #command => "/usr/bin/openssl req -config ${openssl_cnf} -new -batch -x509 -nodes -days ${cert_days} -out ${cert} --in ${csr_path} -CA ${ca_cert_path} -CAkey ${ca_key_path} -CAcreateserial",
    #onlyif => "/usr/bin/test ${cert} -ot ${openssl_cnf} -o ${cert} -ot ${key}",
    #require => [Package["openssl"], File[$openssl_cnf], File[$key]],
    #subscribe => [File[$openssl_cnf], File[$key]],
    user => root,
    group => root,
  }


}
