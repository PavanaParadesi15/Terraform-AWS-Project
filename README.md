# Terraform-AWS-Project
This is a small terraform project to create AWS resources using terraform 

In this project I am going to create VPC, public and private subnets, Load Balancer, Internet Gateway, EC2 instances, S3 bucket, Target group and listeners. 
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


# Terraform commands used

```
terraform init                  // to initialize terraform in a code folder
terraform validate              // shows if the configuration is valid or not
terraform plan                  // creates a plan listing what all resources to be created.
terraform apply                 // applies the created plan
terraform apply --auto=approve
terraform destroy               // destroys the resources
```

## End output

* An IAM User is created with necessary permissions to create all the below resources through terraform script.
* I logged in as IAM user, created an EC2 instance which is the base server to install and run terraform scripts to create different AWS resource.
* Created a VPC, Public and private subnet
   * VPC (Virtual Private Cloud): A virtual network dedicated to your AWS account.
   * Public Subnet: A subnet within the VPC that allows incoming traffic from the internet.
   * Private Subnet: A subnet within the VPC that does not allow incoming traffic from the internet.
   * Internet Gateway: A gateway that connects your VPC to the internet. 
* A Security Group: A virtual firewall that controls incoming and outgoing traffic to your EC2 instances is created.
* S3 Bucket: An object storage bucket that can store files and data is created.

2 EC2 instances are created
* EC2 Instance 1 (webserver-1): A virtual server that runs in the public subnet.
* EC2 Instance 2 (webserver-2): A virtual server that runs in the private subnet.

**Load Balancing Resources**
  * Application Load Balancer (ALB): A load balancer that distributes incoming traffic to multiple EC2 instances.
  * Target Group: A logical group of EC2 instances that receive traffic from the ALB.
  * Listener: A configuration that defines how the ALB routes traffic to the target group.

Application can be accessed using load balancer DNS name and we can check how the traffic is getting routed to different EC2 instance. 

