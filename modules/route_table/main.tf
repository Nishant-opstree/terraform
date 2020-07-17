resource "aws_route_table" "webapp_route_table" {
  vpc_id = var.vpc_Id
  route {
    cidr_block = var.route_table_cidr
    gateway_id = var.gateway_Id
  }
  tags = {
    Name = var.route_table_name
  }
}

