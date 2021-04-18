resource "aws_db_instance" "dbInstance" {
  allocated_storage    = var.allocated_storage
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  identifier           = var.identifier
  name                 = var.name
  username             = var.username
  password             = var.password
  parameter_group_name = aws_db_parameter_group.dbParameterGroup.name
  db_subnet_group_name = aws_db_subnet_group.dbSubnetGroup.name
  skip_final_snapshot  = var.skip_final_snapshot
  vpc_security_group_ids = [aws_security_group.securityGroup.id]
}