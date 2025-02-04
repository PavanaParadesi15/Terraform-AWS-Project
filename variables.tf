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

variable "aws_s3_bucket" {
  description = "The name of the S3 bucket"
}

variable "ec2_instance_ami" {
  description = "EC2 instance AMI"
}

variable "ec2_instance_type" {
  description = "The type of EC2 instance to launch."
}