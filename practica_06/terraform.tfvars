# virginia_cidr = "10.10.0.0/16"

# virginia_cidr = {
#   "prod" = "10.10.0.0/16"
#   "dev" = "172.16.0.0/16"
# }

# public_subnet = "10.10.0.0/24"
# private_subnet = "10.10.1.0/24"

subnets = ["10.10.0.0/24", "10.10.1.0/24"]

tags = {
  "env"         = "dev"
  "owner"       = "Roger"
  "cloud"       = "aws"
  "IAC"         = "Terraform"
  "IAC_Version" = "1.10.2"
}

sg_ingress_cidr = "0.0.0.0/0"

ec2_specs = {
  "ami" = "ami-01816d07b1128cd2d"
  "instance_type" = "t2.micro"
}
