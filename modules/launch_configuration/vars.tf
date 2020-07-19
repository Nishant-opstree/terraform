variable "amis" {
 default = "ami-02d55cb47e83a99a0"
}
variable "key_name" {
 default = "ec2-linux-public-01"
}
variable "security_group_Id" {
 default = ["sg-0d5c90cc9a672a679"]
}
variable "instance_Type" {
 default = "t2.micro"
}
variable "lc_name_prefix" {
 default = "webapp-"
}