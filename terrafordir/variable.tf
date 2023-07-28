variable "region" {
  type = string
}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "private_key_path" {
  type = string
}

variable "public_key_path" {
  type = string
}

variable "inbound_ports" {
  type = list(any)
}

variable "image_name" {
  type = string
}

variable "instance_security_group_name" {
  type = string
}