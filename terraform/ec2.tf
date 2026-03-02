# ---------------- Launch Template ----------------
resource "aws_launch_template" "web_template" {
  name_prefix   = "web-template-"
  image_id      = var.ami_id
  instance_type = "t2.micro"
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.NET_SG.id]

  user_data = filebase64("${path.module}/userdata.sh")

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Web-Server"
    }
  }
}
resource "aws_security_group" "NET_SG" {
  name   = "web-sg"
  vpc_id = aws_vpc.NET_VPC.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
