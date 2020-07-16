resource "aws_vpc_peering_connection" "webapp_peering_connection" {
  peer_owner_id = var.peer_owner_Id
  peer_vpc_id   = var.peer_vpc_Id
  vpc_id        = var.vpc_Id
  auto_accept   = true
  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}
