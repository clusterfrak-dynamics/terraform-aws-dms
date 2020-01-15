resource "aws_dms_endpoint" "dms-endpoints" {
  for_each                    = var.dms_endpoints
  certificate_arn             = each.value.certificate_arn
  database_name               = each.value.database_name
  endpoint_id                 = each.value.endpoint_id
  endpoint_type               = each.value.endpoint_type
  engine_name                 = each.value.engine_name
  extra_connection_attributes = each.value.extra_connection_attributes
  kms_key_arn                 = each.value.kms_key_arn
  username                    = each.value.username
  password                    = each.value.password
  port                        = each.value.port
  server_name                 = each.value.server_name
  ssl_mode                    = each.value.ssl_mode

  tags = merge(
    {
      Name = each.value.endpoint_id
    },
    each.value.tags
  )
}