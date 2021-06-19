variable "ami" {
    type = string
    default = "ami-0d5eff06f840b45e9"
}
variable "instance_type" {
    type = list
    default = ["t3.micro", "t3.small", "t3.medium"]
}
variable "key_name" {
    type = string
    default = "karthik-personal"
}
variable "region" {
    type = map
    default = {
        "region1" = "us-east-1"
        "region2" = "us-east-2"
    }
}
