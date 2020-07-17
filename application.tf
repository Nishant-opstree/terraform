module "security_group" {
  source              = "./modules/security_group"
  security_group_name = "webapp"
  ingress_cidr_tcp    = "0.0.0.0/0"
  vpc_Id              = module.vpc.webapp_vpc_Id 
  ingress_cidr_ssh    = "0.0.0.0/0"
}


module "security_group_rules_ingress" {
  source         = "./modules/security_group_rules"
  rule_type      = "ingress"
  rule_from_port = "0"
  rule_to_port   = "65535"
  rule_portocol  = "tcp"
  rule_cidr      = ["0.0.0.0/0"]
  rule_sec_grp   = module.security_group.webapp_sec_grp_Id
}

module "security_group_rules_egress" {
  source         = "./modules/security_group_rules"
  rule_type      = "egress"
  rule_from_port = "0"
  rule_to_port   = "65535"
  rule_portocol  = "tcp"
  rule_cidr      = ["0.0.0.0/0"]
  rule_sec_grp   = module.security_group.webapp_sec_grp_Id
}

module "peering_connection" {
  source        = "./modules/vpc_peering"
  peer_owner_Id = "306550015759"
  peer_vpc_Id   = "vpc-0777c75ef30792aae"
  vpc_Id        = module.vpc.webapp_vpc_Id 
}

module "route_public" {
  source                = "./modules/route"
  route_table_Id        = module.route_table_public.webapp_route_table_Id
  cidr_block            = "10.0.0.0/16"
  peering_connection_Id = module.peering_connection.webapp_peering_conn_Id
}

module "route_private_a" {
  source                = "./modules/route"
  route_table_Id        = module.route_table_private_a.webapp_route_table_Id
  cidr_block            = "10.0.0.0/16"
  peering_connection_Id = module.peering_connection.webapp_peering_conn_Id
}

module "route_private_b" {
  source                = "./modules/route"
  route_table_Id        = module.route_table_private_b.webapp_route_table_Id
  cidr_block            = "10.0.0.0/16"
  peering_connection_Id = module.peering_connection.webapp_peering_conn_Id
}

module "route_old_vpc" {
  source                = "./modules/route"
  route_table_Id        = "rtb-0a9572691b623a772"
  cidr_block            = "10.1.0.0/16"
  peering_connection_Id = module.peering_connection.webapp_peering_conn_Id
}


module "instance_public_a" {
  source            = "./modules/instance"
  amis              = "ami-02d55cb47e83a99a0"
  key_name          = "ec2-linux-public-01"
  subnet_Id         = module.subnet_public_a.webapp_subnet_Id
  security_group_Id = module.security_group.webapp_sec_grp_Id
  instance_type     = "t2.micro"
  instance_tag_name = "bastion_instance"
}

module "frontend_lc" {
  source            = "./modules/launch_configuration"
  amis              = "ami-02d55cb47e83a99a0"
  key_name          = "ec2-linux-public-01"
  security_group_Id = [ module.security_group.webapp_sec_grp_Id] 
  instance_Type     = "t2.micro"
  lc_name_prefix    =  "frontend" 
  
}

module "frontend_asg" {
  source                   = "./modules/auto_scalling"
  asg_name                 = "frontend"
  asg_max_size             = 1
  asg_min_size             = 1
  asg_health_grace_period  = 300
  asg_health_check_type    = "EC2"
  asg_desired_capacity     = 1
  asg_force_delete         = true
  asg_launch_configuration = module.frontend_lc.webapp_lc
  asg_vpc_zone_identifier  = [module.subnet_private_a.webapp_subnet_Id, module.subnet_private_b.webapp_subnet_Id]
  asg_tag_value            = "frontend"
  asg_propagate_at_launch  = true
  
}


