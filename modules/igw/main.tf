resource "aws_internet_gateway" "webapp_igw" {
  vpc_id = var.vpc_Id
  tags = {
    Name = var.igw_tag_name
  }
}