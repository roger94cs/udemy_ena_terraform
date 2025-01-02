resource "aws_vpc" "vpc_virginia" {
  cidr_block = var.virginia_cidr
  # cidr_block = lookup(var.virginia_cidr, terraform.workspace)
  tags = {
    "Name" = "vpc_virginia"
  }
}


resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc_virginia.id
  cidr_block              = var.subnets[0]
  map_public_ip_on_launch = true // direccionamiento IP publico
  tags = {
    "Name" = "public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc_virginia.id
  cidr_block = var.subnets[1]
  tags = {
    "Name" = "private_subnet"
  }
  depends_on = [
    aws_subnet.public_subnet
  ]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_virginia.id

  tags = {
    Name = "igw vpc virginia"
  }
}

resource "aws_route_table" "public_crt" {
  vpc_id = aws_vpc.vpc_virginia.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public crt"
  }
}

resource "aws_route_table_association" "crta_public_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_crt.id
}

resource "aws_security_group" "sg_public_instance" {
  name        = "Public Instance SG"
  description = "Allow SH inbound traffic and ALL egress traffic"
  vpc_id      = aws_vpc.vpc_virginia.id

  ingress {
    description = "SSH over Internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.sg_ingress_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Public Instance SG"
  }
}

/*
En la mayoría de las situaciones no se recomienda el uso del siguiente comando para auto-aprovarse el apply
terraform apply --auto-approve=true

targeting
Seleccionamos el recurso en donde queremos que se realice el cambio y omita los demás recursos modificados.
terraform apply --target aws_subnet.public_subnet
*/

/*
Repaso
terraform validate

terraform fmt

terraform show

terraform show -json

terraform providers
en nuestro caso amazon

terraform output

terraform output ec2_public_ip

terraform plan 
hace un  refresh del state lee la configuracion de los recursos que ya estan desplegados en busqueda de mmodificaciones y en caso de encontrar alguna modificación va a actualizar el tfstate

terraform refresh
Busca cambios en la infra desplegada y si encuentra cambios actualiza el terraform state
Cuando se ejeucta un apply realiza el refresh en automatico para verificar si encunetra cambios en la infraestructura

terraform graph
Nos brinda una lista de las dependencias y como se interelacionan los recursos desplegados para así generar un grafico a partir de esta información.

terraform graph | dot -Tsvg > graph.svg # No me funciono

terraform graph > graph.dot
Esto generará un archivo en formato DOT, que es un lenguaje de descripción de gráficos de texto

Convierte el archivo DOT a un formato visual como PNG o SVG usando una herramienta como GraphViz. Puedes instalar GraphViz y luego usar el siguiente comando para convertir el archivo:

dot -Tpng graph.dot -o graph.png # No me funciono

Esto creará un archivo graph.png con la representación gráfica de tu configuración de Terraform.

Tuve que convertir en linea el grafico.


terraform state list

terraform state show #nombre_del_recurso
terraform state show aws_instance.public_instance

terraform state mv
mover recursos dentro de nuestro terraform state

terraform state mv aws_subnet.public_subnet aws_subnet.public_subnet_primaria

terraform state mv aws_subnet.public_subnet_primaria aws_subnet.public_subnet

terraform state rm
Borrar recursos en el terraform state (para que "olvide al recurso removido")
No borra recursos desplegados, ni tampoco recursos en los archivos de configuración 

terraform state rm aws_instance.public_instance
(linux) less terraform.tfstate

El recurso seguira en AWS y si queremos eliminarlo tendría que ser desde la consola y tambien debemos borrar o comentar el condigo que hace referencia al recurso apra que no afecte en el plan y ejecucion de terraform

*/
