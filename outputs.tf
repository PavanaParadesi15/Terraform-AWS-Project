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
  value = aws_instance.webserver-1.public_ip
}

output "public-ip-address-2" {
  value = aws_instance.webserver-2.public_ip
}

output "load_balancer_dns" {
  value = aws_lb.myalb.dns_name
}
