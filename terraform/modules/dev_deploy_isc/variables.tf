variable "ami" {
  description = "Ami ID"
  type = string
}

variable "instance_type" {
  description = "Tipo de Instancia"
  type = string
}

variable "key_name" {
    type = string
}

variable "name_instance" {
    type = string
}


variable "name_instance2" {
    type = string
}

variable "name_vpc" {
    type = string
  
}


variable "vpc_aws_az" {
    type = string

}



variable "sg_name" {
    type = string
  
}



variable "allocated_storage" {
  default = 20
}

variable "engine" {
  default = "mysql"
}

variable "engine_version" {
  default = "8.0.28"
}

output "dns" {
  value = aws_instance.web1.public_dns
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet."
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "The CIDR block for the private subnet."
  default     = "10.0.2.0/24"
}

variable "availability_zone" {
  description = "The availability zone for the subnets."
  default     = "us-east-1a"
}
variable "availability_zone2" {
  description = "The availability zone for the subnets."
  default     = "us-east-1b"
}

variable "db_subnet_group_name" {
  description = "The name of the DB subnet group."
  default     = "my-db-subnet-group"
}

variable "db_instance_class" {
  description = "The instance class for the DB."
  default     = "db.t3.micro"
}

variable "db_engine" {
  description = "The database engine to use."
  default     = "mysql"
}

variable "db_engine_version" {
  description = "The version of the database engine."
  default     = "8.0.32"
}

variable "db_username" {
  description = "The username for the DB instance."
  default     = "admin"
}

variable "db_password" {
  description = "The password for the DB instance."
  default     = "password123"
}

variable "db_name" {
  description = "The name of the database."
  default     = "mydatabase"
}