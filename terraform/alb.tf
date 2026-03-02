# ---------------- Security Group for ALB ----------------
resource "aws_security_group" "alb_sg" {
  name   = "alb-security-group"
  vpc_id = aws_vpc.NET_VPC.id

  ingress {
    from_port   = 80
    to_port     = 80
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

# ---------------- Application Load Balancer ----------------
resource "aws_lb" "web_alb" {
  name               = "web-alb"
  load_balancer_type = "application"

  subnets = [
    aws_subnet.PUBLIC_NET_SUBNET.id,
    aws_subnet.PUBLIC_NET_SUBNET1.id
  ]

  security_groups = [aws_security_group.alb_sg.id]

  tags = {
    Name = "Web-ALB"
  }
}

# ---------------- Target Group ----------------
resource "aws_lb_target_group" "web_tg" {
  name     = "web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.NET_VPC.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }

  tags = {
    Name = "Web-TG"
  }
}

# ---------------- Listener (Port 80) ----------------
resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}