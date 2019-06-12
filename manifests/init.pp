class hiera_hadoop (
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
  $hue_auth                    = undef,
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

  $sentry_hostname             = $::fqdn,
  $sentry_db_password          = '',
  $hive_db_password            = '',
  $hadoop_properties           = {},
  $sentry_properties           = {},
  $sentry_admin_groups         = [ 'sentry', 'hive', 'impala', 'hue' ],
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

  $hbase_master_hostname  = undef, # ''
  $hbase_backup_hostnames = undef, # []
  $hbase_thrift_hostnames = undef, # []
  $hbase_frontends        = [],
  $hbase_properties       = undef,
  $hbase_group            = 'users',
  $hbase_acl              = undef,
  $hbase_keytab         = '/etc/security/keytab/hbase.service.keytab',
  $hbase_keytab_source  = undef,

  $kafka_brokers        = [ ],
  $kafka_log_dirs       = [ ],
  $kafka_sentry_enabled = true,
  $kafka_package_name   = 'kafka-server',
  $kafka_keytab         = '/etc/security/keytab/kafka.service.keytab',
  $kafka_keytab_source  = undef,

  $kafka_properties = {},

  $knox_keytab      = '/etc/security/keytab/knox.service.keytab',
  $spark_keytab     = '/etc/security/keytab/spark.service.keytab',

  $spark_packages = {
    common        => 'spark-core',
    master        => 'spark-master',
    frontend      => 'spark-python',
    historyserver => 'spark-history-server',
    worker        => 'spark-worker',
  },
  $spark_shell_env = [],

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

  if $node_type == 'primary-master' { 
    include hiera_hadoop::hadoop
    include hiera_hadoop::hive
    include hiera_hadoop::impala
    include hiera_hadoop::hbase
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

    include hiera_hadoop::kafka
    include ::kafka::client
    include ::kafka::user

    include hiera_hadoop::zookeeper
    include hiera_hadoop::hue
    include hiera_hadoop::sentry

    include hiera_hadoop::spark

    class{ '::postgresql::server':
      postgres_password   => $postgres_password,
    }
    include ::postgresql::server
    include postgresql::lib::java

    if $knox_keytab_source {
      file { $knox_keytab:
        owner  => 'knox',
        group  => 'knox',
        mode   => '0400',
        source => $knox_keytab_source,
      }
    }
  } elsif $node_type == 'secondary-master' {
    include hiera_hadoop::hadoop
    include hiera_hadoop::hive
    include hiera_hadoop::impala
    include hiera_hadoop::kafka
    include hadoop::namenode
    include hadoop::resourcemanager
    include hadoop::zkfc
    include hadoop::journalnode
    include hive::user
    include hiera_hadoop::zookeeper

    include ::kafka::client
    include ::kafka::user

    include ::hue::user
    include ::impala::user

    include hiera_hadoop::spark

    if $knox_keytab_source {
      file { $knox_keytab:
        owner  => 'knox',
        group  => 'knox',
        mode   => '0400',
        source => $knox_keytab_source,
      }
    }
  }
  elsif $node_type == 'trinary-master' {
    include hiera_hadoop::hadoop
    include hiera_hadoop::hive
    include hiera_hadoop::impala
    include hiera_hadoop::hbase
    include hiera_hadoop::kafka
    include hadoop::journalnode
    include hadoop::datanode
    include hadoop::nodemanager
    include ::hive::worker
    include hiera_hadoop::zookeeper

    include ::hbase::regionserver
    include ::kafka::server
    include ::kafka::client

    include ::impala::server

    include hiera_hadoop::sentry
    include hiera_hadoop::spark
  }
  elsif $node_type == 'frontend' {
    include hadoop::frontend
  }
  elsif $node_type == 'client' {
    include hiera_hadoop::hadoop
    include hiera_hadoop::hive
    include hiera_hadoop::impala
    include hiera_hadoop::hbase
    include hiera_hadoop::kafka
    include ::kafka::client
    include ::kafka::user

    #include ::hbase::frontend

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
    include hiera_hadoop::hadoop
    include hiera_hadoop::hive
    include hiera_hadoop::impala
    include hiera_hadoop::hbase
    include hiera_hadoop::kafka
    include hadoop::datanode
    include hadoop::nodemanager
    include ::hive::worker
    include ::impala::server

    include ::hbase::regionserver
    include ::kafka::server
    include ::kafka::client

    include hiera_hadoop::sentry
    include hiera_hadoop::spark
  }
}
