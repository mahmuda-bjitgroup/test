resource "aws_instance" "tf_ec2" {
  ami                    = "ami-04cb4ca688797756f"
  instance_type          = "t2.small"
  key_name               = "mahmuda-key-pair"
  subnet_id              = aws_subnet.mahmuda_subnet_1.id
  vpc_security_group_ids = [aws_security_group.vpc-ssh.id]
  availability_zone      = "us-east-1a"

  tags = {
    Name = "E2-pubsub-1-data-source"
  }

  #here EOF is used but we can also use file function.
  user_data = <<-EOF
              #!/bin/bash         
              sudo yum update     
              sudo yum install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF
}