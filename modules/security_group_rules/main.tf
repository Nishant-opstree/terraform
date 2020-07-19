resource "aws_security_group_rule" "webapp_sec_rule" {
  type              = var.rule_type
  from_port         = var.rule_from_port
  to_port           = var.rule_to_port
  protocol          = var.rule_portocol
  cidr_blocks       = var.rule_cidr
  security_group_id = var.rule_sec_grp
}
