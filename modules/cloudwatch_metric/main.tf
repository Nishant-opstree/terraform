resource "aws_cloudwatch_metric_alarm" "webapp_alarm" {
  alarm_name          = var.alarm_name
  comparison_operator = var.alarm_comparission_operator
  evaluation_periods  = var.alarm_evaluation_periods
  metric_name         = var.alarm_metric_name
  namespace           = var.alarm_namespace
  period              = var.alarm_period
  statistic           = var.alarm_statistic
  threshold           = var.alarm_threshold
  alarm_actions       = var.alarm_alarm_actions
  dimensions = {
    AutoScalingGroupName = var.alarm_asg_name
  }
}