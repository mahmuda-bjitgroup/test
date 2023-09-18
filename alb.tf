resource "aws_lb" "mahmuda_alb" {
  name               = "mahmuda-alb"
  # internal = false
  load_balancer_type = "application" #ALB
  security_groups    = [aws_security_group.vpc-ssh.id]
  subnets            = [aws_subnet.mahmuda_subnet_1.id, aws_subnet.mahmuda_subnet_2.id]
}


resource "aws_lb_target_group" "name" {
  name        = "mahmuda-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.mahmuda_vpc.id
  target_type = "instance"


}

resource "aws_lb_listener" "tf_alb_listener" {
  load_balancer_arn = aws_lb.mahmuda_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.name.arn
  }
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.name.arn
  target_id        = aws_instance.tf_ec2.id
  port             = 80
}



