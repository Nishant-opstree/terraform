variable "asg_policy_name" {
 default = "webapp_asg_policy"
}

variable "asg_policy_scaling_adjustment" {
 default = 1
}

variable "asg_policy_adjustment_type" {
 default = "ChangeInCapacity"
}

variable "asg_policy_cooldown" {
 default = 300
}

variable "asg_name" {
 default = ""
}