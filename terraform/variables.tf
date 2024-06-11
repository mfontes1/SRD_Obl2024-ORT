# se definieron las variables
variable "region" {
  type = string
  description = "Variable para la region"
}
variable "profile" {
  type = string
  description = "Variable para profile"
  
}
variable "ami_input" {
  type = string
  description = "variable para AMI"
  
}
variable "instance_type_input" {
  type = string
  description = "variable tipo de instancia "
  
}
variable "key_name_input" {
  type = string
  description = "variable de key_name"
  
}
variable "name_instance_input" {
  type = string
  description = "variable instanse_name"

}
variable "name_instance2_input" {
  type = string
  description = "variable instanse_name 2"

}
variable "name_vpc_input" {
  type = string
  description = "variable vpc name"
}


variable "availability_zone" {
    type = string
  
}

variable "sg_name_input" {
    type = string
  
}

variable "db_name_input" {
    type = string
  
}

