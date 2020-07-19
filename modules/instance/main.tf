resource "aws_instance" "web_instance" {
  ami                     = var.amis
  key_name                = var.key_name
  subnet_id               = var.subnet_Id
  vpc_security_group_ids  = [ var.security_group_Id ]
  instance_type           = var.instance_type
  tags = {
  Name = var.instance_tag_name
  }
}