# aws_infra/01_network/output.tf
output "vpc_id" {
  value = aws_vpc.aws09_vpc.id
}
output "public_subnet_ids" {
  value = aws_subnet.aws09_public_subnet[*].id
}
output "private_subnet_ids" {
  value = aws_subnet.aws09_private_subnet[*].id
}
output "ssh_sg_id" {
  value = aws_security_group.aws09_ssh_sg.id
}
output "http_sg_id" {
  value = aws_security_group.aws09_http_sg.id
}