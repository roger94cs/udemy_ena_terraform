resource "aws_vpc" "vpc_virginia" {
  cidr_block = var.virginia_cdir
  tags = {
    name = "prueba"
    env = "dev"
    Name = "VPC_VIRGINIA"
  }
}


resource "aws_vpc" "vpc_ohio" {
  cidr_block = var.ohio_cdir
  tags = {
    name = "prueba"
    env = "dev"
    Name = "VPC_OHIO"
  }
  provider = aws.ohio
}

/*
En el caso de que no se definan el valor de las variables al ejecutar plan o apply nos preguntara sobre el valor delas mismas.

Para crear variables de entorno en linux y mac desde la consola se usa el comando export y empezar con TF_VAR
export TF_VAR_virginia_cdir="10.10.0.0/16"

las variables de entorno se pueden consultar con
env | grep TF

para ejecutar el plan yt asignar un valor a la variable desde la consola se usa
terraform plan -var ohio_cdir="10.20.0.0/16" -var virginia_cdir="10.10.0.0/16"

para borrar la variable de entorno de usa
unset TF_VAR_virgnia_cdir

Usamos el archivo terraform.tfvars para agregar el valor de las variables y para declararlas se usa variables.tf

en caso de que se cambiara el nombre del archivo terraform.tfvars a por ejemplo prueba.tfvars
Al ejecutar el apply nos solicitaría el valor de las variables desde la consola
*/