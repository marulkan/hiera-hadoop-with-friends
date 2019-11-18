class hiera_hadoop::hive {
  if $hiera_hadoop::alternative_configuration_dir_for_client {
    class{ '::hive':
      group               => 'hive',
      metastore_hostname  => $hiera_hadoop::hdfs_hostname,
      realm               => $hiera_hadoop::realm,
      db                  => $hiera_hadoop::db_engine,
      db_password         => $hiera_hadoop::hive_db_password,
      zookeeper_hostnames => $hiera_hadoop::zookeeper_hostnames,
      properties          => $hiera_hadoop::hive_properties,
      keytab_source       => $hiera_hadoop::hive_keytab_source,
      confdir             => "${hiera_hadoop::alternative_configuration_dir_for_client}/hive",
    }
  }
  else {
    class{ '::hive':
      group               => 'hive',
      metastore_hostname  => $hiera_hadoop::hdfs_hostname,
      realm               => $hiera_hadoop::realm,
      db                  => $hiera_hadoop::db_engine,
      db_password         => $hiera_hadoop::hive_db_password,
      zookeeper_hostnames => $hiera_hadoop::zookeeper_hostnames,
      properties          => $hiera_hadoop::hive_properties,
      keytab_source       => $hiera_hadoop::hive_keytab_source,
    }
  }
  if $node_type == 'primary-master' {

    postgresql::server::db { 'metastore':
      user     => 'hive',
      password => postgresql_password('hive', $hiera_hadoop::hive_db_password),
    }
    ->
    exec { 'metastore-import':
      command => 'cat /usr/lib/hive/scripts/metastore/upgrade/postgres/hive-schema-0.14.0.postgres.sql | psql metastore && touch /var/lib/hive/.puppet-hive-schema-imported',
      path    => '/bin/:/usr/bin',
      user    => 'hive',
      creates => '/var/lib/hive/.puppet-hive-schema-imported',
    }
    Class['postgresql::lib::java'] -> Class['::hive::metastore::config']
    Class['::hive::metastore::install'] -> Postgresql::Server::Db['metastore']
    Postgresql::Server::Db['metastore'] -> Class['::hive::metastore::service']
    Exec['metastore-import'] -> Class['::hive::metastore::service']
    Class['::hadoop::namenode::service'] -> Class['::hive::metastore::service']
  }
}
