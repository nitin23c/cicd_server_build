# --- network/main.tf ---

data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}

# Create a VPC
resource "aws_vpc" "awsgeek0_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "awsgeek0-${random_integer.random.id}"
  }
}

resource "aws_subnet" "awsgeek0_private_subnet" {
  count                   = var.private_sn_count
  vpc_id                  = aws_vpc.awsgeek0_vpc.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "awsgeek0_private_subnet"
  }
}

resource "aws_subnet" "awsgeek0_public_subnet" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.awsgeek0_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "awsgeek0_public_subnet"
  }
}

resource "aws_route_table_association" "awsgeek0_public_subnet_assoc" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.awsgeek0_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.awsgeek0_public_route_table.id
}

resource "aws_internet_gateway" "awsgeek0_igw" {
  vpc_id = aws_vpc.awsgeek0_vpc.id

  tags = {
    Name = "awsgeek0_igw"
  }
}

resource "aws_route_table" "awsgeek0_public_route_table" {
  vpc_id = aws_vpc.awsgeek0_vpc.id

  tags = {
    Name = "awsgeek0_public_route_table"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.awsgeek0_public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.awsgeek0_igw.id
}

resource "aws_default_route_table" "awsgeek0_private_route_table" {
  default_route_table_id = aws_vpc.awsgeek0_vpc.default_route_table_id

  tags = {
    Name = "awsgeek0_private_route_table"
  }
}

resource "aws_security_group" "awsgeek0_sg" {
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.awsgeek0_vpc.id

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}