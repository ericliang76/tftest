variable "key_name" {
  description = "Name of the SSH keypair to use in AWS."
}

variable "aws_region" {
  description = "AWS region to launch servers."
#  default     = "us-east-1"
}

# ubuntu-trusty-14.04 (x64)
#variable "aws_amis" {
#  default = {
#    "us-east-1" = "ami-5f709f34"
#    "us-west-2" = "ami-7f675e4f"
#  }
#}
# latest RHEL 7 ami
data "aws_ami" "latest-rhel7" {
    most_recent = true

    filter {
        name   = "name"
        values = ["RHEL-7*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
    filter {
        name   = "architecture"
        values = ["x86_64"]
    }


    owners = ["309956199498"] # REDHAT
}
