class hiera_hadoop::hue {
  include ::hue::hdfs
  class{ '::hue':
    defaultFS               => "hdfs://${hiera_hadoop::cluster_name}",
    httpfs_hostname         => $hiera_hadoop::hue_hostname,
    yarn_hostname           => $hiera_hadoop::yarn_hostname,
    yarn_hostname2          => $hiera_hadoop::yarn_hostname2,
    hive_server2_hostname   => $hiera_hadoop::hdfs_hostname,
    secret                  => $hiera_hadoop::hue_secret,
    db                      => $hiera_hadoop::db_engine,
    db_password             => $hiera_hadoop::hue_db_password,
    realm                   => $hiera_hadoop::realm,
    https                   => $hiera_hadoop::hue_https,
    https_cachain           => $hiera_hadoop::hue_https_cachain,
    https_certificate       => $hiera_hadoop::hue_https_certificate,
    https_private_key       => $hiera_hadoop::hue_https_private_key,
    https_passphrase        => $hiera_hadoop::hue_https_passphrase,
    sentry_hostname         => $hiera_hadoop::hdfs_hostname,
    impala_hostname         => $hiera_hadoop::hdfs_hostname,
    auth                    => $hiera_hadoop::hue_auth,
    auth_ldap_base_dn       => $hiera_hadoop::hue_auth_ldap_base_dn,
    auth_ldap_bind_dn       => $hiera_hadoop::hue_auth_ldap_bind_dn,
    auth_ldap_bind_password => $hiera_hadoop::hue_auth_ldap_bind_password,
    auth_ldap_url           => $hiera_hadoop::hue_auth_ldap_url,
    auth_ldap_nt_domain     => $hiera_hadoop::hue_auth_ldap_nt_domain,
    auth_ldap_login_groups  => $hiera_hadoop::hue_auth_ldap_login_groups,
    keytab_source           => $hiera_hadoop::hue_keytab_source,
  }

  postgresql::server::db { 'hue':
    user     => 'hue',
    password => postgresql_password('hue', $hiera_hadoop::hue_db_password),
  }

  Postgresql::Server::Db['hue'] -> Class['hue::service']
}
