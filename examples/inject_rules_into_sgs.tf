variable "inject_rules_into_sgs" {
  type    = list
  default = []
}

resource "aws_security_group_rule" "dms-sg" {
  count                    = length(var.inject_rules_into_sgs)
  description              = "${aws_security_group.dms-sg[0].name}-allow"
  from_port                = 5432
  protocol                 = "tcp"
  security_group_id        = var.inject_rules_into_sgs[count.index]
  to_port                  = 5432
  type                     = "ingress"
  source_security_group_id = aws_security_group.dms-sg[0].id
}
