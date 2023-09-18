resource "aws_launch_template" "lc" {
  name          = "tf_launch_template"
#   image_id      = data.aws_ami.amazon_linux.id
  image_id = "ami-04cb4ca688797756f"
  instance_type = "t2.micro"
  lifecycle {
    create_before_destroy = true
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.vpc-ssh.id]
    subnet_id                   = aws_subnet.mahmuda_subnet_1.id
  }
  user_data = filebase64("/user_data.tpl")
}

resource "aws_autoscaling_group" "asg" {
  name                      = "tf-asg"
  # launch_configuration      = aws_launch_configuration.lc.name
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 2
  health_check_type         = "EC2"
  health_check_grace_period = 300
  vpc_zone_identifier       = [aws_subnet.mahmuda_subnet_1.id, aws_subnet.mahmuda_subnet_2.id]
#   target_group_arns = 

    launch_template {
    id      = aws_launch_template.lc.id
    version = "$Latest"
  }

  protect_from_scale_in = true
  lifecycle {
    create_before_destroy = true
  }
}

# Create a new load balancer attachment
# resource "aws_autoscaling_attachment" "tf_lb_asg" {
#   autoscaling_group_name = aws_autoscaling_group.asg.id
#   alb                    = aws_lb.mahmuda_alb.id
# }

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "tf_tg_asg" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  lb_target_group_arn    = aws_lb_target_group.name.arn
}