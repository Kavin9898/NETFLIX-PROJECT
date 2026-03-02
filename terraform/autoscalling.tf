resource "aws_autoscaling_group" "web_asg" {
  name                 = "web-auto-scaling-group"   # ✅ FIXED NAME

  desired_capacity     = 2
  max_size             = 4
  min_size             = 1

  vpc_zone_identifier  = [
    aws_subnet.PUBLIC_NET_SUBNET.id,
    aws_subnet.PUBLIC_NET_SUBNET1.id
  ]

  launch_template {
    id      = aws_launch_template.web_template.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.web_tg.arn]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "ASG-Web-Server"
    propagate_at_launch = true
  }
}
