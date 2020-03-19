/* resource "aws_vpc" "vpc" {
  cidr_block           = "${lookup(var.vpc_cidr_block, var.env)}"
  enable_dns_hostnames = "true"

  tags = {
    Name = "${var.env}-vpc"
  }
} */

data "aws_vpc" "selected" {
  id = "${var.vpc_id}"
}


resource "aws_subnet" "public_sub1" {
  vpc_id                  = "${data.aws_vpc.selected.id}"
  cidr_block              = "${lookup(var.public_sub1_cidr_block, var.env)}"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${var.env}-pub-sub-1a-1.0"
  }
}

resource "aws_subnet" "public_sub2" {
  vpc_id                  = "${data.aws_vpc.selected.id}"
  cidr_block              = "${lookup(var.public_sub2_cidr_block, var.env)}"
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${var.env}-pub-sub-1b-2.0"
  }
}

resource "aws_subnet" "private_sub1" {
  vpc_id                  = "${data.aws_vpc.selected.id}"
  cidr_block              = "${lookup(var.private_sub1_cidr_block, var.env)}"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "${var.env}-private-sub-1a-3.0"
  }
}

resource "aws_subnet" "private_sub2" {
  vpc_id                  = "${data.aws_vpc.selected.id}"
  cidr_block              = "${lookup(var.private_sub2_cidr_block, var.env)}"
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "${var.env}-private-sub-1b-4.0"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = "${data.aws_vpc.selected.id}"

  tags = {
    Name = "${var.env}-igw"
  }
}

resource "aws_eip" "nat_eip" {
  vpc = "true"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id     = "${aws_subnet.public_sub1.id}"

  tags = {
    Name = "${var.env}-ng"
  }
}

resource "aws_route_table" "pub_rtb" {
  vpc_id = "${data.aws_vpc.selected.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name = "${var.env}-pub-rtb"
  }
}

resource "aws_route_table" "private_rtb" {
  vpc_id = "${data.aws_vpc.selected.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat_gw.id}"
  }

  tags = {
    Name = "${var.env}-private-rtb"
  }
}

resource "aws_route_table_association" "public_sub1_rtb_assoc" {
  subnet_id      = "${aws_subnet.public_sub1.id}"
  route_table_id = "${aws_route_table.pub_rtb.id}"
}

resource "aws_route_table_association" "public_sub2_rtb_assoc" {
  subnet_id      = "${aws_subnet.public_sub2.id}"
  route_table_id = "${aws_route_table.pub_rtb.id}"
}

resource "aws_route_table_association" "private_sub1_rtb_assoc" {
  subnet_id      = "${aws_subnet.private_sub1.id}"
  route_table_id = "${aws_route_table.private_rtb.id}"
}

resource "aws_route_table_association" "private_sub2_rtb_assoc" {
  subnet_id      = "${aws_subnet.private_sub2.id}"
  route_table_id = "${aws_route_table.private_rtb.id}"
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${data.aws_vpc.selected.id}"

  ingress{
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}

resource "aws_network_acl" "pub_nacl" {
  vpc_id = "${data.aws_vpc.selected.id}"
  subnet_ids = [
    "${aws_subnet.public_sub1.id}",
    "${aws_subnet.public_sub2.id}"
  ]

  tags = {
    Name = "${var.env}-pub-nacl"
  }
}

resource "aws_network_acl" "private_nacl" {
  vpc_id = "${data.aws_vpc.selected.id}"
  subnet_ids = [
    "${aws_subnet.private_sub1.id}",
    "${aws_subnet.private_sub2.id}"
  ]

  tags = {
    Name = "${var.env}-private-nacl"
  }
}
