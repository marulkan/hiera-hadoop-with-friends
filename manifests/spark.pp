class hiera_hadoop::spark {
  class{ '::spark':
    historyserver_hostname => $hiera_hadoop::hdfs_hostname,
    hdfs_hostname          => $::fqdn,
    realm                  => $hiera_hadoop::realm,
  }
  
  include ::spark

  if $node_type == 'primary-master' {
    include ::spark::hdfs
    include ::spark::historyserver
    Class['hadoop::namenode::service'] -> Class['::spark::historyserver::service']
  } elsif $node_type == 'secondary-master' {
    include ::spark::user
  } elsif $node_type == 'client' {
    include ::spark::frontend
  }
}
