


# Se crean las instancias web1, DB y WAF

resource "aws_instance" "web1" {
    instance_type          = var.instance_type
    key_name               = var.key_name
    ami                    = var.ami
    vpc_security_group_ids = [aws_security_group.web-sg.id]
    subnet_id              = aws_subnet.public.id
    availability_zone      = var.availability_zone

    user_data = <<-EOF
              #!/bin/bash
              apt-get update -y

              # Install necessary packages
              apt-get install -y wget

              # Download and extract WordPress
              curl -O https://wordpress.org/latest.tar.gz
              tar -xzvf latest.tar.gz
              rsync -av wordpress/* /var/www/html/

              # Set ownership and permissions
              chown -R www-data:www-data /var/www/html/
              chmod -R 755 /var/www/html/

              # Configure WordPress
              cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
              sed -i "s/database_name_here/wordpress/" /var/www/html/wp-config.php
              sed -i "s/username_here/wordpressuser/" /var/www/html/wp-config.php
              sed -i "s/password_here/password/" /var/www/html/wp-config.php

              systemctl restart apache2
              EOF

   provisioner "file" {
    source      = "inventory"
    destination = "/home/admin/inventory"

    connection {
      type        = "ssh"
      user        = "admin"
      private_key = file("/home/rrobledo/labsuser.pem")
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
      private_key = file("/home/rrobledo/labsuser.pem")
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
    aws_subnet.private.id, aws_subnet.private2.id
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