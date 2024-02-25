# --- network/variables.tf ---

variable "vpc_cidr" {
    type = string
}

variable "public_cidrs" {
    type = list
}

variable "private_cidrs" {
    type = list
}

variable "public_sn_count" {
    type = number
}

variable "private_sn_count" {
    type = number
}

variable "max_subnets"  {}

variable "security_groups" {}

variable "access_ip" {}