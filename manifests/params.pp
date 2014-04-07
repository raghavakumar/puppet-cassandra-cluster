#/etc/puppet/modules/cassandra/manifests/params.pp


class cassandra::params {
 
  #set JAVA_HOME path
  $java_home = $::hostname ? {
     default => "$(readlink -f /usr/bin/java | sed 's:bin/java::')",
  }

  #set cassandra version
  $version = $::hostname ? {		
     default => "2.0.4",
  }

  #set download_url
  $download_url = $::hostname ? {
     default => "https://archive.apache.org/dist/cassandra/2.0.4/apache-cassandra-2.0.4-bin.tar.gz",
  }

  #set cassandra base
  $cassandra_base = $::hostname ? {
     default => "/opt/cassandra",
  }

  #set cassandra data folder path
  $data_path = $::hostname ? {
     default => "/home/cassandra/data",
  }

  #set cassandra commitlog directory
  $commitlog_directory = $::hostname ? {
     default => "/home/cassandra/commitlog",
  }

  #set path for cassandra saved_cache folder
  $saved_caches = $::hostname ? {
     default => "/home/cassandra/saved_caches",
  }

  #set cassandra cluster name
  $cluster_name = $::hostname ? {
     default => "Cassandra Cluster",
  }

  #set cassandra service name used as /etc/init.d/cassandra
  $service_name = $::hostname ? {
     default => "cassandra",
  }

  #set tokens for cassandra nodes
  $initial_token = $::hostname ? {
    cassandra-01 => "0",
    cassandra-02 => "42535295865117307932921825928971026432",
    cassandra-03 => "85070591730234615865843651857942052864",
    cassandra-04 => "127605887595351923798765477786913079296",
  }

  #set cassandra nodes as seeds.        
  $seeds = $::hostname ? {
    default => "cassandra-01, cassandra-03",
  }

  #set cassandra log path
  $cassandra_log_path = $::hostname ? {
     default => "/var/log/cassandra",
  }

  #set cassandra jmx_port
  $jmx_port = $::hostname ? {
     default => "7199",
  }

  #set max_heap size
  $max_heap = $::hostname ? {
     default => "4G",
  }

  #set heap_newsize
  $heap_newsize = $::hostname ? {
     default => "800M",
  }

  #set cassandra_owner/user
  $cassandra_owner = $::hostname ? {
     default => "cassandra",
  }

  #set cassandra_group
  $cassandra_group = $::hostname ? {
     default => "cassandra",
  }
}
