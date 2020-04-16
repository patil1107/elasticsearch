variable "aws_region" {
  default = "us-east-1"
}

variable "aws_secret_key" {
 default = ""
}

variable "keypair_name" {
 default = "es_keys"
}

variable "aws_access_key" {
 default = ""
}

variable "aws_ami" {
  default = "ami-0323c3dd2da7fb37d"
}

variable "aws_instance_type" {
  default = "t2.micro"
}
