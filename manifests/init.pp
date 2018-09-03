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

  $hue_hostname                = '',
  $hue_secret                  = '',
  $db_engine                   = '',
  $hue_db_password             = '',
  $postgres_password           = '',
  $hue_https                   = false,
  $hue_https_cachain           = undef,
  $hue_https_certificate       = '/etc/grid-security/hostcert.pem',
  $hue_https_private_key       = '/etc/grid-security/hostkey.pem',
  $hue_https_passphrase        = undef,
  $hue_auth = undef,
  $hue_auth_ldap_base_dn = 'DC=mycompany,DC=com',
  $hue_auth_ldap_bind_dn = 'CN=ServiceAccount,DC=mycompany,DC=com',
  $hue_auth_ldap_bind_password = undef,
  $hue_auth_ldap_url = 'ldap://auth.mycompany.com',
  $hue_auth_ldap_nt_domain = 'mycompany.com',
) {
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
  }

  if $node_type == 'primary-master' { 
    include hadoop::namenode
    include hadoop::resourcemanager
    include hadoop::historyserver
    include hadoop::httpfs
    include hadoop::zkfc
    include hadoop::journalnode

    class{ 'zookeeper':
      hostnames => $zookeeper_hostnames,
      realm     => $realm,
    }
    include ::zookeeper::server

    include ::hue::hdfs
    class { '::hue':
      defaultFS               => "hdfs://${cluster_name}",
      httpfs_hostname         => $hue_hostname,
      yarn_hostname           => $yarn_hostname,
      yarn_hostname2          => $yarn_hostname2,
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
      auth                    => $hue_auth,
      auth_ldap_base_dn       => $hue_auth_ldap_base_dn,
      auth_ldap_bind_dn       => $hue_auth_ldap_bind_dn,
      auth_ldap_bind_password => $hue_auth_ldap_bind_password,
      auth_ldap_url           => $hue_auth_ldap_url,
      auth_ldap_nt_domain     => $hue_auth_ldap_nt_domain,
    }

    class { '::postgresql::server':
      postgres_password   => $postgres_password,
    }
    include ::postgresql::server
    postgresql::server::db { 'hue':
      user     => 'hue',
      password => postgresql_password('hue', $hue_db_password),
    }
    Postgresql::Server::Db['hue'] -> Class['hue::service']
  } elsif $node_type == 'secondary-master' {
    include hadoop::namenode
    include hadoop::resourcemanager
    include hadoop::zkfc
    include hadoop::journalnode

    class{ 'zookeeper':
      hostnames => $zookeeper_hostnames,
      realm     => $realm,
    }
    include ::zookeeper::server

    include ::hue::user
  } elsif $node_type == 'trinary-master' {
    include hadoop::journalnode
    include hadoop::datanode
    include hadoop::nodemanager

    class{ 'zookeeper':
      hostnames => $zookeeper_hostnames,
      realm     => $realm,
    }
    include ::zookeeper::server
  } elsif $node_type == 'frontend' {
    include hadoop::frontend
  }
  else {
    include hadoop::datanode
    include hadoop::nodemanager
  }
}

