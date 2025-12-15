variable "name_prefix" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnets" {
  type = map(map(string))
}

variable "private_subnets" {
  type = map(map(string))
}

variable "route_cidr" {
  type = string
}