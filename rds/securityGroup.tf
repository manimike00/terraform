resource "aws_security_group" "securityGroup" {
  name                  = "${var.name}-rds-sg"
  vpc_id                = var.vpc_id
  ingress {
    from_port           = var.port
    protocol            = "TCP"
    to_port             = var.port
    cidr_blocks         = ["0.0.0.0/0"]
  }

  egress {
    from_port           = 0
    to_port             = 0
    protocol            = "-1"
    cidr_blocks         = ["0.0.0.0/0"]
  }
}