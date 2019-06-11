class hiera_hadoop::hbase {
  class{ '::hbase':
    hdfs_hostname              => $hiera_hadoop::hdfs_hostname,
    master_hostname            => $hiera_hadoop::hbase_master_hostname,
    backup_hostnames           => $hiera_hadoop::hbase_backup_hostnames,
    zookeeper_hostnames        => $hiera_hadoop::zookeeper_hostnames,
    slaves                     => $hiera_hadoop::slaves,
    frontends                  => $hiera_hadoop::hbase_frontends,
    realm                      => $hiera_hadoop::realm,
    https                      => $hiera_hadoop::https,
    https_keystore             => $hiera_hadoop::https_keystore,
    https_keystore_password    => $hiera_hadoop::https_keystore_password,
    https_keystore_keypassword => $hiera_hadoop::https_keystore_keypassword,
    properties                 => $hiera_hadoop::hbase_properties,
    group                      => $hiera_hadoop::hbase_group,
    acl                        => $hiera_hadoop::hbase_acl,
  }

  if $hiera_hadoop::node_type == 'primary-master' {
    include ::hbase::master
    include ::hbase::hdfs

    Class['hadoop::namenode::service'] -> Class['hbase::hdfs']
    Class['hadoop::namenode::service'] -> Class['hbase::master::service']

  } elsif $hiera_hadoop::node_type == 'secondary-master' {
    include ::hbase::master
    include ::hbase::user

    Class['hadoop::namenode::service'] -> Class['hbase::master::service']
  }

}
