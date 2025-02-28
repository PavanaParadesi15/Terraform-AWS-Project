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

// Create Security Group
resource "aws_security_group" "my-sg" {
  vpc_id = aws_vpc.my-vpc.id
  name_prefix = "web_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  // Create Incoming traffic rules and create outgoing traffic rules
  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_sg"
  }
}

// Create S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.aws_s3_bucket
  tags = {
    Name = "my_bucket"
  }
}

// Access Control List (ACL) of an Amazon S3 bucket. 
# resource "aws_s3_bucket_acl" "example" {
# #   depends_on = [
# #     aws_s3_bucket_ownership_controls.example,
# #     aws_s3_bucket_public_access_block.example
# # ]

#   bucket = aws_s3_bucket.my_bucket.bucket
#   acl    = "public-read"
# }

// Create EC2 instance
resource "aws_instance" "webserver-1" {
  ami           = var.ec2_instance_ami
  instance_type = var.ec2_instance_type
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.my-sg.id]
  key_name = "my_keypair"
  user_data = base64encode(file("userdata.sh"))
  tags = {
    Name = "webserver-1"
  }
}

// Create a Ec2 instance 2
resource "aws_instance" "webserver-2" {
  ami           = var.ec2_instance_ami
  instance_type = var.ec2_instance_type
  subnet_id     = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.my-sg.id]
  key_name = "my_keypair"
  user_data = base64encode(file("userdata1.sh"))
  tags = {
    Name = "webserver-2"
  }
}

// Create Application Load Balancer 
// public facing load balancer
// Load Balancer should have access to both subnets
// we have to create target group
resource "aws_lb" "myalb" {
  name               = var.load_balancer_name
  internal           = false
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.my-sg.id]
  subnets            = [aws_subnet.public_subnet.id, aws_subnet.private_subnet.id]
  enable_deletion_protection = false
  enable_http2 = true
  idle_timeout = 60
  tags = {
    Name = "myalb"
  }
}

// Create target group
resource "aws_lb_target_group" "tg" {
  name     = var.aws_lb_target_group_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my-vpc.id
  target_type = "instance"
  health_check {
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

// Attach target group to both Instances
resource "aws_lb_target_group_attachment" "tg_attach1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver-1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "tg_attach2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver-2.id
  port             = 80
}

// Create listener - Target group should be attached to Load Balancer
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.myalb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}