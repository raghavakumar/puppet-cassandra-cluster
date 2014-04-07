puppet-cassandra-cluster
========================

Overview:

This module was created to assist with the installation and configuration of a cassandra cluster. Simply edit the params.pp

Usage:

include cassandra

Configuration:

Modifiy "$download_url" param in "params.pp" to fetch required cassandra version using wget. By default, "$download_url" param defined "https://archive.apache.org/dist/cassandra/2.0.4/apache-cassandra-2.0.4-bin.tar.gz".

The params.pp also requires $JAVA_HOME PATH. $java_home variable needs to be properly updated.

The params.pp also requires "$initial_token" and "$seeds" variables needs to be properly updated. $initial_token denotes the cluster nodes with a valid token. $seeds variable denotes set of cluster nodes which are treated as cassandra seeds.

The hostnames of the nodes in the cluster need to be defined in params.pp, by default this module creates a 4 node cluster.


Support:

Please create bug reports and feature requests in GitHub issues.
