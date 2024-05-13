module "vpc" {
  source = "./vpc"
  env = var.env
  for_each = var.vpc
  vpc_cidr = each.value["vpc_cidr"]
  public_subnets = each.value["public_subnets"]
  private_subnets = each.value["private_subnets"]
}

# output "vpc" {
#     value = module.vpc
  
# }