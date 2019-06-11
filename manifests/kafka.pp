class hiera_hadoop::kafka {
  include ::stdlib

  class{ '::kafka':
    hostnames                => $hiera_hadoop::kafka_brokers,
    zookeeper_hostnames      => $hiera_hadoop::zookeeper_hostnames,
    realm                    => $hiera_hadoop::realm,
    ssl                      => $hiera_hadoop::https,
    ssl_cacerts              => $hiera_hadoop::https_cacerts,
    ssl_cacerts_password     => $hiera_hadoop::https_cacerts_password,
    ssl_keystore             => $hiera_hadoop::https_keystore,
    ssl_keystore_password    => $hiera_hadoop::https_keystore_password,
    ssl_keystore_keypassword => $hiera_hadoop::https_keystore_keypassword,
    log_dirs                 => $hiera_hadoop::kafka_log_dirs,
    properties               => $hiera_hadoop::kafka_properties,
    sentry_enable            => $hiera_hadoop::kafka_sentry_enabled,
    package_name             => $hiera_hadoop::kafka_package_name,
    keytab                   => $hiera_hadoop::kafka_keytab,
    keytab_source            => $hiera_hadoop::kafka_keytab_source,
  }
}
