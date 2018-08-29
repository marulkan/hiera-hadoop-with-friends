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
      defaultFS           => "hdfs://${cluster_name}",
      httpfs_hostname     => $hue_hostname,
      yarn_hostname       => $yarn_hostname,
      yarn_hostname2      => $yarn_hostname2,
      secret              => $hue_secret,
      zookeeper_hostnames => $zookeeper_hostnames,
    }
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

