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

# -------autoscaling.tf-autoscaling.tf-------- Application Load Balancer ----------------
resource "aws_lbautoscaling.tf" "web_alb" {
  name               = "web-alb"
  load_balancer_type = "application"
  subnets            = [
    aws_subnet.PUBLIC_NET_SUBNET.id,
    aws_subnet.PUBLIC_NET_SUBNET1.id
  ]
  security_groups = [aws_security_group.NET_SG.id]
}

# ---------------- Listener ----------------
resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }

}

