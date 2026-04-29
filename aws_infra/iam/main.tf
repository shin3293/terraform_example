# aws_intfra/iam/main.tf
# S3 접근 권한, SSM 접근 권한
resource "aws_iam_role" "aws09_ec2_role" {
  name = "${var.prefix}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}
#SSM 접근 권한
resource "aws_iam_role_policy_attachment" "aws09_ssm_attach" {
  role       = aws_iam_role.aws09_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
# S3 접근 권한
resource "aws_iam_role_policy_attachment" "aws09_s3_attach" {
  role       = aws_iam_role.aws09_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
# EC2 인스턴스 프로파일
resource "aws_iam_instance_profile" "aws09_ec2_instance_profile" {
  name = "${var.prefix}-ec2-instance-profile"
  role = aws_iam_role.aws09_ec2_role.name
}
# Code Deploy Service Role
resource "aws_iam_role"  "aws09_codedeploy_service_role" {
  name = "${var.prefix}-codedeploy-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Effect = "Allow"
        Principal = { Service = "codedeploy.amazonaws.com" }
        Action = "sts:AssumeRole"
      }
    ]
  })
}
# Code Deploy Service 정책 연결
resource "aws_iam_role_policy_attachment" "aws09_codedeploy_service_attach" {
    role       = aws_iam_role.aws09_codedeploy_service_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

#출력
output "ec2_instance_profile_name" {
  value = aws_iam_instance_profile.aws09_ec2_instance_profile.name
}
output "codedeploy_service_role_arn" {
  value = aws_iam_role.aws09_codedeploy_service_role.arn
}