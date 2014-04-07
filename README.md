puppet-cassandra-cluster
========================

Overview:

This module was created to assist with the installation and configuration of a cassandra cluster. Simply edit the params.pp

Usage:

include cassandra

Configuration:

A tar.gz file needs to be placed into ~/modules/cassandra/files. Already placed "apache-cassandra-2.0.4-bin.tar" in files folder.

If files/apache-cassandra-2.0.4-bin.tar was replaced with any ohter downloaded version, then params.pp file needs to be updated with the version downloaded.

The hostnames of the nodes in the cluster need to be defined in params.pp, by default this module creates a 2 node cluster.

If you change the number of nodes from 2 to the required number of nodes (for ex: 4) you need to run the following python script and update $token section in params.pp.

    num_node = 4
    for n in range(num_node):
        print int(2**127 / num_node * n)

Support:

Please create bug reports and feature requests in GitHub issues.
