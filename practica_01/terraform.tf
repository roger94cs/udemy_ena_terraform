resource "local_file" "productos" {
  content  = "Lista de productos para el mes proximo"
  filename = "productos.txt"
}
/* 
terraform init (descargar el provider necesario apra ejecutar el codigo lo infiere automaticamente) 
terraform plan  (genera un plan en base a todo nuestro código y nos mostrara las acciones a realizar)
+ -> crear
terraform apply (crea el plan y lo ejecuta ejecuta implisitamente el plan)
-/+ -> borrar y crear replaced
terraform destroy

(comando linux para copiar archivos)
cp -a practica_01 practica_02 
*/


/*
comando que se usa para dar formato a los archivos en terraform 
terraform fmt

debes de especificar un nombre para que no fecte a todos los archivos
terraform fmt terraform.tf

terraform validate

La diferencia entre el validate y plan es que el plan puede tardar más tiempo en completarse en un código extenso
Y así perdemos tiempo, en cambio validate se ejecuta más rapido
*/
