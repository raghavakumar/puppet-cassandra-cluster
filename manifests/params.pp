#/etc/puppet/modules/cassandra/manifests/params.pp


class cassandra::params {
  
  $java_home = $::hostname ? {
     default => "$(readlink -f /usr/bin/java | sed 's:bin/java::')",
  }

  $version = $::hostname ? {		
     default => "2.0.4",
  }

  $download_url = $::hostname ? {
     default => "https://archive.apache.org/dist/cassandra/2.0.4/apache-cassandra-2.0.4-bin.tar.gz",
  }

  $cassandra_base = $::hostname ? {
     default => "/opt/cassandra",
  }

  $data_path = $::hostname ? {
     default => "/home/cassandra/data",
  }

  $commitlog_directory = $::hostname ? {
     default => "/home/cassandra/commitlog",
  }

  $saved_caches = $::hostname ? {
     default => "/home/cassandra/saved_caches",
  }

  $cluster_name = $::hostname ? {
     default => "Cassandra Cluster",
  }

  $service_name = $::hostname ? {
     default => "cassandra",
  }

  $initial_token = $::hostname ? {
     default => "42535295865117307932921825928971026432",
  } 

  $seeds = $::hostname ? {
     default => "mastercentos.example.com",
  }

  $cassandra_log_path = $::hostname ? {
     default => "/var/log/cassandra",
  }

  $jmx_port = $::hostname ? {
     default => "7199",
  }

  $max_heap = $::hostname ? {
     default => "4G",
  }

  $heap_newsize = $::hostname ? {
     default => "800M",
  }

  $cassandra_owner = $::hostname ? {
     default => "cassandra",
  }

  $cassandra_group = $::hostname ? {
     default => "cassandra",
  }
}
