terraform {
  required_version = ">= 0.12.2"

  backend "s3" {
    region         = "us-east-1"
    bucket         = "example23122024-us-east-1-prod-terraform-state"
    key            = "terraform.tfstate"
    dynamodb_table = "example23122024-us-east-1-prod-terraform-state-lock"
    profile        = ""
    #role_arn       = "" <- se borra esta línea si no da el error Error: Unsupported argument
    encrypt        = "true"
  }
}
