class hiera-hadoop (
  $packages_common             = [ ],
  $hdfs_hostname               = undef,
  $hdfs_hostname2              = undef,
  $yarn_hostname               = undef,
  $yarn_hostname2              = undef,
  $historyserver_hostname      = undef,
  $httpfs_hostnames            = [ ],
  $slaves                      = [ ],
  $frontends                   = [ ],
  $journalnode_hostnames       = [ ],
  $zookeeper_hostnames         = [ ],
  $cluster_name                = undef,
  $realm                       = undef,
  $node_type                   = undef,

  $https                       = undef,
  $https_cacerts               = '/etc/security/cacerts',
  $https_cacerts_password      = '',
  $https_keystore              = '/etc/security/server.keystore',
  $https_keystore_password     = 'changeit',
  $https_keystore_keypassword  = undef,

  $hdfs_data_dirs              = ['/var/lib/hadoop-hdfs'],

  $hdfs_deployed               = true,
  $zookeeper_deployed          = true,

  $db_engine                   = '',
  $postgres_password           = '',

  $hue_hostname                = '',
  $hue_secret                  = '',
  $hue_db_password             = '',
  $hue_https                   = false,
  $hue_https_cachain           = undef,
  $hue_https_certificate       = '/etc/grid-security/hostcert.pem',
  $hue_https_private_key       = '/etc/grid-security/hostkey.pem',
  $hue_https_passphrase        = undef,
  $hue_auth = undef,
  $hue_auth_ldap_base_dn       = 'DC=mycompany,DC=com',
  $hue_auth_ldap_bind_dn       = 'CN=ServiceAccount,DC=mycompany,DC=com',
  $hue_auth_ldap_bind_password = undef,
  $hue_auth_ldap_url           = 'ldap://auth.mycompany.com',
  $hue_auth_ldap_nt_domain     = 'mycompany.com',
  $hue_auth_ldap_login_groups  = undef,

  $impala_https                = false,
  $impala_https_cachain        = '/etc/grid-security/ca-chain.pem',
  $impala_https_certificate    = '/etc/grid-security/hostcert.pem',
  $impala_https_private_key    = '/etc/grid-security/hostkey.pem',

  $sentry_db_password          = '',
  $hive_db_password            = '',
  $hadoop_properties           = {},
  $sentry_properties           = {},
  $hive_properties             = {},
  $hue_properties              = {},
  $impala_params               = {
    catalog                  => {
      'sentry_config'      => '/etc/sentry/conf/sentry-site.xml',
    },
    server                             => {
      'authorized_proxy_user_config' => '\'hue=*\'',
      'server_name'                  => 'server1',
      'sentry_config'                => '/etc/sentry/conf/sentry-site.xml',
    },
    statestore               => {
    },
  },

  $knox_keytab      = '/etc/security/keytab/knox.service.keytab',
  $spark_keytab     = '/etc/security/keytab/spark.service.keytab',

  $impala_keytab_source    = undef,
  $hive_keytab_source      = undef,
  $hue_keytab_source       = undef,
  $knox_keytab_source      = undef,
  $sentry_keytab_source    = undef,
  $spark_keytab_source     = undef,
  $zookeeper_keytab_source = undef,

  $hadoop_datanode_keytab_source        = undef,
  $hadoop_httpfs_keytab_source          = undef,
  $hadoop_jobhistory_keytab_source      = undef,
  $hadoop_journalnode_keytab_source     = undef,
  $hadoop_namenode_keytab_source        = undef,
  $hadoop_nfs_keytab_source             = undef,
  $hadoop_nodemanager_keytab_source     = undef,
  $hadoop_resourcemanager_keytab_source = undef,
  $hadoop_http_keytab_source            = undef,

  $alternative_configuration_dir_for_client = undef,

) {

  if $alternative_configuration_dir_for_client {
      class{ 'hadoop': 
        hdfs_hostname               => $hdfs_hostname,
        hdfs_hostname2              => $hdfs_hostname2,
        yarn_hostname               => $yarn_hostname ,
        yarn_hostname2              => $yarn_hostname2,
        historyserver_hostname      => $historyserver_hostname,
        httpfs_hostnames            => $httpfs_hostnames,
        slaves                      => $slaves,
        frontends                   => $frontends,
        journalnode_hostnames       => $journalnode_hostnames,
        zookeeper_hostnames         => $zookeeper_hostnames,
        cluster_name                => $cluster_name,
        realm                       => $realm,

        https                       => $https,
        https_cacerts               => $https_cacerts,
        https_cacerts_password      => $https_cacerts_password,
        https_keystore              => $https_keystore,
        https_keystore_password     => $https_keystore_password,
        https_keystore_keypassword  => $https_keystore_keypassword,

        hdfs_data_dirs              => $hdfs_data_dirs,

        hdfs_deployed               => $hdfs_deployed,
        zookeeper_deployed          => $zookeeper_deployed,

        hue_hostnames               => [$hue_hostname],
        properties                  => $hadoop_properties,

        keytab_source_datanode        => $hadoop_datanode_keytab_source,
        keytab_source_httpfs          => $hadoop_httpfs_keytab_source,
        keytab_source_jobhistory      => $hadoop_jobhistory_keytab_source,
        keytab_source_journalnode     => $hadoop_journalnode_keytab_source,
        keytab_source_namenode        => $hadoop_namenode_keytab_source,
        keytab_source_nfs             => $hadoop_nfs_keytab_source,
        keytab_source_nodemanager     => $hadoop_nodemanager_keytab_source,
        keytab_source_resourcemanager => $hadoop_resourcemanager_keytab_source,
        keytab_source_http            => $hadoop_http_keytab_source,

        confdir => "${alternative_configuration_dir_for_client}/hadoop",
      }

      class{ 'hive':
          group               => 'hive',
          metastore_hostname  => $hdfs_hostname,
          realm               => $realm,
          db                  => $db_engine,
          db_password         => $hive_db_password,
          sentry_hostname     => $hdfs_hostname,
          zookeeper_hostnames => $zookeeper_hostnames,
          properties          => $hive_properties,
          keytab_source       => $hive_keytab_source,
          confdir             => "${alternative_configuration_dir_for_client}/hive",
      }
  } else {
      class{ 'hadoop': 
        hdfs_hostname               => $hdfs_hostname,
        hdfs_hostname2              => $hdfs_hostname2,
        yarn_hostname               => $yarn_hostname ,
        yarn_hostname2              => $yarn_hostname2,
        historyserver_hostname      => $historyserver_hostname,
        httpfs_hostnames            => $httpfs_hostnames,
        slaves                      => $slaves,
        frontends                   => $frontends,
        journalnode_hostnames       => $journalnode_hostnames,
        zookeeper_hostnames         => $zookeeper_hostnames,
        cluster_name                => $cluster_name,
        realm                       => $realm,

        https                       => $https,
        https_cacerts               => $https_cacerts,
        https_cacerts_password      => $https_cacerts_password,
        https_keystore              => $https_keystore,
        https_keystore_password     => $https_keystore_password,
        https_keystore_keypassword  => $https_keystore_keypassword,

        hdfs_data_dirs              => $hdfs_data_dirs,

        hdfs_deployed               => $hdfs_deployed,
        zookeeper_deployed          => $zookeeper_deployed,

        hue_hostnames               => [$hue_hostname],
        properties                  => $hadoop_properties,

        keytab_source_datanode        => $hadoop_datanode_keytab_source,
        keytab_source_httpfs          => $hadoop_httpfs_keytab_source,
        keytab_source_jobhistory      => $hadoop_jobhistory_keytab_source,
        keytab_source_journalnode     => $hadoop_journalnode_keytab_source,
        keytab_source_namenode        => $hadoop_namenode_keytab_source,
        keytab_source_nfs             => $hadoop_nfs_keytab_source,
        keytab_source_nodemanager     => $hadoop_nodemanager_keytab_source,
        keytab_source_resourcemanager => $hadoop_resourcemanager_keytab_source,
        keytab_source_http            => $hadoop_http_keytab_source,
      }

      class{ 'hive':
          group               => 'hive',
          metastore_hostname  => $hdfs_hostname,
          realm               => $realm,
          db                  => $db_engine,
          db_password         => $hive_db_password,
          sentry_hostname     => $hdfs_hostname,
          zookeeper_hostnames => $zookeeper_hostnames,
          properties          => $hive_properties,
          keytab_source       => $hive_keytab_source,
      }
  }

  class{ 'impala':
      catalog_hostname    => $hdfs_hostname,
      statestore_hostname => $hdfs_hostname,
      servers             => $slaves,
      realm               => $realm,
      group               => 'hive',
      https               => $impala_https,
      https_cachain       => $impala_https_cachain,
      https_certificate   => $impala_https_certificate,
      https_private_key   => $impala_https_private_key,
      parameters          => $impala_params,
      keytab_source       => $impala_keytab_source,

      supplied_packages   => {
          catalog    => 'impala-catalog',
          debug      => 'impala-dbg',
          frontend   => 'impala-shell',
          server     => 'impala-server',
          statestore => 'impala-state-store',
          udf        => 'impala-udf-devel',
      }
  }

  if $node_type == 'primary-master' { 
    include hadoop::namenode
    include hadoop::resourcemanager
    include hadoop::historyserver
    include hadoop::httpfs
    include hadoop::zkfc
    include hadoop::journalnode
    include hive::hdfs
    include ::hive::metastore
    include ::hive::server2
    include ::impala::frontend
    include ::impala::statestore
    include ::impala::catalog

    class{ 'zookeeper':
      hostnames     => $zookeeper_hostnames,
      realm         => $realm,
      keytab_source => $zookeeper_keytab_source,
    }
    include ::zookeeper::server

    include ::hue::hdfs
    class{ '::hue':
      defaultFS               => "hdfs://${cluster_name}",
      httpfs_hostname         => $hue_hostname,
      yarn_hostname           => $yarn_hostname,
      yarn_hostname2          => $yarn_hostname2,
      hive_server2_hostname   => $hdfs_hostname,
      secret                  => $hue_secret,
      db                      => $db_engine,
      db_password             => $hue_db_password,
      # zookeeper_hostnames   => $zookeeper_hostnames,
      realm                   => $realm,
      https                   => $hue_https,
      https_cachain           => $hue_https_cachain,
      https_certificate       => $hue_https_certificate,
      https_private_key       => $hue_https_private_key,
      https_passphrase        => $hue_https_passphrase,
      sentry_hostname         => $hdfs_hostname,
      impala_hostname         => $hdfs_hostname,
      auth                    => $hue_auth,
      auth_ldap_base_dn       => $hue_auth_ldap_base_dn,
      auth_ldap_bind_dn       => $hue_auth_ldap_bind_dn,
      auth_ldap_bind_password => $hue_auth_ldap_bind_password,
      auth_ldap_url           => $hue_auth_ldap_url,
      auth_ldap_nt_domain     => $hue_auth_ldap_nt_domain,
      auth_ldap_login_groups  => $hue_auth_ldap_login_groups,
      keytab_source           => $hue_keytab_source,
    }

    class{'::sentry':
      db            => $db_engine,
      db_password   => $sentry_db_password,
      realm         => $realm,
      admin_groups  => [ 'sentry', 'hive', 'impala', 'hue', 'selnhubadm' ],
      properties    => $sentry_properties,
      keytab_source => $sentry_keytab_source,
    }
    include ::sentry
    include ::sentry::client
    include ::sentry::server

    class{ '::postgresql::server':
      postgres_password   => $postgres_password,
    }
    include ::postgresql::server
    postgresql::server::db { 'hue':
        user     => 'hue',
        password => postgresql_password('hue', $hue_db_password),
    }
    postgresql::server::db { 'sentry':
        user     => 'sentry',
        password => postgresql_password('sentry', $sentry_db_password),
    }
    postgresql::server::db { 'metastore':
        user     => 'hive',
        password => postgresql_password('hive', $hive_db_password),
    }
    ->
    exec { 'metastore-import':
        command => 'cat /usr/lib/hive/scripts/metastore/upgrade/postgres/hive-schema-0.14.0.postgres.sql | psql metastore && touch /var/lib/hive/.puppet-hive-schema-imported',
        path    => '/bin/:/usr/bin',
        user    => 'hive',
        creates => '/var/lib/hive/.puppet-hive-schema-imported',
    }
    include postgresql::lib::java
    Postgresql::Server::Db['hue'] -> Class['hue::service']
    Postgresql::Server::Db['sentry'] -> Class['::sentry::server::config']
    Class['postgresql::lib::java'] -> Class['::sentry::server::config']
    Class['postgresql::lib::java'] -> Class['hive::metastore::config']
    Class['hive::metastore::install'] -> Postgresql::Server::Db['metastore']
    Postgresql::Server::Db['metastore'] -> Class['hive::metastore::service']
    Exec['metastore-import'] -> Class['hive::metastore::service']
    Class['hadoop::namenode::service'] -> Class['hive::metastore::service']

    if $knox_keytab_source {
      file { $knox_keytab:
        owner  => 'knox',
        group  => 'knox',
        mode   => '0400',
        source => $knox_keytab_source,
      }
    }
    if $spark_keytab_source {
      file { $spark_keytab:
        owner  => 'spark',
        group  => 'spark',
        mode   => '0400',
        source => $spark_keytab_source,
      }
    }

  } elsif $node_type == 'secondary-master' {
    include hadoop::namenode
    include hadoop::resourcemanager
    include hadoop::zkfc
    include hadoop::journalnode
    include hive::user

    class{ 'zookeeper':
      hostnames     => $zookeeper_hostnames,
      realm         => $realm,
      keytab_source => $zookeeper_keytab_source,
    }
    include ::zookeeper::server

    include ::hue::user
    include ::impala::user

    if $knox_keytab_source {
      file { $knox_keytab:
        owner  => 'knox',
        group  => 'knox',
        mode   => '0400',
        source => $knox_keytab_source,
      }
    }
    if $spark_keytab_source {
      file { $spark_keytab:
        owner  => 'spark',
        group  => 'spark',
        mode   => '0400',
        source => $spark_keytab_source,
      }
    }
  }
  elsif $node_type == 'trinary-master' {
    include hadoop::journalnode
    include hadoop::datanode
    include hadoop::nodemanager
    include ::hive::worker

    class{ 'zookeeper':
      hostnames     => $zookeeper_hostnames,
      realm         => $realm,
      keytab_source => $zookeeper_keytab_source,
    }
    include ::zookeeper::server
    include ::impala::server
  }
  elsif $node_type == 'frontend' {
    include hadoop::frontend
  }
  elsif $node_type == 'client' {
    if $alternative_configuration_dir_for_client {
      group { 'hadoop':
        ensure => present,
        system => true,
      }
      include hive::user
      
      file { "${alternative_configuration_dir_for_client}":
        ensure => 'directory',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }
      file { "${alternative_configuration_dir_for_client}/hadoop":
        ensure => 'directory',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }
      file { "${alternative_configuration_dir_for_client}/hive":
        ensure => 'directory',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }
    }
    include hadoop::common::config
    include hadoop::common::yarn::config
    include hadoop::common::mapred::config
    include hive::common::config
  }
  else {
    include hadoop::datanode
    include hadoop::nodemanager
    include ::hive::worker
    include ::impala::server
  }
}
