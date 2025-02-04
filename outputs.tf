// This following code prints public ip address of EC2 instance as output
// for the value :- it should be combination of "resource and resource name" followed by the value name we want to print

output "vpc_id" {
  value = aws_vpc.my-vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "public-ip-address" {
  value = aws_instance.example-1.public_ip
}