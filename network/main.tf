# --- network/main.tf ---

data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_integer" "random" {
    min = 1
    max = 100
}

resource "random_shuffle" "az_list" {
    input = data.aws_availability_zones.available.names
    result_count = var.max_subnets
}

# Create a VPC
resource "aws_vpc" "awsgeek0_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "awsgeek0-${random_integer.random.id}"
  }
}

resource "aws_subnet" "awsgeek0_private_subnet" {
  count = var.private_sn_count
  vpc_id     = aws_vpc.awsgeek0_vpc.id
  cidr_block = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "awsgeek0_private_subnet"
  }
}

resource "aws_subnet" "awsgeek0_public_subnet" {
  count = var.private_sn_count
  vpc_id     = aws_vpc.awsgeek0_vpc.id
  cidr_block = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "awsgeek0_public_subnet"
  }
}