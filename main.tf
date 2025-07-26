# ========================================
# ✅ Provider AWS
# ========================================
provider "aws" {
  region = "ap-southeast-2"
}

# ========================================
# ✅ Ambil Default VPC & Security Group
# ========================================
data "aws_vpc" "default" {
  default = true
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}

# ========================================
# 📦 RDS MySQL Instance
# ========================================
resource "aws_db_instance" "register_db" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = "registerdb"
  username             = "root"
  password             = "admin123#"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  publicly_accessible  = true

  vpc_security_group_ids = [data.aws_security_group.default.id]
}

# ========================================
# 🖥️ EC2 Instance untuk aplikasi Flask
# ========================================
resource "aws_instance" "register_server" {
  ami                         = "ami-093dc6859d9315726" # Amazon Linux 2023 (Sydney)
  instance_type               = "t2.micro"
  key_name                    = "py-flask" # ⛔ Ganti dengan key pair milikmu
  associate_public_ip_address = true
  vpc_security_group_ids      = [data.aws_security_group.default.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker git
              systemctl start docker
              systemctl enable docker

              # Jalankan phpMyAdmin dengan koneksi ke RDS
              docker run -d --name phpmyadmin \\
                -e PMA_HOST=${aws_db_instance.register_db.address} \\
                -e PMA_PORT=3306 \\
                -e COOKIE_SECURE=false \\
                -p 80:80 \\
                phpmyadmin/phpmyadmin
              EOF

  tags = {
    Name = "RegisterAppServer"
  }
}
