variable "ami" {}
variable "instance_type" {}
variable "key_name" {}
variable "region" {}
variable "name" {
    type = list
    default = [ "red", "blue"]
}
