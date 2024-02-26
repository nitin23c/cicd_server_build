# --- root/locals.tf ---
locals {
  vpc_cidr = "10.123.0.0/16"
}

locals {
  security_groups = {
    public = {
      name        = "public_sg"
      description = "Security group for public access"
      ingress = {
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
        sonarqube = {
          from        = 9000
          to          = 9000
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
        jenkins = {
          from        = 8080
          to          = 8080
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
      }
    }

    rds_sg = {
      name        = "rds_sg"
      description = "Security group for public access"
      ingress = {
        rds = {
          from        = 3306
          to          = 3306
          protocol    = "tcp"
          cidr_blocks = [local.vpc_cidr]
        }
      }
    }
  }
}