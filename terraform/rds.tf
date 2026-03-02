# ---------------- DB Subnet Group ----------------
resource "aws_db_subnet_group" "db_subnet_group" {
  name = "app-db-subnet-group"

  subnet_ids = [
    aws_subnet.private1.id,
    aws_subnet.private2.id
  ]

  tags = {
    Name = "App-DB-Subnet-Group"
  }
}

# ---------------- RDS Security Group ----------------
resource "aws_security_group" "rds_sg" {
  name   = "rds-security-group"
  vpc_id = aws_vpc.main.id

  # Allow MySQL from EC2 Security Group only
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS-SG"
  }
}

# ---------------- RDS Instance ----------------
resource "aws_db_instance" "app_db" {
  identifier              = "app-database"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"

  allocated_storage       = 20
  db_name                 = "appdb"
  username                = "admin"
  password                = var.db_password

  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]

  publicly_accessible     = false
  skip_final_snapshot     = true
  multi_az                = false

  tags = {
    Name = "App-Database"
  }
}