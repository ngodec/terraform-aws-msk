output "security_group_id_eks" {
  value = module.aws_security_group.id
}

output "msk_configuration_arn" {
  description = "Amazon Resource Name (ARN) of the configuration"
  value       = module.msk_configuration.msk_configuration_arn
}

output "msk_configuration_latest_revision" {
  description = "Latest revision of the configuration"
  value       = module.msk_configuration.msk_configuration_latest_revision
}
