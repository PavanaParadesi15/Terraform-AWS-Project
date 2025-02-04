variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
}
variable "region" {
  description = "The region in which the VPC will be created."
}

variable "public_subnet_az" {
  description = "This is the Availability zone for public subnet access"
}
variable "private_subnet_az" {
  description = "This is the Availability zone for private subnet access"
}
variable "public_subnet_cidr_block" {
  description = "The CIDR block for the subnet."
}

variable "private_subnet_cidr_block" {
  description = "The CIDR block for the subnet."
}