module "test_employee_security_group" {
  source              = "./modules/security_group"
  security_group_name = "test_employee_webapp"
  ingress_cidr_tcp    = "0.0.0.0/0"
  vpc_Id              = module.vpc.webapp_vpc_Id 
  ingress_cidr_ssh    = "0.0.0.0/0"
}


module "test_employee_security_group_rules_ingress" {
  source         = "./modules/security_group_rules"
  rule_type      = "ingress"
  rule_from_port = "0"
  rule_to_port   = "65535"
  rule_portocol  = "tcp"
  rule_cidr      = ["0.0.0.0/0"]
  rule_sec_grp   = module.test_employee_security_group.webapp_sec_grp_Id
}

module "test_employee_security_group_rules_egress" {
  source         = "./modules/security_group_rules"
  rule_type      = "egress"
  rule_from_port = "0"
  rule_to_port   = "65535"
  rule_portocol  = "tcp"
  rule_cidr      = ["0.0.0.0/0"]
  rule_sec_grp   = module.test_employee_security_group.webapp_sec_grp_Id
}

module "test_employee_lc" {
  source            = "./modules/launch_configuration"
  amis              = "ami-02d55cb47e83a99a0"
  key_name          = "ec2-linux-public-01"
  security_group_Id = [ module.test_employee_security_group.webapp_sec_grp_Id ]
  instance_Type     = "t2.micro"
  lc_name_prefix    =  "test_employee"
}

module "test_employee_as" {
  source                   = "./modules/auto_scalling"
  asg_name                 = "test_employee"
  asg_max_size             = 1
  asg_min_size             = 1
  asg_health_grace_period  = 300
  asg_health_check_type    = "EC2"
  asg_desired_capacity     = 1
  asg_force_delete         = true
  asg_launch_configuration = module.test_employee_lc.webapp_lc
  asg_vpc_zone_identifier  = [module.subnet_private_a.webapp_subnet_Id, module.subnet_private_b.webapp_subnet_Id]
  asg_tag_value            = "test_employee"
  asg_propagate_at_launch  = true
}

module "test_employee_asp_up" {
  source                        = "./modules/auto_scalling_policy"
  asg_policy_name               = "test_employee_policy_up"
  asg_policy_scaling_adjustment = 1
  asg_policy_adjustment_type    = "ChangeInCapacity"
  asg_policy_cooldown           = 300
  asg_name                      = module.test_employee_as.asg.name
}


module "test_employee_asp_down" {
  source                        = "./modules/auto_scalling_policy"
  asg_policy_name               = "test_employee_policy_down"
  asg_policy_scaling_adjustment = -1
  asg_policy_adjustment_type    = "ChangeInCapacity"
  asg_policy_cooldown           = 300
  asg_name                      = module.test_employee_as.asg.name
  
}