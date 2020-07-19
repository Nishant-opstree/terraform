variable "security_group_name" {
 default = "webapp-sc"
}

variable "ingress_cidr_tcp" {
 default = "0.0.0.0/0"
}

variable "vpc_Id" {
 default = "vpc-0ba1b063"
}

variable "ingress_cidr_ssh" {
 default = "0.0.0.0/0"
}