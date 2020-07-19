data "aws_eip" "webapp_eip" {
  filter {
    name   = "tag:Name"
    values = [var.elastic_Ip_name]
  } 
}

resource "aws_nat_gateway" "webapp_nat" {
  allocation_id = data.aws_eip.webapp_eip.id
  subnet_id     = var.subnet_Id
  tags = {
    Name = var.nat_tag_name
  }
}
