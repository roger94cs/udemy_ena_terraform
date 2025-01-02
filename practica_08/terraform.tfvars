subnets = ["10.10.0.0/24", "10.10.1.0/24"]

tags = {
  "env"         = "dev"
  "owner"       = "Roger"
  "cloud"       = "aws"
  "IAC"         = "Terraform"
  "IAC_Version" = "1.10.2"
  "project" = "cerberus"
  "region" = "virginia"
}

sg_ingress_cidr = "0.0.0.0/0"

ec2_specs = {
  "ami" = "ami-01816d07b1128cd2d"
  "instance_type" = "t2.micro"
}

# enable_monitoring = true
enable_monitoring = 0 

ingress_ports_list = [22, 80, 443]