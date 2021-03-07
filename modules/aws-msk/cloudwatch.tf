resource "aws_cloudwatch_log_group" "this" {
  name              = "/msk-log-group-${var.cluster_name}"
  kms_key_id        = var.logging_kms_key_id
  retention_in_days = var.log_group_retention_in_days
  tags              = local.tags
}
