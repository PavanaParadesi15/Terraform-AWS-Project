# Terraform-AWS-Project
This is a small terraform project to create AWS resources using terraform 

In this project I am going to create VPC, public and private subnets, Load Balancer, Internet Gateway, EC2 instances, S3 bucket, Target group and listeners. 

# Install AWS CLI

* Its a pre-requisite for terraform that, when we are configuring terraform with AWS, we should authenticate cloud provider with CLI. I am using Linux VM to setup with terraform and apply the scripts to create resources in AWS.
* So using AWS CLI, authenticate AWS cloud by providing access key and secret access key.
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip -y
unzip awscliv2.zip
sudo ./aws/install
aws --version
```

### Configure AWS
```
aws configure
```
provide access key and secret access key

# Install Terraform

https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

We can create a seperate repo for terraform modules for each AWS resource. We can call the module to the main.tf file (give module path in the source) and pass the values in tfvars file and execute terraform.


* In this project , there is VPC, with public and private subnets. This VPC is connected with Internet Gateway (IG). 
* Internet Gateway is created and attached to VPC and define routes in Route Table.
* To give access for Internet Gateway to Subnets, a Route table should be created.
* Route tables defines the flow, how the traffic should flow from IG to Subnet
* There is route table to define that the IG should connect to which subnet
* EC2 instances are created in both subnets and attach IAM roles.
* IAM roles are created for EC2 instances .
* Create Security groups for EC2 instance
* A Load Balancer is placed before the EC2 instances and these instances connects to S3 bucket

* We can use EC2 instance user data, with bash script to install few softwares in the instances. 






