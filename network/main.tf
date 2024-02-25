# --- network/main.tf ---

# Create a VPC
resource "aws_vpc" "awsgeek0_vpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
}