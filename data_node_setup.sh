#!/bin/bash

# Installing Elasticsearch
sudo yum update -y
sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
sudo yum install perl-Digest-SHA -y
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.6.2-x86_64.rpm
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.6.2-x86_64.rpm.sha512
shasum -a 512 -c elasticsearch-7.6.2-x86_64.rpm.sha512
sudo rpm --install elasticsearch-7.6.2-x86_64.rpm

# Setting heap size for the master node
echo ES_JAVA_OPTS="\"-Xms512m -Xmx512m\"" >> /etc/sysconfig/elasticsearch
echo MAX_LOCKED_MEMORY=unlimited >> /etc/sysconfig/elasticsearch

# Discovery EC2 plugin is used for the nodes to create the cluster in AWS
echo -e "y\n" | /usr/share/elasticsearch/bin/elasticsearch-plugin install discovery-ec2

# Configuration for Elasticsearch nodes to find each other
echo "cluster.name: my-elasticsearch-cluster" >> /etc/elasticsearch/elasticsearch.yml
echo "discovery.zen.hosts_provider: ec2" >> /etc/elasticsearch/elasticsearch.yml
echo "discovery.ec2.endpoint: ec2.us-east-1.amazonaws.com" >> /etc/elasticsearch/elasticsearch.yml
echo "network.host: _ec2_" >> /etc/elasticsearch/elasticsearch.yml
echo "discovery.ec2.tag.ec2discovery: es" >> /etc/elasticsearch/elasticsearch.yml
echo "discovery.zen.minimum_master_nodes: 1" >> /etc/elasticsearch/elasticsearch.yml
echo "discovery.ec2.host_type: private_ip" >> /etc/elasticsearch/elasticsearch.yml
echo "cluster.initial_master_nodes: ["master-node"]" >> /etc/elasticsearch/elasticsearch.yml
echo "node.master: false" >> /etc/elasticsearch/elasticsearch.yml
echo "node.data: true" >> /etc/elasticsearch/elasticsearch.yml
echo "node.ingest: false" >> /etc/elasticsearch/elasticsearch.yml

# Reloading the daemon and enabling the elasticsearch service
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service

# Start elasticsearch service by executing
sudo systemctl start elasticsearch.service

echo "Data node setup finished!" > ~/data-node.txt
