class hiera_hadoop::hadoop
{
  if $hiera_hadoop::alternative_configuration_dir_for_client {
    class { '::hadoop': 
      hdfs_hostname                 => $hiera_hadoop::hdfs_hostname,
      hdfs_hostname2                => $hiera_hadoop::hdfs_hostname2,
      yarn_hostname                 => $hiera_hadoop::yarn_hostname ,
      yarn_hostname2                => $hiera_hadoop::yarn_hostname2,
      historyserver_hostname        => $hiera_hadoop::historyserver_hostname,
      httpfs_hostnames              => $hiera_hadoop::httpfs_hostnames,
      slaves                        => $hiera_hadoop::slaves,
      frontends                     => $hiera_hadoop::frontends,
      journalnode_hostnames         => $hiera_hadoop::journalnode_hostnames,
      zookeeper_hostnames           => $hiera_hadoop::zookeeper_hostnames,
      cluster_name                  => $hiera_hadoop::cluster_name,
      realm                         => $hiera_hadoop::realm,

      https                         => $hiera_hadoop::https,
      https_cacerts                 => $hiera_hadoop::https_cacerts,
      https_cacerts_password        => $hiera_hadoop::https_cacerts_password,
      https_keystore                => $hiera_hadoop::https_keystore,
      https_keystore_password       => $hiera_hadoop::https_keystore_password,
      https_keystore_keypassword    => $hiera_hadoop::https_keystore_keypassword,

      hdfs_data_dirs                => $hiera_hadoop::hdfs_data_dirs,

      hdfs_deployed                 => $hiera_hadoop::hdfs_deployed,
      zookeeper_deployed            => $hiera_hadoop::zookeeper_deployed,

      hue_hostnames                 => [$hiera_hadoop::hue_hostname],
      properties                    => $hiera_hadoop::hadoop_properties,

      keytab_source_datanode        => $hiera_hadoop::hadoop_datanode_keytab_source,
      keytab_source_httpfs          => $hiera_hadoop::hadoop_httpfs_keytab_source,
      keytab_source_jobhistory      => $hiera_hadoop::hadoop_jobhistory_keytab_source,
      keytab_source_journalnode     => $hiera_hadoop::hadoop_journalnode_keytab_source,
      keytab_source_namenode        => $hiera_hadoop::hadoop_namenode_keytab_source,
      keytab_source_nfs             => $hiera_hadoop::hadoop_nfs_keytab_source,
      keytab_source_nodemanager     => $hiera_hadoop::hadoop_nodemanager_keytab_source,
      keytab_source_resourcemanager => $hiera_hadoop::hadoop_resourcemanager_keytab_source,
      keytab_source_http            => $hiera_hadoop::hadoop_http_keytab_source,

      confdir                       => "${hiera_hadoop::alternative_configuration_dir_for_client}/hadoop",
    }
  }
  else {
    class { '::hadoop': 
      hdfs_hostname                 => $hiera_hadoop::hdfs_hostname,
      hdfs_hostname2                => $hiera_hadoop::hdfs_hostname2,
      yarn_hostname                 => $hiera_hadoop::yarn_hostname ,
      yarn_hostname2                => $hiera_hadoop::yarn_hostname2,
      historyserver_hostname        => $hiera_hadoop::historyserver_hostname,
      httpfs_hostnames              => $hiera_hadoop::httpfs_hostnames,
      slaves                        => $hiera_hadoop::slaves,
      frontends                     => $hiera_hadoop::frontends,
      journalnode_hostnames         => $hiera_hadoop::journalnode_hostnames,
      zookeeper_hostnames           => $hiera_hadoop::zookeeper_hostnames,
      cluster_name                  => $hiera_hadoop::cluster_name,
      realm                         => $hiera_hadoop::realm,

      https                         => $hiera_hadoop::https,
      https_cacerts                 => $hiera_hadoop::https_cacerts,
      https_cacerts_password        => $hiera_hadoop::https_cacerts_password,
      https_keystore                => $hiera_hadoop::https_keystore,
      https_keystore_password       => $hiera_hadoop::https_keystore_password,
      https_keystore_keypassword    => $hiera_hadoop::https_keystore_keypassword,

      hdfs_data_dirs                => $hiera_hadoop::hdfs_data_dirs,

      hdfs_deployed                 => $hiera_hadoop::hdfs_deployed,
      zookeeper_deployed            => $hiera_hadoop::zookeeper_deployed,

      hue_hostnames                 => [$hiera_hadoop::hue_hostname],
      properties                    => $hiera_hadoop::hadoop_properties,

      keytab_source_datanode        => $hiera_hadoop::hadoop_datanode_keytab_source,
      keytab_source_httpfs          => $hiera_hadoop::hadoop_httpfs_keytab_source,
      keytab_source_jobhistory      => $hiera_hadoop::hadoop_jobhistory_keytab_source,
      keytab_source_journalnode     => $hiera_hadoop::hadoop_journalnode_keytab_source,
      keytab_source_namenode        => $hiera_hadoop::hadoop_namenode_keytab_source,
      keytab_source_nfs             => $hiera_hadoop::hadoop_nfs_keytab_source,
      keytab_source_nodemanager     => $hiera_hadoop::hadoop_nodemanager_keytab_source,
      keytab_source_resourcemanager => $hiera_hadoop::hadoop_resourcemanager_keytab_source,
      keytab_source_http            => $hiera_hadoop::hadoop_http_keytab_source,
    }
  }
}
