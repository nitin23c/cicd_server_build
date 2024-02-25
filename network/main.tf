# --- network/main.tf ---

resource "random_integer" "random" {
    min = 1
    max = 100
}

# Create a VPC
resource "aws_vpc" "awsgeek0_vpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "awsgeek0-${random_integer.random.id}"
  }
}