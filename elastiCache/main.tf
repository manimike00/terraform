resource "aws_security_group" "securityGroup" {
  name                  = "${var.name}-security-group"
  vpc_id                = var.vpc_id
  ingress {
    from_port           = 6379
    protocol            = "TCP"
    to_port             = 6379
    cidr_blocks         = ["0.0.0.0/0"]
  }

  egress {
    from_port           = 0
    to_port             = 0
    protocol            = "-1"
    cidr_blocks         = ["0.0.0.0/0"]
  }
}


resource "aws_elasticache_subnet_group" "elastiCacheSubnetGroup" {
  name                  = "${var.name}-subgrp"
  subnet_ids            = var.subnet_ids
}

resource "aws_elasticache_parameter_group" "elastiCacheParameterGroup" {
  family                = "redis6.x"
  name                  = "${var.name}-pg"
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id            = var.cluster_id
  engine                = var.engine
  node_type             = var.node_type
  num_cache_nodes       = var.num_cache_nodes
  parameter_group_name  = aws_elasticache_parameter_group.elastiCacheParameterGroup.id
  subnet_group_name     = aws_elasticache_subnet_group.elastiCacheSubnetGroup.id
  security_group_ids    = [aws_security_group.securityGroup.id]
  engine_version        = var.engine_version
  port                  = var.port
}