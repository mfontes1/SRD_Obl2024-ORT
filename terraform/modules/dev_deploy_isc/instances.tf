


# Se crean las instancias web1, DB y WAF

resource "aws_instance" "web1" {
    instance_type          = var.instance_type
    key_name               = var.key_name
    ami                    = var.ami
    vpc_security_group_ids = [aws_security_group.public_sg.id]
    subnet_id              = aws_subnet.public.id
    availability_zone      = var.availability_zone



#verificar que el path de labsuser.pem coincida con el usuario que lo este ejecutando.
    provisioner "file" {
    source      = "playbook.yml"
    destination = "/home/admin/playbook.yml"

    connection {
      type = "ssh"
      user = "admin"
      private_key = file("/Users/marcio/Documents/ORT/SRD/labsuser.pem")
      host = self.public_ip
    }
  }
   provisioner "file" {
    source      = "inventory"
    destination = "/home/admin/inventory"

    connection {
      type        = "ssh"
      user        = "admin"
      private_key = file("/Users/marcio/Documents/ORT/SRD/labsuser.pem")
      host        = self.public_ip
    }
  }
    
    provisioner "remote-exec" {
      inline = [
        "sudo apt update -y",
        "sudo apt install -y ansible git",
        "git clone https://github.com/mfontes1/ansible-lamp-stack.git",
        "git clone https://github.com/mfontes1/ansible-debian-11-hardening.git",
  #      "sudo ansible-playbook -i /home/admin/inventory /home/admin/playbook.yml",
        "sudo ansible-playbook -i /home/admin/inventory /home/admin/ansible-lamp-stack/lamp-playbook.yml",
  #      "sudo ansible-playbook -i /home/admin/inventory /home/admin/ansible-debian-11-hardening/site.yml"
    ]
      
  connection {
      type = "ssh"
      user = "admin"
      private_key = file("/Users/marcio/Documents/ORT/SRD/labsuser.pem")
      host = self.public_ip
    }
}  



tags = {
        Name = var.name_instance
    }
}


resource "aws_db_subnet_group" "main" {
  name       = var.db_subnet_group_name
  subnet_ids = [
    aws_subnet.private.id, aws_subnet.public.id
    ]

  tags = {
    Name = "main-db-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  tags = {
    Name = "main-db-instance"
  }
}