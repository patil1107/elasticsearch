provider "aws" {
  profile = var.aws_profile
  region = var.aws_region
  }

resource "aws_security_group" "es_cluster_sg" {
  name = "es_cluster_sg"
  description = "Security group for Elasticsearch"

ingress {
 from_port = "22"
 to_port = "22"
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
 }

ingress {
 from_port = "9200"
 to_port = "9200"
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
 }

ingress {
 from_port = "9300"
 to_port = "9300"
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
 }

egress {
 from_port   = 0
 to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "elasticsearch_iam_role" {
  name = "elasticsearch_iam_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "elasticsearch_iam_policy_document" {
  statement {
    sid = "1"

    actions = [
      "ec2:DescribeInstances"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "elasticsearch_iam_policy" {
  name   = "elasticsearch_iam_policy"
  policy = "${data.aws_iam_policy_document.elasticsearch_iam_policy_document.json}"
}

resource "aws_iam_role_policy_attachment" "elasticsearch_iam_role_policy" {
  role       = "${aws_iam_role.elasticsearch_iam_role.name}"
  policy_arn = "${aws_iam_policy.elasticsearch_iam_policy.arn}"
}

resource "aws_iam_instance_profile" "es_profile" {
  name  = "es_profile"
  role = "${aws_iam_role.elasticsearch_iam_role.name}"
}
