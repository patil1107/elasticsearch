resource "aws_instance" "es_instance_master" {
  ami = var.aws_ami
  instance_type = var.aws_instance_type
  key_name = var.keypair_name
  security_groups = [aws_security_group.es_cluster_sg.name]
  iam_instance_profile = "${aws_iam_instance_profile.es_profile.name}"
  user_data = file("master_node_setup.sh")
  count = "1"

  tags = {
    Name = "master"
    ec2discovery = "es"
  }

}
