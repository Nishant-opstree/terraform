variable "asg_name" {
 default = "webapp_asg"
}

variable "asg_max_size" {
 default = 1
}

variable "asg_min_size" {
 default = 1
}

variable "asg_health_grace_period" {
 default = 300
}

variable "asg_health_check_type" {
 default = "ELB"
}

variable "asg_desired_capacity" {
 default = 1
}

variable "asg_force_delete" {
 default = true
}

variable "asg_launch_configuration" {
 default = ""
}

variable "asg_vpc_zone_identifier" {
 default = []
}

variable "asg_tag_value" {
 default = "webapp"
}

variable "asg_propagate_at_launch" {
 default = true
}