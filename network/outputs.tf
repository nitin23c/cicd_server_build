# --- network/outputs.tf ---

output "vpc_id" {
  value = aws_vpc.awsgeek0_vpc.id
}

output "public_sg" {
  value = aws_security_group.awsgeek0_sg["public"].id
}

output "public_subnets" {
  value = aws_subnet.awsgeek0_public_subnet.*.id
}