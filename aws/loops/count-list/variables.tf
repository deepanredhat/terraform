variable "ami" {}
variable "instance_type" {}
variable "key_name" {}
variable "region" {}
variable "names" {
  type    = list(string)
  default = ["machine1", "machine3", "machine2"]
}
