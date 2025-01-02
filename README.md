# Terraform

## IaC orientado a la configuración

- Su finalidad es instalar y gestionar software (aprovisionamiento de servidores)
- Nos permite mantener un estándar en nuestros servidores.
- Podemos tener un control de versiones de nuestros despliegues.

## IaC orientado a Servidores (Templates)
- Nos permite tener pre-instalado el software y las dependencias necesarias.
- Funciona tanto para VM  como para Contenedores.
- Infraestructura Inmutable.

## IaC para aprovisionamiento
- Infraestructura como codigo DECLARATIVO.
- Aprovionar recursos INMUTABLES en nuestra infraestructura.
- Toda clase de recursos como instancias, base de datos, buckets, vpc, etc...
- Podemos deployar infraestructura en multiples providers (Terraform)

## HCL - Hashicorp Configuration Lnaguaje - Declarativo

Tipo de bloque  
Tipo de recursos. local = provider; file = recursos  
Nombre del recurso  
Argumentos   

```hcl
resource "local_file" "mensaje" {
    content  = "Este es un curso de Terraform"
    filename = "archivo.txt"
}
```

## DRY 
Don't Repeat Yourself  

- Terraform puede crear hasta 10 elementos en paralelo  

## Restringir las versiones de Terraform y Providers

```hcl
terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~>4"
        }
    }
    required_version = "1.3.6"
}
```

### Terraform Constraints
| Required version | Meaning                                            | Considerations                                                |
|------------------|----------------------------------------------------|---------------------------------------------------------------|
| 0.15.0           | Only terraform v0.15.0 exactly                     | To upgrade Terraform, first edit the required version setting |
| >= 0.15.0        | Any terraform v0.15.0 or greater                   | Includes Terraform v1.0.0 and above                           |
| ~>0.15.0         | Any terraform v0.15.x, but not v1.0 or later       | Minor version updates are intended to be non-disruptive       |
| >= 0.15, <2.0.0  | Terraform v0.15.0 or greater, but less than v2.0.0 | Avoids major version updates                                  |

## Variables

```
resorce "aws_vpc" "vpc_virginia" {
    cidr_block = "10.10.0.0/16"
    tags = {
        Name = "VPC_VIRGINIA"
        name = "prueba"
        env = "dev"
    }
}
```
```
resorce "aws_vpc" "vpc_ohio" {
    cidr_block = "10.10.0.0/16"
    tags = {
        Name = "VPC_OHIO"
        name = "prueba"
        env = "dev"
    }
    provider = aws.ohio
}
```
===========>
```
resorce "aws_vpc" "vpc_virginia" {
    cidr_block = var.virginia_cidr
    tags = var.tags
}
```
```
resorce "aws_vpc" "vpc_ohio" {
    cidr_block = var.virginia_cidr
    tags = var.tags
    provider = aws.ohio
}
```

### Valores aplicados automaticamente

Bien:
- terraform.tfvars
- terraform.tfvars.json
- *.auto.tfvars
- *.auto.tfvars.json

Para agregar un nombre personalizado de usa auto.  

Mal:
- proyecto.tfvars 

En caso de que no se usen los nombres sugeridos y se tenga otro se puede usa el siguiente comando desde la consola
terraform plan --var-file prueba.tfvars

### Prioridad en la definición de las variables

| Orden | Definición                                          |
|-------|-----------------------------------------------------|
| 1     | Variable de entorno (export TF_VAR_ejemplo="valor") |
| 2     | terraform.tfvars                                    |
| 3     | *.auto.tfvars (por orden alfabetico)                |
| 4     | -var o --var-file (por línea de comandos)           |

## Tipos de variables

| Tipo   | Ejemplo                                      |
|--------|----------------------------------------------|
| string | "10.10.0.0/16" "este es un ejemplo"          |
| number | 1                                            |
| bool   | true/false                                   |
| any    | cualquier tipo (este es el tipo por defecto) |

```
variable "virginia_cidr" {
    default = "10.10.0.0/16"
    description = "CIDR de la VPC de Virginia"
    type = string
    sesitive = true
}

variable "ohio_cidr" {
    default = "10.20.0.0/16"
    description = "CIDR  de la VPC  de Ohio"
    type = string
    sensitive = false
}
```

- con sensitive true con el plan aply show no se muestre el valor de la variable flase es por defecto
- es importante ingresar el tipo de la variable es mala practica usar any

### Conversión de tipos de variables

| Solamente                   |
|-----------------------------|
| String a number y viceversa |
| String a bool y viceversa   |

```
varibale "cantidad" {
    default = 5
    type = number
}

variable "cantidad" {
    default = "5"
    type = number
}
```

```
variable "habilitado" {
    default = false
    type = bool
}

variable "habilitado {
    default = "false"
    type = bool
}"
```

### Tipo: listas

- Las listas admiten elementos repetidos
- Todos los elementos de una lista deben ser del mismo tipo (ej. números o strings)

```
variable "lista_cidrs" {
    default = ["10.10.0.0/16", "10.20.0.0/16"]
    #           Posicion 0     Posicion 1
    type = list(string)
}
```

```
resource "aws_vpc" "vpc_virginia" {
    cidr_block = var.lista_cidrs[0]
    tags = {
        Name = "VPC_VIRGINIA"
        name = "prueba"
        env = "dev"
    }
}

resource "aws_vpc" "vpc_ohio" {
    cidr_block = var.lista_cidrs[1]
    tags = {
        Name = "VPC_OHIO"
        name = "prueba"
        env = "dev"
    }
    provider = aws.ohio
}
```

### Tipo: map

```
variable "map_cidrs" {
    default = {
        "virginia" = "10.10.0.0/16"
        "ohio"     = "10.20.0.0/16"
    }
    type = map(string)
}
```

```
resource "aws_vpc" "vpc_virginia" {
    cidr_block = var.map_cidrs["virginia"]
    tags = {
        Name = "VPC_VIRGINIA"
        name = "pruba"
        env  = "dev"
    }
}

resource "aws_vpc" "vpc_ohio" {
    cidr_block = var.map_cidrs["ohio"]
    tags = {
        Name = "VPC_OHIO"
        name = "prueba"
        env  = "dev"
    }
    provider = aws.ohio
}
```

### Tipo: set

- Set no admite elementos repetidos.
- No podemos acceder a elementos puntuales

```
variable "set_cidrs" {
    default = ["10.10.0.0/16", "10.20.0.0/16"]
    type = set(string)
}
```

```
resource "aws_vpc" "vpc" {
    for_each = var.set_cidrs
    cidr_block = each.value
    tags = {
        Name = VPC_TEST
        name = "prueba"
        env = "dev"
    }
}
```

### Tipo: Object

```
variable "virginia" {
    type = object({
        nombre     = string
        cantidad   = number
        cidrs      = list(string)
        disponible = bool
        env        = string
        owner      = string
    })

    default = {
        cantidad   = 1
        cidrs      = ["10.10.0.0/16"]
        disponible = true
        env        = "dev"
        nombre     = "Virginia"
        owner      = "Nazareno"
    }
}
```

```
resource "aws_vpc" "vpc_virginia" {
    cidr_block = var.virginia.cidrs[0]
    tags = {
        Name = var.virginia.nombre
        name = var.virginia.nombre
        env = var.virginia.env
    }
}
```

### Tipo: tuple

- Una tupla es similar a una lista per puede contener diferentes tipos de elementos.

```
variable "ohio" {
    type    = tuple([string, string, number, bool, string])
    default = ["Ohio", "10.20.0.0/16", 1, false, "dev"]
}
```

```
resource "aws_vpc" "vpc_ohio" {
    cidr_block = var.ohio[1]
    tags = {
        Name = var.ohio[0]
        name = var.ohio[0]
        env  = var.ohio[4]
    }
}
```

### Tipo: output
- Nos sirven para exponer por pantalla elementos o valores que despues de usar una apply Terraform puede obtener esos datos y mostrarla en pantalla

```
output "linux_ppublic_ip" {
    value       = aws_instance.linux.punlic_ip
    description = "Muestro la ip publica asignada a la instancia"
}
```

Ejecutamos el terraform apply y en la terminal nos mostrara la siguiente sección:
```
Outputs:
linux_public_ip = "100.26.230.65"
```

Tambien podemos usar el siguiente comando para visualizar la información:  
`terraform output`
```
linux_public_ip = "100.26.230.65"
```

Si solo queremos visualizar el valor de un output en específico usamos el siguiente comando:  
`terraform output linux_public_ip`
```
"100.26.230.65"
```

Para saber que información podemos obtener de cada elemento en la documentación en la parte final tenemos la sección Attributes Reference

## Dependencias

### Implicitas vs Expicitas

#### Implicita

```
resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.vpc_virginia.id # <----------
    cidr_block = var.subnets[0]
    map_public_on_launch = true
    tags = {
        "Name" = "public_subnet"
    }
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.vpc_virginia.id # <----------
    cidr_block = var.subnets[1]
    tags = {
        "Name" = "private_subnet"
    }
}
```
- <---------- Terraform infiere que debe crear primero al VPC

```
resource "aws_vpc" "vpc_virginia" {
    cidr_block = var.virginia_cidr
    tags = {
        "Name" = "vpc_virginia"
    }
}
```

#### Explicita:

```
resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.vpc_virginia.id
    cidr_block = var.subnets[0]
    mappublic_ip_on_launch = true
    tags = {
        "Name" = "public_subnet"
    }
}

respurce "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.vpc_virginia.id
    cidr_block = var.subnets[1]
    tags = {
        "Name" = "private_subnet"
    }
}
```

```
resource "aws_subnet" "public_subnet" {
    vpc_id = aws.vpc_virginia.id
    cidr_block = var.subnets[0]
    map_public_ip_on_launch = true
    tags = {
        "Name" = "public_subnet"
    }
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.vpc_virginia.id
    cidr_block = var.subnets[1]
    tags = {
        "Name" = "private_subnet"
    }
    depends_on = [
        aws_subnet.public_subnet
    ]
}
```

## Terraform State (tfstate)

- Cuando los archivos de configuración coinciden con el state no hay cambios para descargar.

Terraform Files (archivos.tf)
Archivos de configuracion .tf de nuestra Infraestructura (Estado deseado)

tfstate (terrafrom.tfstate)

Registro de estado de la infraestructura desplegada (Estado real)

NUNCA editar manualmente el tfstate 

### Terraform State (tfstate) Remoto

tfstate ----------X---------> [Github, Gitlab, Bitbucket]

NUNCA se debe subir el state a un repositorio por cuestiones de seguridad.
El archivo tfstate contiene informacion sensible y debe ser tratado con cuidado.

- Terraform files --------> [Github, Gitlab, Bitbucket]

- tfstate --------> [AWS S3, TerraformCloud]

Trabajar con un tfstate remoto permite el trabajo en equipo, protección del tfstate control de concurrencia, cifrado, confidencialidad y backups.

## Terraform Logging/Debug

Terraform Debug Levels
| Nivdel de detalle | Log level |
|:-----------------:|:---------:|
| Menor detalle     | Info      |
| ...               | Warning   |
| ...               | Error     |
| ...               | Debug     |
| Maximo detalle    | Trace     |

Se configura por linea de comandos y variables de entorno
`export TF_LOG=TRACE`
`export TF_LOG_PATH=terra.log.txt`

## Modulos

- Usar modulos ayuda a que nuestro codigo sea mas simple de mantener y mas facila de reutilizar

| Modulo principal     | Modulo hijo  |
|----------------------|--------------|
| main.tf              | main.tf      |
| variables.tf         | variables.tf |
| output.tf            | output.tf    |
| providers.tf         | main.tf      |
| data.tf              | variables.tf |
|                      | output.tf    |
| Directorio principal (root directory) | Directorio de modulos |

## Terraform Cloud

tfstate --------> [AWS S3, HashiCorp Terraform Cloud]

- Terraform Cloud nos permite almacenar el state y seguir ejecutandolos plan y apply local.

Terraform Cloud --------> [Azure, Kubernets, Alibaba.com, Oracle, AWS]

- Terraform Cloud es un SaaS (Software as a Service) que nos permite no solo almacenar el state de forma segura, tambien nos permite realizar todas las operaciones (plan, apply, destroy, etc.), crear equipos, proyectos y mucho mas, todo desde una misma pltataforma.

| Ventajas                                  |
|-------------------------------------------|
| Terraform State compartido (colaboración) |
| Interfaz de usuario comprensible          |
| Gestión de equipos y permisos             |
| Registro privado para modulos             |
| Control de politicas                      |
| y mas....                                 |

Enlace de HashiCorp:
[HashiCorp](cloud.hashicorp.com)

Pueden registrarse en el siguiente enlace:  
[Terraform](app.terraform.io)

## Herramientas complementarias

### infracost

[infracost](https://github.com/infracost/infracost)

- IA: Infracost es una herramienta que proporciona estimaciones de costos en la nube y verifica las mejores prácticas de FinOps para proyectos de Terraform antes de la implementación. Permite a los ingenieros ver un desglose de costos y entender los impactos financieros de los cambios de código antes de que se desplieguen.

### tfsec

[tfsec](https://github.com/aquasecurity/tfsec)

- IA: Tfsec es una herramienta de análisis estático que verifica archivos de configuración de Terraform para identificar y resaltar posibles problemas de seguridad y configuraciones incorrectas. Es una herramienta de código abierto desarrollada por Aqua Security.

### tflint

[tflint](https://github.com/terraform-linters/tflint)

- IA: TFLint es una herramienta de análisis estático de código diseñada específicamente para Terraform. Su propósito es verificar archivos de configuración de Terraform para identificar errores potenciales, problemas de seguridad y violaciones de las mejores prácticas.

### tfenv

[tfenv](https://github.com/tfutils/tfenv)

- IA: Tfenv es una herramienta de gestión de versiones para Terraform. Funciona de manera similar a rbenv para Ruby, permitiéndote instalar y cambiar entre diferentes versiones de Terraform de manera sencilla. Esto es especialmente útil si trabajas en múltiples proyectos que requieren diferentes versiones de Terraform.
- No tiene instalador en Windows.

## Optimizacion de costos

### Automatizar encendido y apagado de instancias ec2

[ec2-rds-scheduler](https://registry.terraform.io/modules/eanselmi/ec2-rds-scheduler/aws/1.0.6)

- This Terraform module provides a convenient solution for scheduling the stop and start actions of EC2, ASG and RDS instances, and now it's compatible with Aurora Clusters. 

