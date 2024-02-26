# --- compute/main.tf ---

data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "random_id" "awsgeek0_nodeid" {
  byte_length = 2
  count       = var.instance_count
  
  # forces awsgeek0_nodeid to change when we may replace key_name while we destroy and apply
  keepers = {
    key_name = var.key_name
  }
}

resource "aws_key_pair" "awsgeek0_key_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "awsgeek0_node" {
  count         = var.instance_count # 1
  instance_type = var.instance_type  # t3.micro

  ami = data.aws_ami.server_ami.id

  tags = {
    Name = "awsgeek0_node-${random_id.awsgeek0_nodeid[count.index].dec}"
  }

  key_name               = aws_key_pair.awsgeek0_key_auth.id
  vpc_security_group_ids = [var.public_sg]
  subnet_id              = var.public_subnets[count.index]
  user_data = file(var.user_data_path)
  root_block_device {
    volume_size = var.vol_size # 10
  }

}