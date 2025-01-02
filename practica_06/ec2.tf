# ami-01816d07b1128cd2d

resource "aws_instance" "public_instance" {
  ami                    = var.ec2_specs.ami
  instance_type          = var.ec2_specs.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = data.aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]
  user_data = file("scripts/userdata.sh")

# funciono
# user_data = <<-EOF
#             #!/bin/bash 
#             echo "Hello world" > /home/ec2-user/hello.txt 
#             EOF 

# No encontre el archivo.
# user_data = <<-EOF
#   #!/bin/bash
#   echo "Hello, World!" > hello.txt
# EOF


# No me funciono
# user_data              = <<EOF
#   #!/bin/bash
#   echo "Este es un mensaje" > ~/mensaje.txt
# EOF

# se ejecuta cuando la instancia es creada
provisioner "local-exec" {
  command = "echo instancia creada con IP ${aws_instance.public_instance.public_ip} >> datos_instancia.txt"
}

provisioner "local-exec" {
  when    = destroy
  command = "echo instancia ${self.public_ip} destruida >> datos_instancia.txt"
}

# Esto no se usa 
# provisioner "remote-exec" {
#   inline = [ 
#     "echo 'Hola mundo' > ~/saludo.txt"
#    ]

#    connection {
#      type = "ssh"
#      host = self.public_ip
#      user = "ec2-user"
#      private_key = file("mykey.pem")
#    }
# }

#lifecycle {
# create_before_destroy = true
# prevent_destroy = true # No destruyas este recurso
# ignore_changes = [ 
#   ami,
#   subnet_id
#  ]
#replace_triggered_by = [ 
#aws_subnet.private_subnet 
#aws_subnet.private_subnet.id
#]
#}
}

/*
Lifecycle
Nos permite defnidir como se va acomportar terraform con respecto a nuestros recursos cuando tengamos algún cambio como por ejemplo en algunos de los parametros de los recursos podemos definir si queremos que lo ignore, reemplace el recurso, o que ignore los cambios 

*/

# (linux) ssh -i mykey.pem ec2-user@44.222.250.41

/*
Conexión remota para windows a instancia EC2 (Usando Putty)
https://www.clickittech.com.mx/aws/acceder-a-una-instancia-ec2-usando-ssh/
*/

/*
Provisioners
Nos permiten ejecutar codigo en nuestra computadora local o remota
no se usa mucho codigo en al instancia ya que excisten mejores maneras

terraform destroy --target=aws_instance.public_instance --auto-approve

#sería el equivalente a hacer un destroy y despues un apply
terraform apply --replace=aws_instance.public_instance --auto-approve


Comandos usados en la conexion remota
ls
sudo su
cd
ls
cat mensaje.txt
*/

/*
# terraform taint
terraform state list

terraform taint aws_instance.public_instance

terraform plan

terraform untaint aws_instance.public_instance

terraform plan

terraform apply --replace=aws_instance.public_instance --auto-approve
*/

/*
# Terraform Logging/Debug

(linux) env | grep TF_LOG
(linux) export TF_LOG=TRACE
(linux) export TF_LOG_PATH=logs.txt
(linux) unset TF_LOG
(linux) unset TF_LOG_PATH

Get-ChildItem Env:
Get-ChildItem Env:TF_LOG
Get-ChildItem Env:TF_LOG_PATH

$env:TF_LOG = "TRACE"

$env:TF_LOG_PATH = "logs.txt"

terraform plan

Remove-Item Env:TF_LOG
Remove-Item Env:TF_LOG_PATH

*/

/*
# Importar recursos

terraform state list

terraform state rm aws_instance.public_instance

# Comentamos el código de la instancia

terraform import aws_instance.mywebserver i-09cd7df00184604be

# obtiene la información del recursos y lo guarda en el terraform state no en el código

terraform state list

terraform state show aws_instance.mywebserver

# copiamos la información del recurso y lo pegamos en el codigo
# tenemos que eliminar muchos aprametros que no son necesarios

terraform plan
*/

# resource "aws_instance" "mywebserver" {
#   ami                                  = "ami-01816d07b1128cd2d"
#   instance_type                        = "t2.micro"
#   key_name                             = data.aws_key_pair.key.key_name
#   subnet_id                            = aws_subnet.public_subnet.id
#   tags = {
#     "Name" = "MyServer"
#   }
#   vpc_security_group_ids = [
#     aws_security_group.sg_public_instance.id,
#   ]
# }

/*
Terraform Workspaces
Nos permiten reutilizar nuestro codigo para desplegarlo en diferentes entornos como development  o production
No es popular y no se usa mucho

terraform workspace list

terraform workspace new prod

terraform workspace select default

terraform workspace new dev

terraform workspace show

terraform workspace delete prod
terraform workspace delete dev
*/

