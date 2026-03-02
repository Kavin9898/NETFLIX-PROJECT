# ---------------- ALB DNS ----------------
output "alb_dns" {
  description = "Application Load Balancer DNS Name"
  value       = aws_lb.web_alb.dns_name
}

# ---------------- RDS Endpoint ----------------
output "rds_endpoint" {
  description = "RDS MySQL Endpoint"
  value       = aws_db_instance.app_db.endpoint
  sensitive   = true
}
