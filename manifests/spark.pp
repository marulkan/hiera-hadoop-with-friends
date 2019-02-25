class hiera_hadoop::spark {
  class{ '::spark':
    historyserver_hostname => $hiera_hadoop::hdfs_hostname,
    hdfs_hostname          => $::fqdn,
    realm                  => $hiera_hadoop::realm,
    keytab_source          => $hiera_hadoop::spark_keytab_source,
  }
  
  include ::spark

  if $hiera_hadoop::node_type == 'primary-master' {
    include ::spark::hdfs
    include ::spark::historyserver
    Class['hadoop::namenode::service'] -> Class['::spark::historyserver::service']
  } elsif $hiera_hadoop::node_type == 'secondary-master' {
    include ::spark::user
  } elsif $hiera_hadoop::node_type == 'client' {
    include ::spark::frontend
  }
}
