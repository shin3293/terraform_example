# aws_infra/ec2/main.tf
resource "aws_instance" "aws09_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = data.aws_subnet.aws09_public_subnet.id
  security_groups = [
    data.aws_security_group.aws09_ssh_sg.id,
    data.aws_security_group.aws09_http_sg.id
  ]
  # docker, codedeploy 설치 스크립트
  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install -y ruby wget
                sudo apt install -y --reinstall ca-certificates
                sudo update-ca-certificates --fresh
                cd /home/ubuntu
                wget https://aws-codedeploy-ap-northeast-2.s3.ap-northeast-2.amazonaws.com/latest/install
                chmod +x ./install
                ./install auto
                sudo systemctl start codedeploy-agent
                sudo systemctl enable codedeploy-agent
                ${file("${path.module}/user_data/docker-install.sh")}
                EOF
  tags = {
    Name = "${var.prefix}-instance"
  }
}
# 2. Code Deploy Agent, Docker 설치 대기
resource "null_resource" "aws09_delay" {
  provisioner "local-exec" {
    command = "sleep 180"
  }
  depends_on = [aws_instance.aws09_instance]
}
#3. 원본 instance를 이용해 AMI 생성
resource "aws_ami_from_instance" "aws09_ami" {
  name               = "${var.prefix}-instance-ami"
  source_instance_id = aws_instance.aws09_instance.id
  snapshot_without_reboot = true
  depends_on         = [null_resource.aws09_delay]
  tags = {
    Name = "${var.prefix}-instance-ami"
  }
}