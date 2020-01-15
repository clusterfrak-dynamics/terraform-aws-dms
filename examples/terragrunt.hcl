include {
  path = "${find_in_parent_folders()}"
}

terraform {
  source = "github.com/clusterfrak-dynamics/terraform-aws-dms?ref=v1.0.0"
}

locals {
  aws_region  = "eu-west-1"
  env         = "staging"
  custom_tags = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("common_tags.yaml")}"))
}

dependency "eks" {
  config_path = "../eks"

  mock_outputs = {
    vpc-private-subnets = ["subnet-0000", "subnet-0001"]
  }
}

dependency "postgres-source" {
  config_path = "../postgres-source"

  mock_outputs = {
    db_security_group_id = "sg-000000000000"
    db_instance_username = "username"
    db_instance_password = "password"
    db_instance_address  = "address"
    db_instance_port     = "5432"
    db_instance_name     = "db"
  }
}
dependency "postgres-target" {
  config_path = "../postgres-target"

  mock_outputs = {
    db_security_group_id = "sg-000000000000"
    db_instance_username = "username"
    db_instance_password = "password"
    db_instance_address  = "address"
    db_instance_port     = "5432"
    db_instance_name     = "db"
  }
}

inputs = {

  aws = {
    "region" = local.aws_region
  }

  inject_rules_into_sgs = [
    dependency.postgres-source.outputs.db_security_group_id,
    dependency.postgres-target.outputs.db_security_group_id,
  ]

  dms_instance_availability_zone      = "${local.aws_region}a"
  dms_instance_id                     = "cfd-${local.env}-dms"
  dms_sg_name                         = "cfd-${local.env}-dms-sg"
  dms_instance_vpc_security_group_ids = []

  dms_subnet_group_subnets = dependency.eks.outputs.vpc-private-subnets

  dms_endpoints = {
    source = {
      certificate_arn             = null
      database_name               = dependency.postgres-source.outputs.db_instance_name
      endpoint_id                 = "source-${local.env}"
      endpoint_type               = "source"
      engine_name                 = "postgres"
      extra_connection_attributes = null
      kms_key_arn                 = null
      username                    = dependency.postgres-source.outputs.db_instance_username
      password                    = dependency.postgres-source.outputs.db_instance_password
      port                        = dependency.postgres-source.outputs.db_instance_port
      server_name                 = dependency.postgres-source.outputs.db_instance_address
      ssl_mode                    = "require"
      tags                        = local.custom_tags
    },
    target = {
      certificate_arn             = null
      database_name               = dependency.postgres-target.outputs.db_instance_name
      endpoint_id                 = "dms-${local.env}"
      endpoint_type               = "target"
      engine_name                 = "postgres"
      extra_connection_attributes = null
      kms_key_arn                 = null
      username                    = dependency.postgres-target.outputs.db_instance_username
      password                    = dependency.postgres-target.outputs.db_instance_password
      port                        = dependency.postgres-target.outputs.db_instance_port
      server_name                 = dependency.postgres-target.outputs.db_instance_address
      ssl_mode                    = "require"
      tags                        = local.custom_tags
    },
  }

  dms_replication_tasks = {
    source = {
      name = "source-${local.env}"
      tables = [
        "table",
        "table2",
      ]
      configuration = <<VALUE
VALUE
  }
}
