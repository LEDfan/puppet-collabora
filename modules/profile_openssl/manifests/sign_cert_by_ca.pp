define profile_openssl::sign_cert_by_ca  (
  $cert_days,
  $csr_path=undef,
  $cert_path=undef,
  $ca_key_path=undef,
  $ca_cert_path=undef) {

  $openssl_cnf = "${::puppet_vardir}/openssl/${name}.cnf"

  exec { "openssl req-self-signed-x509 ${cert}":
    command => "/usr/bin/openssl x509 -req -in ${csr_path} -CA ${ca_cert_path} -CAkey ${ca_key_path} -CAcreateserial -out ${cert_path} -days ${cert_days}",
    #onlyif => "/usr/bin/test ${cert} -ot ${openssl_cnf} -o ${cert} -ot ${key}",
    #require => [Package["openssl"], File[$openssl_cnf], File[$key]],
    #subscribe => [File[$openssl_cnf], File[$key]],
    user => root,
    group => root,
  }


}
