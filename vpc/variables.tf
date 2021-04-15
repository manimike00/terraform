variable "name" {
  type = string
  description = "Describes Name of VPC"
}

variable "cidr_block" {
  type = string
  description = "Define CIDR block for VPC"
}

variable "subnets" {
  type = number
  description = "(optional) describe your variable"
}