# Deploying Elasticsearch Cluster on AWS using Terraform

1. What did you choose to automate the provisioning and bootstrapping of the instance? Why?

I have used Terraform to automate the provisioning and bootstrapping of the aws infrastructure, It is one of the best and easy open-source 
infrastructure as code software tool available. I have also used shell for the installation and configuration of ElasticSearch.

2. How did you choose to secure ElasticSearch? Why?

ElasticSearch authentication can be secured using users and roles, also communication between nodes can be secured using Xpack Security 
for SSL/TLS protocol

3. How would you monitor this instance? What metrics would you monitor?

As all the infrastructure is deployed on AWS, Cloudwatch can be used to monitor the elasticsearch cluster. I will monitor the memory usage, network, disk utilization and cpu utlization of the instances in cluster.

4. Could you extend your solution to launch a secure cluster of ElasticSearch nodes? What
would need to change to support this use case?

Yes, it is possible to extend my solution to launch a secure cluster of ElasticSearch nodes, for that we need to add some parameters
to elasticsearch.yml configuration file to support Xpack Security

5. Could you extend your solution to replace a running ElasticSearch instance with little or no
downtime? How?

Yes, I can extend your solution to replace a running ElasticSearch instance with little or no downtime, I have used Ec2-Discover plugin which discovers the Elasticsearch EC2 instances automatically through the host provider ‘ec2’. As we add nodes to the cluster, there no need to manually update the configuration file with new IP Address.

6. Was it a priority to make your code well structured, extensible, and reusable? 
Yes.

# Description
There are 5 main files required for this setup:

1. elasticsearch_main.tf: This Terraform code creates security groups and role.
2. elasticsearch_master_node.tf: This Terraform code creates master node instance.
3. elasticsearch_data_nodes.tf: This Terraform code creates data node instances.
4. master_node_setup.sh: Shell script for installing and configuring master node.
5. data_node_setup.sh: Shell script for installing and configuring data nodes.

# Additional Services Used 
As per the assignment free tier `t2.micro` was to be used, but I faced issues while creating TLS certificates, the server was hanging (memory utilization was more than 85%) and taking lot of time so I have used `t2.medium`.

# References 

1. https://www.elastic.co/guide/en/elasticsearch/plugins/current/discovery-ec2.html
2. https://www.elastic.co/guide/en/elasticsearch/plugins/current/discovery-ec2-usage.html
3. https://medium.com/@abhinav.gupta.2406/ec2-discovery-with-elasticsearch-f9c9b0a67b79
4. https://blog.francium.tech/install-aws-ec2-discovery-plugin-in-elasticsearch-5a973348cad9

# Feedback

This exercise covers Automation, Infrastructure as a code, Configuration Management and Security. The exercise requires knowledge of Elastisearch, completing it in 2.5 hrs is very difficuilt. I have learned many new things after completing the assignment.

# Steps

1. Install `aws cli`
2. Configure `aws cli`
3. Create an `aws profile`
4. Clone the repository
5. Provide a key-pair in variable.tf
6. Update your `aws profile` in elasticsearch_main.tf
7. Run `terraform init`
8. Run `terraform apply`
