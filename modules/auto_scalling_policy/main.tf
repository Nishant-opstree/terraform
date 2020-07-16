resource "aws_autoscaling_policy" "webapp_asg_policy" {
  name                   = var.asg_policy_name
  scaling_adjustment     = var.asg_policy_scaling_adjustment
  adjustment_type        = var.asg_policy_adjustment_type
  cooldown               = var.asg_policy_cooldown
  autoscaling_group_name = var.asg_name
}