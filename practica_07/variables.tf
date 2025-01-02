variable "virginia_cidr" {
  description = "CIDR Virginia"
  type = string
}

variable "subnets" {
  description = "Lista de subnets"
  type        = list(string)
}

variable "tags" {
  description = "tags del proyecto"
  type        = map(string)
}

variable "sg_ingress_cidr" {
  description = "CIDR for ingress traffic"
  type = string
}

variable "ec2_specs" {
  description = "Parametros de la instancia"
  type = map(string)
}

variable "enable_monitoring" {
  description = "habilita el despliegue de un servidor de monitoreo"
  # type = bool
  type = number
}

variable "ingress_ports_list" {
  description = "Lista de puertos de ingresss"
  type = list(number)
}