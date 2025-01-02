resource "aws_vpc" "vpc_virginia" {
  cidr_block = "10.10.0.0/16"
  tags = {
    name = "prueba"
    env = "dev"
    Name = "VPC_VIRGINIA"
  }
}


resource "aws_vpc" "vpc_ohio" {
  cidr_block = "10.10.0.0/16"
  tags = {
    name = "prueba"
    env = "dev"
    Name = "VPC_OHIO"
  }
  provider = aws.ohio
}