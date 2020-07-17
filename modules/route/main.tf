resource "aws_route" "webapp_route" {
  route_table_id            = var.route_table_Id
  destination_cidr_block    = var.cidr_block
  vpc_peering_connection_id = var.peering_connection_Id
}

