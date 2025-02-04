// Create VPC

resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc_cidr_block
  //region = var.region
}

// Create Public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = var.public_subnet_cidr_block
  availability_zone = var.public_subnet_az
  map_public_ip_on_launch = true
}

// Create Private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = var.private_subnet_cidr_block
  availability_zone = var.private_subnet_az
  map_public_ip_on_launch = true
}

// Create Internet Gateway
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
}

// Create route table and route. 
// All the traffic from vpc (0.0.0.0/0) will be routed to Internet Gateway
// Now attach the subnets to the route table
resource "aws_route_table" "my-RT" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
}

// Route table associated with public subnet
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.my-RT.id
}

// Route table association with private subnet
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.my-RT.id
}
