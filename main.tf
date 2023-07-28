provider "aws" {
  region  = var.region
}

#Save state in S3 bucket
terraform{
  backend "s3"{
    bucket   = "arena-terraform-prod"
    key      = "sistema_prod.tfstate"
    region   = "us-east-1"
    encrypt  = true
  }
}

module "launch_configuration" {

  source = "./modules/launch_configuration/"
  depends_on = [module.network]
  
  image_id                     = var.image_id
  instance_type                = var.instance_type  
  key_name                     = var.keypair
  sg_instance_sistema          = module.network.security_group_instance_sistema
  ec2_subnets                  = var.ec2_subnets
}

module "network" {

  source = "./modules/network/"

  vpc_id                       = var.vpc_id
  alb_subnets                  = var.alb_subnets                 
  domain_name                  = var.domain_name

}

module "code_deploy" {

  source = "./modules/code_deploy/"

  target_group                       = module.network.target_group_sistema_443
  auto_scaling_sistema               = module.launch_configuration.auto_scaling_group_id
  ambiente                           = var.ambiente

}

module "cloud_watch" {

  source = "./modules/cloud_watch/"

  scale_up_name                       = module.launch_configuration.auto_scaling_up_cpu_policy_name
  scale_down_name                     = module.launch_configuration.auto_scaling_down_cpu_policy_name
  scale_up_arn                        = module.launch_configuration.auto_scaling_up_cpu_policy_arn
  scale_down_arn                      = module.launch_configuration.auto_scaling_down_cpu_policy_arn
  lb_tg_arn                           = module.network.target_group_sistema_443_arn
  tg_name                             = module.network.target_group_sistema_443
  auto_scaling_sistema                = module.launch_configuration.auto_scaling_group_name
}

module "elasticache" {

  source = "./modules/elasticache/"

    ec2_subnets                  = var.ec2_subnets
}