#from https://github.com/koding/terraform/tree/master/examples/aws-elb

provider "aws" {
	profile = "terraform-deployer"
	region = "${var.aws_region}"
}

