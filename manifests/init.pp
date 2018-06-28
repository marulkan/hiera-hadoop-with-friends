class hiera-hadoop (
  packages_common        => [ ],
  hdfs_hostname          => undef,
  hdfs_hostname2         => undef,
  yarn_hostname          => undef,
  yarn_hostname2         => undef,
  historyserver_hostname => undef,
  slaves                 => [ ],
  journalnode_hostnames  => [ ],
  zookeeper_hostnames    => [ ],
  cluster_name           => undef,
  realm                  => undef,
) {
  class{ 'hadoop': 
    packages_common        => $packages_common,
    hdfs_hostname          => $hdfs_hostname,
    hdfs_hostname2         => $hdfs_hostname2,
    yarn_hostname          => $yarn_hostname ,
    yarn_hostname2         => $yarn_hostname2,
    historyserver_hostname => $historyserver_hostname,
    slaves                 => $slaves,
    journalnode_hostnames  => $journalnode_hostnames,
    zookeeper_hostnames    => $zookeeper_hostnames,
    cluster_name           => $cluster_name,
    realm                  => $realm,
  }
}

