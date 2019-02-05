class hiera_hadoop::sentry {
  class{'::sentry':
    db            => $hiera_hadoop::db_engine,
    db_password   => $hiera_hadoop::sentry_db_password,
    realm         => $hiera_hadoop::realm,
    admin_groups  => [ 'sentry', 'hive', 'impala', 'hue', 'selnhubadm' ],
    properties    => $hiera_hadoop::sentry_properties,
    keytab_source => $hiera_hadoop::sentry_keytab_source,
  }

  include ::sentry
  include ::sentry::client
  include ::sentry::server

  postgresql::server::db { 'sentry':
    user     => 'sentry',
    password => postgresql_password('sentry', $hiera_hadoop::sentry_db_password),
  }

  Class['postgresql::lib::java'] -> Class['::sentry::server::config']
  Postgresql::Server::Db['sentry'] -> Class['::sentry::server::config']
}
