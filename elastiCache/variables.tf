variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "cluster_id" {
  type = string
}

variable "engine" {
  type = string
}

variable "node_type" {
  type = string
}

variable "num_cache_nodes" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "port" {
  type = number
}
