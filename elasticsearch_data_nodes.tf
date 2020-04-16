resource "aws_instance" "es_instance_data" {
  ami = "${var.aws_ami}"
  instance_type = "${var.aws_instance_type}"
  security_groups = ["${aws_security_group.es_cluster_sg.name}"]
  iam_instance_profile = "${aws_iam_instance_profile.elasticsearch_profile.name}"
  user_data = "${file("data_node_setup.sh")}"
  count = "1"

  tags = {
    Name = "data-${count.index}"
    ec2discovery = "es"
  }

}
