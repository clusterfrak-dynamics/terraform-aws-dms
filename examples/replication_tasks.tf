variable "dms_replication_tasks" {
  type    = any
  default = {}
}

variable "env" {}

resource "aws_dms_replication_task" "replication_tasks" {
  for_each                  = var.dms_replication_tasks
  migration_type            = "full-load-and-cdc"
  replication_instance_arn  = aws_dms_replication_instance.dms-instance.replication_instance_arn
  replication_task_id       = each.value.name
  source_endpoint_arn       = aws_dms_endpoint.dms-endpoints[each.key].endpoint_arn
  replication_task_settings = templatefile("templates/settings.tpl", { env = var.env, name = each.key })
  table_mappings            = templatefile("templates/table_mapping.tpl", { tables = each.value.tables })

  tags = merge(
    {
      Name = each.value.name
    },
    var.custom_tags
  )

  target_endpoint_arn = aws_dms_endpoint.dms-endpoints["reports-dms"].endpoint_arn
}

output "replication_task_arns" {
  value = values(aws_dms_replication_task.replication_tasks)[*].replication_task_arn
}
