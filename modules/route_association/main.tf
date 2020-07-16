resource "aws_route_table_association" "webapp_rta" {
  subnet_id      = var.subnet_Id
  route_table_id = var.route_table_Id
}