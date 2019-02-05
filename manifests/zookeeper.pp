class hiera_hadoop::zookeeper {
  class{ '::zookeeper':
    hostnames     => $hiera_hadoop::zookeeper_hostnames,
    realm         => $hiera_hadoop::realm,
    keytab_source => $hiera_hadoop::zookeeper_keytab_source,
  }
  include ::zookeeper::server
}
