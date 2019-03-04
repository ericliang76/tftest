variable "key_name" {
  description = "Name of the SSH keypair to use in AWS."
  default = "lianger-mac-kp"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

variable "dns1_az" {
  description = "AZ for dns1"
  default = "us-east-1a"
}

variable "dns2_az" {
  description = "AZ for dns1"
  default = "us-east-1b"
}

variable "aws_vpc_cidr" {
  description = "CIDR for dns vpc"
  default = "10.0.0.0/16"
}

variable "dns_subnet_1" {
  description = "CIDR for subnet for dns server 1"
  default = "10.0.0.0/24"
}

variable "dns_subnet_2" {
  description = "CIDR for subnet for dns server 1"
  default = "10.0.1.0/24"
}

# ubuntu-trusty-14.04 (x64)
#variable "aws_amis" {
#  default = {
#    "us-east-1" = "ami-5f709f34"
#    "us-west-2" = "ami-7f675e4f"
#  }
#}
# latest RHEL 7 ami
data "aws_ami" "latest-ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["CIS Centos Linux 7*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
    filter {
        name   = "architecture"
        values = ["x86_64"]
    }


    owners = ["679593333241"] # canonical/ubuntu
}

