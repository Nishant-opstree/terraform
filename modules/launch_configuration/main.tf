resource "aws_launch_configuration" "webapp_lc" {
  name_prefix     = var.lc_name_prefix
  image_id        = var.amis
  instance_type   = var.instance_Type
  key_name        = var.key_name
  security_groups = var.security_group_Id
  lifecycle {
    create_before_destroy = true
  }
}