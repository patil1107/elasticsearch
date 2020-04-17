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
sed -i 's/-Xms1g/-Xms512m/g' /etc/elasticsearch/jvm.options
sed -i 's/-Xmx1g/-Xmx512m/g' /etc/elasticsearch/jvm.options

# Discovery EC2 plugin is used for the nodes to create the cluster in AWS
echo -e "y\n" | /usr/share/elasticsearch/bin/elasticsearch-plugin install discovery-ec2

# Configuration for Elasticsearch nodes to find each other
nodename=$(curl http://169.254.169.254/latest/meta-data/local-hostname)
echo "cluster.name: my-elasticsearch-cluster" >> /etc/elasticsearch/elasticsearch.yml
echo "discovery.zen.hosts_provider: ec2" >> /etc/elasticsearch/elasticsearch.yml
echo "discovery.ec2.endpoint: ec2.us-east-1.amazonaws.com" >> /etc/elasticsearch/elasticsearch.yml
echo "network.host: [_ec2_,_local_]" >> /etc/elasticsearch/elasticsearch.yml
echo "discovery.ec2.tag.ec2discovery: es" >> /etc/elasticsearch/elasticsearch.yml
echo "discovery.zen.minimum_master_nodes: 1" >> /etc/elasticsearch/elasticsearch.yml
echo "discovery.ec2.host_type: private_ip" >> /etc/elasticsearch/elasticsearch.yml
echo "node.name: $nodename" >> /etc/elasticsearch/elasticsearch.yml
echo "cluster.initial_master_nodes: ["$nodename"]" >> /etc/elasticsearch/elasticsearch.yml
echo "node.master: true" >> /etc/elasticsearch/elasticsearch.yml
echo "node.data: false" >> /etc/elasticsearch/elasticsearch.yml
echo "node.ingest: true" >> /etc/elasticsearch/elasticsearch.yml

#Generating CA and SSL Certificate
cd /usr/share/elasticsearch/bin
echo "" | ./elasticsearch-certutil ca --out elasticsearch-ca.p12
ip=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
echo '' | ./elasticsearch-certutil cert --ca elasticsearch-ca.p12 --ip $ip --out elasticsearch-cert-$ip.p12 --pass ''

#Copying ssl cert to elasticsearch directory
mv /usr/share/elasticsearch/elasticsearch-cert-$ip.p12 /etc/elasticsearch
chmod 755 /etc/elasticsearch/elasticsearch-cert-$ip.p12

#Adding configurations to elasticsearch.yml file
#echo "xpack.security.enabled: true" >> /etc/elasticsearch/elasticsearch.yml
#echo "xpack.security.http.ssl.enabled: true" >> /etc/elasticsearch/elasticsearch.yml
#echo "xpack.security.transport.ssl.enabled: true" >> /etc/elasticsearch/elasticsearch.yml
#echo "xpack.security.transport.ssl.verification_mode: certificate" >> /etc/elasticsearch/elasticsearch.yml
#echo "xpack.security.transport.ssl.keystore.path: /etc/elasticsearch/elasticsearch-cert-$ip.p12" >> /etc/elasticsearch/elasticsearch.yml
#echo "xpack.security.transport.ssl.truststore.path: /etc/elasticsearch/elasticsearch-cert-$ip.p12" >> /etc/elasticsearch/elasticsearch.yml
#echo "xpack.security.http.ssl.keystore.path: /etc/elasticsearch/elasticsearch-cert-$ip.p12" >> /etc/elasticsearch/elasticsearch.yml
#echo "xpack.security.http.ssl.truststore.path: /etc/elasticsearch/elasticsearch-cert-$ip.p12" >> /etc/elasticsearch/elasticsearch.yml
#echo "xpack.security.http.ssl.client_authentication: optional" >> /etc/elasticsearch/elasticsearch.yml

# Reloading the daemon and enabling the elasticsearch service
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service

# Start elasticsearch service by executing
sudo systemctl start elasticsearch.service

echo "Master node setup finished!" > ~/master-node.txt
