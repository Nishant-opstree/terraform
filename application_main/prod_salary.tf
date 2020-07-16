terraform {
    backend "s3"  {
        bucket = "nishant-terraform-state-bucket"
	      key    = "global/s3/terraform.tfstate"
        region = "ap-south-1"
    }
}
provider "aws" {
    profile    = "default"
    region     = "ap-south-1"
}

module "vpc" {
  source       = "./modules/vpc"
  vpc_cidr     = "10.1.0.0/16" 
  vpc_tag_name = "webapp-vpc"
}

module "subnet_public_a" {
  source                   = "./modules/subnet"
  subnet_cidr              = "10.1.0.0/24"
  subnet_tag_name          = "webapp-subnet-pub-a"
  subnet_availibility_zone = "aps1-az1"
  vpc_Id                   =  module.vpc.webapp_vpc_Id 
}

module "subnet_public_b" {
  source                   = "./modules/subnet"
  subnet_cidr              = "10.1.1.0/24"
  subnet_tag_name          = "webapp-subnet-pub-b"
  subnet_availibility_zone = "aps1-az3"
  vpc_Id                   =  module.vpc.webapp_vpc_Id 
}

module "subnet_private_a" {
  source                   = "./modules/subnet"
  subnet_cidr              = "10.1.2.0/24"
  subnet_tag_name          = "webapp-subnet-priv-a"
  subnet_availibility_zone = "aps1-az1"
  vpc_Id                   =  module.vpc.webapp_vpc_Id 
}

module "subnet_private_b" {
  source                   = "./modules/subnet"
  subnet_cidr              = "10.1.3.0/24"
  subnet_tag_name          = "webapp-subnet-priv-b"
  subnet_availibility_zone = "aps1-az3"
  vpc_Id                   =  module.vpc.webapp_vpc_Id 
}

module "igw" {
  source       = "./modules/igw"
  vpc_Id       = module.vpc.webapp_vpc_Id 
  igw_tag_name = "webapp-igw"
}

module "nat_a" {
  source          = "./modules/nat"
  subnet_Id       = module.subnet_public_a.webapp_subnet_Id
  elastic_Ip_name = "eip-01"
  nat_tag_name    = "webapp-nat-a"
}

module "nat_b" {
  source          = "./modules/nat"
  subnet_Id       = module.subnet_public_b.webapp_subnet_Id
  elastic_Ip_name = "eip-02"
  nat_tag_name    = "webapp-nat-b"
}

module "route_table_public" {
  source           = "./modules/route_table"
  vpc_Id           = module.vpc.webapp_vpc_Id 
  route_table_cidr = "0.0.0.0/0"
  gateway_Id       = module.igw.webapp_igw_Id
  route_table_name = "webapp-routetable-public"
}

module "route_table_private_a" {
  source           = "./modules/route_table"
  vpc_Id           = module.vpc.webapp_vpc_Id 
  route_table_cidr = "0.0.0.0/0"
  gateway_Id       = module.nat_a.webapp_nat_Id
  route_table_name = "webapp-routetable-private-a"
}

module "route_table_private_b" {
  source           = "./modules/route_table"
  vpc_Id           = module.vpc.webapp_vpc_Id 
  route_table_cidr = "0.0.0.0/0"
  gateway_Id       = module.nat_b.webapp_nat_Id
  route_table_name = "webapp-routetable-private-b"
}

module "route_table_association_pub_a" {
  source         = "./modules/route_association"
  subnet_Id      = module.subnet_public_a.webapp_subnet_Id
  route_table_Id = module.route_table_public.webapp_route_table_Id
}

module "route_table_association_pub_b" {
  source         = "./modules/route_association"
  subnet_Id      = module.subnet_public_b.webapp_subnet_Id
  route_table_Id = module.route_table_public.webapp_route_table_Id
}

module "route_table_association_priv_a" {
  source         = "./modules/route_association"
  subnet_Id      = module.subnet_private_a.webapp_subnet_Id
  route_table_Id = module.route_table_private_a.webapp_route_table_Id
}

module "route_table_association_priv_b" {
  source         = "./modules/route_association"
  subnet_Id      = module.subnet_private_b.webapp_subnet_Id
  route_table_Id = module.route_table_private_b.webapp_route_table_Id
}

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

module "salary_lc" {
  source            = "./modules/launch_configuration"
  amis              = "ami-02d55cb47e83a99a0"
  key_name          = "ec2-linux-public-01"
  security_group_Id = [ module.security_group.webapp_sec_grp_Id ]
  instance_Type     = "t2.micro"
  lc_name_prefix    =  "salary"
}

module "salary_as" {
  source                   = "./modules/auto_scalling"
  placement_group_strategy = "cluster"
  asg_name                 = "salary"
  asg_max_size             = 2
  asg_min_size             = 1
  asg_health_grace_period  = 300
  asg_health_check_type    = "EC2"
  asg_desired_capacity     = 1
  asg_force_delete         = true
  asg_launch_configuration = module.salary_lc.webapp_lc
  asg_vpc_zone_identifier  = [module.subnet_private_a.webapp_subnet_Id, module.subnet_private_b.webapp_subnet_Id]
  asg_tag_value            = "salary"
  asg_propagate_at_launch  = true
}

module "salary_asp_up" {
  source                        = "./modules/auto_scalling_policy"
  asg_policy_name               = "salary_policy_up"
  asg_policy_scaling_adjustment = 1
  asg_policy_adjustment_type    = "ChangeInCapacity"
  asg_policy_cooldown           = 300
  asg_name                      = module.salary_as.asg.name
}

module "salary_cloud_watch_up" {
  source                      = "./modules/cloudwatch_metric"
  alarm_name                  = "salary_up_alarm"
  alarm_comparission_operator = "GreaterThanOrEqualToThreshold"
  alarm_evaluation_periods    = "4"
  alarm_metric_name           = "CPUUtilization"
  alarm_namespace             = "AWS/EC2"
  alarm_period                = "120"
  alarm_statistic             = "Average"
  alarm_threshold             = "80"
  alarm_alarm_actions         = [module.salary_asp_up.asg_policy.arn]
  alarm_asg_name              = module.salary_as.asg.name
}

module "salary_asp_down" {
  source                        = "./modules/auto_scalling_policy"
  asg_policy_name               = "salary_policy_down"
  asg_policy_scaling_adjustment = -1
  asg_policy_adjustment_type    = "ChangeInCapacity"
  asg_policy_cooldown           = 300
  asg_name                      = module.salary_as.asg.name
  
}

module "salary_cloud_watch_down" {
  source                      = "./modules/cloudwatch_metric"
  alarm_name                  = "salary_down_alarm"
  alarm_comparission_operator = "LessThanLowerThreshold"
  alarm_evaluation_periods    = "4"
  alarm_metric_name           = "CPUUtilization"
  alarm_namespace             = "AWS/EC2"
  alarm_period                = "120"
  alarm_statistic             = "Average"
  alarm_threshold             = "80"
  alarm_alarm_actions         = [module.salary_asp_down.asg_policy.arn]
  alarm_asg_name              = module.salary_as.asg.name
  
}

module "elasticsearch_lc" {
  source            = "./modules/launch_configuration"
  amis              = "ami-02d55cb47e83a99a0"
  key_name          = "ec2-linux-public-01"
  security_group_Id = [ module.security_group.webapp_sec_grp_Id] 
  instance_Type     = "t2.micro"
  lc_name_prefix    =  "elasticsearch" 
  
}

module "elasticsearch_asg" {
  source                   = "./modules/auto_scalling"
  placement_group_strategy = "cluster"
  asg_name                 = "elasticsearch"
  asg_max_size             = 1
  asg_min_size             = 1
  asg_health_grace_period  = 300
  asg_health_check_type    = "EC2"
  asg_desired_capacity     = 1
  asg_force_delete         = true
  asg_launch_configuration = module.elasticsearch_lc.webapp_lc
  asg_vpc_zone_identifier  = [module.subnet_private_a.webapp_subnet_Id, module.subnet_private_b.webapp_subnet_Id]
  asg_tag_value            = "elasticsearch"
  asg_propagate_at_launch  = true
  
}


