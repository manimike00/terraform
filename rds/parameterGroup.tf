resource "aws_db_parameter_group" "dbParameterGroup" {
  name   = "${var.name}-rds-pg"
  family = var.family

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}