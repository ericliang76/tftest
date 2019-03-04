resource "aws_vpc" "default" {
  cidr_block           = "10.0.0.0/16"
  cidr_block = "${var.aws_vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "dns-vpc"
  }
}

resource "aws_subnet" "dns_subnet_1" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${var.dns_subnet_1}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.dns1_az}"

  tags {
    Name = "dns_subnet_1"
  }
}

resource "aws_subnet" "dns_subnet_2" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${var.dns_subnet_2}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.dns2_az}"

  tags {
    Name = "dns_subnet_2"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "dns_ig"
  }
}

resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "aws_route_table"
  }
}

resource "aws_route_table_association" "1" {
  subnet_id      = "${aws_subnet.dns_subnet_1.id}"
  route_table_id = "${aws_route_table.r.id}"
}
resource "aws_route_table_association" "2" {
  subnet_id      = "${aws_subnet.dns_subnet_2.id}"
  route_table_id = "${aws_route_table.r.id}"
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name        = "instance_sg"
  description = "Used in the terraform"
  vpc_id      = "${aws_vpc.default.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # DNS access from anywhere
  ingress {
    from_port   = 53 
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 53 
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Our elb security group to access
# the ELB over HTTP

resource "aws_instance" "dns1" {
  instance_type = "t2.micro"

  ami = "${data.aws_ami.latest-ubuntu.id}"

  # The name of our SSH keypair you've created and downloaded
  #
  key_name = "${var.key_name}"

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  subnet_id              = "${aws_subnet.dns_subnet_1.id}"
  user_data              = "${file("userdata.sh")}"
  availability_zone      = "${var.dns1_az}"

  #Instance tags

  tags {
    Name = "dns1"
  }
}
resource "aws_instance" "dns2" {
  instance_type = "t2.micro"

  ami = "${data.aws_ami.latest-ubuntu.id}"

  # The name of our SSH keypair you've created and downloaded
  #
  key_name = "${var.key_name}"

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  subnet_id              = "${aws_subnet.dns_subnet_2.id}"
  user_data              = "${file("userdata.sh")}"
  availability_zone      = "${var.dns2_az}"

  #Instance tags

  tags {
    Name = "dns2"
  }
}
