terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 4.36.0, <4.47.0, !=4.43.0"
    }
  }
  required_version = "~>1.10.0"
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}

provider "aws" {
  # Configuration options
  region = "us-east-2"
  alias = "ohio"
}

/*
Cuando queremos cambiar la versión de terraform se usa el siguiente comando

terraform init -upgrade


Comandos linux
ls

ls -a // para ver archivos ocultos

tree .terraform // ver arbol de carpetas

rm -rf .terraform // borrar la carpeta para descargar de nuevo la versión elegida de terraform

terraform init
*/