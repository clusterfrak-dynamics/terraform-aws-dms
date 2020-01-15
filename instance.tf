data "aws_iam_policy_document" "dms_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["dms.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "dms-access-for-endpoint" {
  count              = var.create_default_iam_roles ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.dms_assume_role.json
  name               = "dms-access-for-endpoint"
}

resource "aws_iam_role_policy_attachment" "dms-access-for-endpoint-AmazonDMSRedshiftS3Role" {
  count      = var.create_default_iam_roles ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSRedshiftS3Role"
  role       = aws_iam_role.dms-access-for-endpoint[count.index].name
}

resource "aws_iam_role" "dms-cloudwatch-logs-role" {
  count              = var.create_default_iam_roles ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.dms_assume_role.json
  name               = "dms-cloudwatch-logs-role"
}

resource "aws_iam_role_policy_attachment" "dms-cloudwatch-logs-role-AmazonDMSCloudWatchLogsRole" {
  count      = var.create_default_iam_roles ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSCloudWatchLogsRole"
  role       = aws_iam_role.dms-cloudwatch-logs-role[count.index].name
}

resource "aws_iam_role" "dms-vpc-role" {
  count              = var.create_default_iam_roles ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.dms_assume_role.json
  name               = "dms-vpc-role"
}

resource "aws_iam_role_policy_attachment" "dms-vpc-role-AmazonDMSVPCManagementRole" {
  count      = var.create_default_iam_roles ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSVPCManagementRole"
  role       = aws_iam_role.dms-vpc-role[count.index].name
}

data "aws_subnet" "dms-sg-vpc" {
  count = var.dms_create_default_sg ? 1 : 0
  id    = var.dms_subnet_group_subnets[0]
}

resource "aws_security_group" "dms-sg" {
  count       = var.dms_create_default_sg ? 1 : 0
  name        = var.dms_sg_name != "" ? var.dms_sg_name : null
  name_prefix = var.dms_sg_name != "" ? null : "dms-sg-"
  vpc_id      = data.aws_subnet.dms-sg-vpc[0].vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  tags = var.custom_tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "dms-sg-self" {
  count             = var.dms_create_default_sg ? 1 : 0
  description       = "${aws_security_group.dms-sg[count.index].name}-self"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.dms-sg[count.index].id
  to_port           = 65535
  type              = "ingress"
  self              = true
}

resource "aws_dms_replication_instance" "dms-instance" {
  allocated_storage            = var.dms_instance_storage
  apply_immediately            = var.dms_instance_apply_immediately
  auto_minor_version_upgrade   = var.dms_instance_auto_minor_version_upgrade
  availability_zone            = var.dms_instance_availability_zone
  engine_version               = var.dms_instance_engine_version
  kms_key_arn                  = var.dms_instance_kms_key_arn
  multi_az                     = var.dms_instance_multi_az
  preferred_maintenance_window = var.dms_instance_preferred_maintenance_window
  publicly_accessible          = var.dms_instance_publicly_accessible
  replication_instance_class   = var.dms_instance_replication_instance_class
  replication_instance_id      = var.dms_instance_id
  replication_subnet_group_id  = aws_dms_replication_subnet_group.dms-subnet-group.id

  tags = merge(
    {
      Name = var.dms_instance_id
    },
    var.custom_tags
  )

  vpc_security_group_ids = concat(aws_security_group.dms-sg.*.id, var.dms_instance_vpc_security_group_ids)
}

resource "aws_dms_replication_subnet_group" "dms-subnet-group" {
  replication_subnet_group_description = var.dms_instance_id
  replication_subnet_group_id          = var.dms_instance_id

  subnet_ids = var.dms_subnet_group_subnets

  tags = merge(
    {
      Name = var.dms_instance_id
    },
    var.custom_tags
  )
}
