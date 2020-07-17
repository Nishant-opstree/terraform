variable "alarm_name" {
 default = "webapp_alarm"
}

variable "alarm_comparission_operator" {
 default = "GreaterThanOrEqualToThreshold"
}

variable "alarm_evaluation_periods" {
 default = "2"
}

variable "alarm_metric_name" {
 default = "CPUUtilization"
}

variable "alarm_namespace" {
 default = "AWS/EC2"
}

variable "alarm_period" {
 default = "120"
}

variable "alarm_statistic" {
 default = "Average"
}

variable "alarm_threshold" {
 default = "80"
}

variable "alarm_alarm_actions" {
 default = []
}

variable "alarm_asg_name" {
 default = ""
}