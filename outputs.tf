output "dms_replication_instance_arn" {
  value = aws_dms_replication_instance.dms-instance.replication_instance_arn
}

output "dms_replication_instance_private_ips" {
  value = aws_dms_replication_instance.dms-instance.replication_instance_private_ips
}

output "dms_replication_instance_public_ips" {
  value = aws_dms_replication_instance.dms-instance.replication_instance_public_ips
}

output "dms_replication_subnet_group_vpc_id" {
  value = aws_dms_replication_subnet_group.dms-subnet-group.vpc_id
}

output "dms_endpoints_arns" {
  value = values(aws_dms_endpoint.dms-endpoints)[*].endpoint_arn
}

output "dms_security_group_id" {
  value = var.dms_create_default_sg ? aws_security_group.dms-sg[0].id : ""
}

