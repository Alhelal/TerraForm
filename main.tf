provider "aws" {
  access_key = "${lookup(var.aws_access_key, terraform.workspace)}"
  secret_key = "${lookup(var.aws_secret_key, terraform.workspace)}"
  region = "${var.region}"
}

module "vpc_network" {
  source = "./modules/network/vpc/"
}
module "igw_network" {
  source = "./modules/network/igw/"
  vpc_id = "${module.vpc_network.vpc_id}"
}

module "route_table_network" {
  source = "./modules/network/route_table/"
  vpc_id = "${module.vpc_network.vpc_id}"
  igw_id = "${module.igw_network.igw_id}"
}
module "subnet_network" {
  source = "./modules/network/subnet/"
  vpc_id = "${module.vpc_network.vpc_id}"
  vpc_cidr_prefix = "${module.vpc_network.vpc_cidr_prefix}"
  region = "${var.region}"
  public_rt_id = "${module.route_table_network.public_rt_id}"
  private_rt_id = "${module.route_table_network.private_rt_id}"
}
