variable "name" {
  type = string
}

variable "family" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "identifier" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "port" {
  type = number
}

variable "allocated_storage" {
  type = number
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "skip_final_snapshot" {
  type = bool
}