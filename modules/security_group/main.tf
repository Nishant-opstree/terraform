resource "aws_security_group" "webapp_sec_grp" {
  name        = var.security_group_name
  vpc_id      = var.vpc_Id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [var.ingress_cidr_tcp]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ingress_cidr_ssh]
  }
}