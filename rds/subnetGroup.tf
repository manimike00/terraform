resource "aws_db_subnet_group" "dbSubnetGroup" {
  name       = "${var.name}-sg"
  subnet_ids = var.subnets

  tags = {
    Name = "${var.name}-sg"
  }
}