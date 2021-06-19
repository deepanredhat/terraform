variable "ami" {
    type = string
    default = "ami-0d5eff06f840b45e9"
}
variable "instance_type" {
    type = string
    default = "t3.micro"
}
variable "key_name" {
    type = string
    default = "karthik-personal"
}
variable "region" {
    type = string
    default = "us-east-1"
}
