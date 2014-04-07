# /etc/puppet/modules/cassandra/manifests/init.pp

class cassandra {

  require cassandra::params
  group { "${cassandra::params::cassandra_group}":
		ensure => present,
		gid => "900",
	}

	user { "${cassandra::params::cassandra_owner}":
		ensure => present,
		comment => "Cassandra",
		password => "!!",
		uid => "900",
		gid => "900",
		shell => "/bin/bash",
		home => "/home/${cassandra::params::cassandra_owner}",
		require => Group["${cassandra::params::cassandra_group}"],
	}
	
	file { "/home/${cassandra::params::cassandra_owner}/.bash_profile":
		ensure => present,
		owner => "${cassandra::params::cassandra_owner}",
		group => "${cassandra::params::cassandra_group}",
		alias => "cassandra-bash_profile",
		content => template("cassandra/home/bash_profile.erb"),
		require => User["${cassandra::params::cassandra_owner}"]
	}
		
	file { "/home/${cassandra::params::cassandra_owner}":
		ensure => "directory",
		owner => "${cassandra::params::cassandra_owner}",
		group => "${cassandra::params::cassandra_group}",
		alias => "cassandra-home",
		require => [ User["${cassandra::params::cassandra_owner}"], Group["${cassandra::params::cassandra_group}"] ],
	}

  file {"${cassandra::params::cassandra_base}":
		ensure => "directory",
		owner  => "${cassandra::params::cassandra_owner}",
		group  => "${cassandra::params::cassandra_group}",
		alias  => "cassandra-base",
    mode   => 755 
	}

  file {"${cassandra::params::cassandra_log_path}":
		ensure => "directory",
		owner => "${cassandra::params::cassandra_owner}",
		group => "${cassandra::params::cassandra_group}",
		alias => "cassandra-log-path",
    require => File["cassandra-base"]
	}


  file {"${cassandra::params::data_path}":
		ensure => "present",
    purge  => true,
    force  => true,
    backup => false,
		owner  => "${cassandra::params::cassandra_owner}",
		group  => "${cassandra::params::cassandra_group}",
		alias  => "cassandra-data-path",
	}

 file {"${cassandra::params::commitlog_directory}":
		ensure => "directory",
		owner => "${cassandra::params::cassandra_owner}",
		group => "${cassandra::params::cassandra_group}",
		alias => "cassandra-commitlog-directory",
    require => File["cassandra-base"]
	}

 file {"${cassandra::params::saved_caches}":
		ensure => "directory",
		owner => "${cassandra::params::cassandra_owner}",
		group => "${cassandra::params::cassandra_group}",
		alias => "cassandra-saved-caches",
    require => File["cassandra-base"]
	}

 file { "${cassandra::params::cassandra_base}/apache-cassandra-${cassandra::params::version}-bin.tar.gz":
    mode     => 0644,
		owner    => "${cassandra::params::cassandra_owner}",
		group    => "${cassandra::params::cassandra_group}",
		source   => "puppet:///modules/cassandra/apache-cassandra-${cassandra::params::version}-bin.tar.gz",
		alias    => "cassandra-source-tgz",
    before   => Exec["untar-cassandra"],
		require  => File["cassandra-base"]
	}
 

 exec { "untar apache-cassandra-${cassandra::params::version}-bin.tar.gz":
    cwd          => "${cassandra::params::cassandra_base}", 
    command      => "/bin/tar zxvf apache-cassandra-${cassandra::params::version}-bin.tar.gz",
    creates      => "${cassandra::params::cassandra_base}/cassandra-${cassandra::params::version}",
    alias        => "untar-cassandra",
    refreshonly => true,
    subscribe   => File["cassandra-source-tgz"],
    user         => "cassandra",
    before       => [ File[ "cassandra-symlink" ], File[ "cassandra-app-dir" ] ]
	}

 file { "${cassandra::params::cassandra_base}/apache-cassandra-${cassandra::params::version}":
		ensure => "directory",
		mode => 0644,
		owner => "${cassandra::params::cassandra_owner}",
		group => "${cassandra::params::cassandra_group}",
		alias => "cassandra-app-dir",
    before => [ File["cassandra-yaml"], File["cassandra-log4j"], File["cassandra-env"] ]
	}

 file { "${cassandra::params::cassandra_base}/apache-cassandra":
		force => true,
		ensure => "${cassandra::params::cassandra_base}/apache-cassandra-${cassandra::params::version}",
		alias => "cassandra-symlink",
		owner => "${cassandra::params::cassandra_owner}",
		group => "${cassandra::params::cassandra_group}",
		require => File["cassandra-source-tgz"],
	}

 file { "${cassandra::params::cassandra_base}/apache-cassandra-${cassandra::params::version}/conf/cassandra.yaml":
    alias => "cassandra-yaml",
    content => template("cassandra/conf/cassandra.yaml.erb"),
    owner => "${cassandra::params::cassandra_owner}",
    group => "${cassandra::params::cassandra_group}",
    mode => "644",
    require => File["cassandra-app-dir"]
 }

 file { "${cassandra::params::cassandra_base}/apache-cassandra-${cassandra::params::version}/conf/cassandra-env.sh":
   alias => "cassandra-env",
    content => template("cassandra/conf/cassandra-env.sh.erb"),
    owner => "${cassandra::params::cassandra_owner}",
    group => "${cassandra::params::cassandra_group}",
    mode => "644",
    require => File["cassandra-app-dir"]
 }

 file { "${cassandra::params::cassandra_base}/apache-cassandra-${cassandra::params::version}/conf/log4j-server.properties":
    alias => "cassandra-log4j",
    content => template("cassandra/conf/log4j-server.properties.erb"),
    owner => "${cassandra::params::cassandra_owner}",
    group => "${cassandra::params::cassandra_group}",
    mode => "644",
    require => File["cassandra-app-dir"]
 }
 
 file { "/etc/init.d/cassandra":
    alias => "cassandra-initscript",
    content => template("cassandra/conf/cassandra.sh.erb"),
    owner => "${cassandra::params::cassandra_owner}",
    group => "${cassandra::params::cassandra_group}",
    mode => "755",
    require => File["cassandra-app-dir"]
 }
 
 service { "${cassandra::params::service_name}":
    ensure      => running,
    enable      => true,
    require     => File["cassandra-initscript"],
    #hasstatus  => true,
    #hasrestart => true,
    alias       =>  "cassandra service",
 }

 exec { "wait_for_nodetool_status":
     alias   => "wait_for_nodetool_status",
     require => Service["${cassandra::params::service_name}"],
     command => "sleep 15",
     path    => "/usr/bin:/bin",
 }

 exec {"execute nodetool status":
     alias     => "execute_nodetool_status",
     require   => Service["${cassandra::params::service_name}"],
     command   => "sh nodetool status",
     path      => '/usr/bin:/bin',
     cwd       => "${cassandra::params::cassandra_base}/apache-cassandra-${cassandra::params::version}/bin",
     user     => "${cassandra::params::cassandra_owner}",
     logoutput => true,
 }
}
