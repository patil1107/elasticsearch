#!/bin/bash

sudo yum update -y

sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

sudo yum install perl-Digest-SHA -y

wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.6.2-x86_64.rpm
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.6.2-x86_64.rpm.sha512
shasum -a 512 -c elasticsearch-7.6.2-x86_64.rpm.sha512
sudo rpm --install elasticsearch-7.6.2-x86_64.rpm

echo ES_JAVA_OPTS="\"-Xms256m -Xmx256m\"" >> /etc/sysconfig/elasticsearch
echo MAX_LOCKED_MEMORY=unlimited >> /etc/sysconfig/elasticsearch

# Discovery EC2 plugin is used for the nodes to create the cluster in AWS
echo -e "y\n" | /usr/share/elasticsearch/bin/elasticsearch-plugin install discovery-ec2

# Shortest configuration for Elasticsearch nodes to find each other
echo "discovery.zen.hosts_provider: ec2" >> /etc/elasticsearch/elasticsearch.yml
echo "discovery.ec2.endpoint: ec2.us-east-1.amazonaws.com" >> /etc/elasticsearch/elasticsearch.yml
echo "network.host: _ec2_" >> /etc/elasticsearch/elasticsearch.yml
echo "discovery.ec2.tag.ec2discovery: es" >> /etc/elasticsearch/elasticsearch.yml
echo "node.master: true" >> /etc/elasticsearch/elasticsearch.yml
echo "node.data: false" >> /etc/elasticsearch/elasticsearch.yml
echo "node.ingest: true" >> /etc/elasticsearch/elasticsearch.yml

sudo systemctl daemon-reload

sudo systemctl enable elasticsearch.service
### You can start elasticsearch service by executing
sudo systemctl start elasticsearch.service
