class hiera_hadoop::impala {
  class{ '::impala':
      catalog_hostname    => $hiera_hadoop::hdfs_hostname,
      statestore_hostname => $hiera_hadoop::hdfs_hostname,
      servers             => $hiera_hadoop::slaves,
      realm               => $hiera_hadoop::realm,
      group               => 'hive',
      https               => $hiera_hadoop::impala_https,
      https_cachain       => $hiera_hadoop::impala_https_cachain,
      https_certificate   => $hiera_hadoop::impala_https_certificate,
      https_private_key   => $hiera_hadoop::impala_https_private_key,
      parameters          => $hiera_hadoop::impala_params,
      keytab_source       => $hiera_hadoop::impala_keytab_source,

      supplied_packages   => {
          catalog    => 'impala-catalog',
          debug      => 'impala-dbg',
          frontend   => 'impala-shell',
          server     => 'impala-server',
          statestore => 'impala-state-store',
          udf        => 'impala-udf-devel',
      }
  }
}
