resource "aws_s3_bucket" "proveedores" {
    count = 6
  bucket = "proveedores-${random_string.sufijo[count.index].id}"
  tags = {
    Owner = "Roger"
    Environment = "Dev"
    Office = "proveedores"
  }
}

resource "random_string" "sufijo" {
  count   = 6
  length  = 10
  special = false
  upper   = false
  numeric = false
}

/*
terraform plan --out s3.plan

terraform apply s3.plan
*/