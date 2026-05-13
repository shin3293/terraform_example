# alb/output.tf
output "was_target_arn" {
  value = aws_lb_target_alb.arn
}
