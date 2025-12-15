variable "ami" {
  type    = string
  default = "ami-0a71e3eb8b23101ed"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "name_prefix" {
  type = string
}

variable "key_pair_name" {
  type = string
}

variable "subnet_ids" {
  type = map(string)
}

variable "security_goups" {
  type = map(list(string))
}

variable "private_rt_id" {
  type = string
}