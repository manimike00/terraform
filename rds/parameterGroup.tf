resource "aws_db_parameter_group" "dbParameterGroup" {
  name        = "${var.name}-rds-pg"
  family      = var.family
  description = "${var.name} RDS Parameter Group"
}