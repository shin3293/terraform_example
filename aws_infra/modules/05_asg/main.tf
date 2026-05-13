# aws_infra/asg/main.tf
# 1. Launch Template
resource "aws_launch_template" "aws09_was_lt" {
  name_prefix = "${var.prefix}-was-lt-"

  image_id      = data.terraform_remote_state.ami.outputs.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = false
      security_groups = [data.terraform_remote_state.network.outputs.http_sg_id]
    
  }

  iam_instance_profile {
    name = data.aws_iam_instance_profile.aws09_ec2_instance_profile.name
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.prefix}-was-instance"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# 2. Auto Scaling Group
resource "aws_autoscaling_group" "aws09_was_asg" {
  name = "${var.prefix}-was-asg"

  vpc_zone_identifier = data.terraform_remote_state.network.outputs.private_subnet_ids

  launch_template {
    id      = aws_launch_template.aws09_was_lt.id
    version = "$Latest"
  }

  target_group_arns = [data.terraform_remote_state.alb.outputs.was_target_group_arn]

  min_size         = 1
  max_size         = 3
  desired_capacity = 2

  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "${var.prefix}-was-asg-instance"
    propagate_at_launch = true
  }
}