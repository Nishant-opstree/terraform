resource "aws_autoscaling_group" "webapp_asg" {
  name                      = var.asg_name
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  health_check_grace_period = var.asg_health_grace_period
  health_check_type         = var.asg_health_check_type
  desired_capacity          = var.asg_desired_capacity  
  force_delete              = var.asg_force_delete  
  launch_configuration      = var.asg_launch_configuration
  vpc_zone_identifier       = var.asg_vpc_zone_identifier
  tag {
    key                 = "Name"
    value               = var.asg_tag_value
    propagate_at_launch = var.asg_propagate_at_launch
  }
}