resource "aws_subnet" "webapp_subnet" {
  vpc_id     = var.vpc_Id
  cidr_block = var.subnet_cidr
  availability_zone_id = var.subnet_availibility_zone
  map_public_ip_on_launch = true
  tags = {
    Name = var.subnet_tag_name
  }
}