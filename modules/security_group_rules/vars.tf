variable "rule_type" {
 default = "ingress"
}
variable "rule_from_port" {
 default = "0"
}
variable "rule_to_port" {
 default = "65535"
}
variable "rule_portocol" {
 default = "tcp"
}
variable "rule_cidr" {
 default = "0.0.0.0/16"
}
variable "rule_sec_grp" {
 default = "sg-0d5c90cc9a672a679"
}