class hiera-hadoop (
  $packages_common        = [ ],
  $hdfs_hostname          = undef,
  $hdfs_hostname2         = undef,
  $yarn_hostname          = undef,
  $yarn_hostname2         = undef,
  $historyserver_hostname = undef,
  $httpfs_hostnames       = [ ],
  $slaves                 = [ ],
  $frontends              = [ ],
  $journalnode_hostnames  = [ ],
  $zookeeper_hostnames    = [ ],
  $cluster_name           = undef,
  $realm                  = undef,
  $node_type              = undef,
) {
  class{ 'hadoop': 
    hdfs_hostname          => $hdfs_hostname,
    hdfs_hostname2         => $hdfs_hostname2,
    yarn_hostname          => $yarn_hostname ,
    yarn_hostname2         => $yarn_hostname2,
    historyserver_hostname => $historyserver_hostname,
    httpfs_hostnames       => $httpfs_hostnames,
    slaves                 => $slaves,
    frontends              => $frontends,
    journalnode_hostnames  => $journalnode_hostnames,
    zookeeper_hostnames    => $zookeeper_hostnames,
    cluster_name           => $cluster_name,
    realm                  => $realm,
  }

  if $node_type == 'primary-master' { 
    include hadoop::namenode
    include hadoop::resourcemanager
    include hadoop::historyserver
# include hadoop::httpfs
    include hadoop::zkfc
    include hadoop::journalnode

    class{ 'zookeeper':
      hostnames => $zookeeper_hostnames,
      realm     => $realm,
    }
    include ::zookeeper::server
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
  } elsif $node_type == 'trinary-master' {
    include hadoop::journalnode

    class{ 'zookeeper':
      hostnames => $zookeeper_hostnames,
      realm     => $realm,
    }
    include ::zookeeper::server
  } elsif $node_type == 'frontend' {
    include hadoop::frontend
  }
}

