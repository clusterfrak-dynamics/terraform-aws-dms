variable "custom_tags" {
  default = {}
  type    = map
}

variable "create_default_iam_roles" {
  default = true
}

variable "dms_instance_storage" {
  default = 30
}

variable "dms_instance_apply_immediately" {
  default = false
}

variable "dms_instance_auto_minor_version_upgrade" {
  default = true
}

variable "dms_instance_availability_zone" {}

variable "dms_instance_engine_version" {
  default = "3.3.0"
}

variable "dms_instance_kms_key_arn" {
  default = null
}

variable "dms_instance_multi_az" {
  default = false
}

variable "dms_instance_preferred_maintenance_window" {
  default = "sun:00:00-sun:03:00"
}

variable "dms_instance_publicly_accessible" {
  default = false
}

variable "dms_instance_replication_instance_class" {
  default = "dms.t2.micro"
}

variable "dms_instance_id" {}

variable "dms_instance_vpc_security_group_ids" {
  type    = list
  default = []
}

variable "dms_subnet_group_subnets" {
  type    = list
  default = []
}

# see https://www.terraform.io/docs/providers/aws/r/dms_endpoint.html for a list of supported values.
variable "dms_endpoints" {
  type    = any
  default = []
}

variable "dms_sg_name" {
  default = ""
}

variable "dms_create_default_sg" {
  default = true
}