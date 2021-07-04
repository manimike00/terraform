provider "aws" {
  region = var.region
}

data "template_file" "userdata" {
  template = file("user-data.sh")
}

resource "aws_iam_policy" "policy-2" {
  name        = "test_policy"
  path        = "/"
  description = "Policy for S3 & Cloudwatch"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "cloudwatch:*",
          "s3:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "role" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    Name = "postgres"
  }
}

resource "aws_iam_policy_attachment" "policy" {
  name       = "postgres"
  roles      = [aws_iam_role.role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_instance_profile" "profile" {
  name = "postgres"
  role = aws_iam_role.role.name
}

resource "aws_security_group" "sg" {
  name        = "postgres"
  description = "Postgres Security Group"
  vpc_id      = var.vpc
  ingress {
    from_port   = 5432
    protocol    = "TCP"
    to_port     = 5432
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "postgres"
  }
}

resource "aws_instance" "postgres" {
  ami                         = "ami-09e67e426f25ce0d7"
  instance_type               = "t3a.medium"
  subnet_id                   = var.subnet
  iam_instance_profile        = aws_iam_instance_profile.profile.name
  security_groups             = [aws_security_group.sg.id]
  associate_public_ip_address = true
  user_data                   = data.template_file.userdata.rendered
  monitoring                  = true
  root_block_device {
    delete_on_termination = true
    volume_type           = "gp3"
    volume_size           = "30"
    tags = {
      Name = "postgres"
    }
  }
  tags = {
    Name = "postgres"
  }
}

resource "aws_cloudwatch_metric_alarm" "ec2_cpu" {
  alarm_name                = "cpu-utilization"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120" #seconds
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  dimensions = {
    InstanceId = aws_instance.postgres.id
  }
}
