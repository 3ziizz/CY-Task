variable "instance_type" {
  type = string
  default = "t2.medium"
}

variable "key_name" {
  type = string
  default = "cy-key"
}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "worker_count" {
  type = number
  default = 1
}
