variable "instancias" {
  description = "Nombre de las instancias"
  # type        = list(string)
  # type        = set(string)
  type    = list(string)
  # default = ["apache", "jumpserver", "mysql"]
  default = ["apache", "jumpserver"]
  # default = ["apache"]
}

resource "aws_instance" "public_instance" {
  # count = length(var.instancias)
  # for_each               = var.instancias
  for_each               = toset(var.instancias)
  ami                    = var.ec2_specs.ami
  instance_type          = var.ec2_specs.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = data.aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]
  user_data              = file("scripts/userdata.sh")
  tags = {
    # "Name" = var.instancias[count.index]
    "Name" = "${each.value}-${local.sufix}"
  }
}

resource "aws_instance" "monitoring_instance" {
  # count = var.enable_monitoring ? 1 : 0
  count                  = var.enable_monitoring == 1 ? 1 : 0
  ami                    = var.ec2_specs.ami
  instance_type          = var.ec2_specs.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = data.aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]
  user_data              = file("scripts/userdata.sh")
  tags = {
    "Name" = "Monitoreo-${local.sufix}"
  }
}

# variable "cadena" {
#   type = string
#   default = "ami-123,AMI-AAV,ami-12f"
# }

# variable "palabras" {
#   type = list(string)
#   default = ["hola","como","estan"]
# }

# variable "entornos" {
#   type = map(string)
#   default = {
#     "prod" = "10.10.0.0/16"
#     "dev" = "172.16.0.0/16"
#   }
# }

/*
El forecah a diferencia del count solo puede ser usado con variables de tipo set y map 

count crea un array al eliminar un elemento altera al resto de elementos

list foreach no funciona con listas
si una lista es usada en otro recurso no podríamos transformala en set porque estaría rompiendo código en otro lado
por ello usamos la función toset()
*/


/*
funciones
terraform console
1+1
4/4
file("scripts/userdata.sh")
toset(var.instancias)
length(var.instancias)
max(-1,4,500,20)
min(-1,4,500,20)
ceil(12.4) <- redondea al entero superior
floor(12.6) <- redondea al entero inferior
split(",",var.cadena)
lower(var.cadena)
upper(var.cadena)
title(var.cadena)
substr(var.cadena,2,7)
join("-",var.palabras)
length(var.palabras)
index(var.palabras,"como")
En caso de que no encuentre la palabra dara un error item not found

element(var.palabras,2)
contains(var.palabras,"prueba")
contains(var.palabras,"hola")
Si encuentra el elemento da true
caso contrario da false
keys(var.entornos)
values(var.entornos)
lookup(var.entornos,"prod")
lookup(var.entornos,"dev")
lookup(var.entornos,"stage") <- error no existe
lookup(var.entornos,"stage","no-existe")
*/

/*
Condiciones

> 1 == 1
true
> 1 == 2
false
> 1 > 2
false
> 1 < 1
false
> 1 >= 2
false
> 1 >= 1
true
> 2 != 3
true
> !(2!=3)
false
> (1==1)&&(2==2)
true
> (1==1)&&(2==1)
false
> (1==1)&&!(2==1)
true
!((1==1)&&!(2==1))
false
(1==1)||(2==1)
true
(1==3)||(2==1)
false
*/
