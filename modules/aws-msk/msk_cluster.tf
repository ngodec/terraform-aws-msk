module "msk_configuration" {
  source                          = "git::git@github.com:babylonhealth/platform-module-aws-msk.git//msk_configuration?ref=2020.09.10.1421"
  kafka_versions                  = var.msk_configuration_kafka_versions
  name                            = "cluster-configuration-${local.name}"
  description                     = var.msk_configuration_description
  auto_create_topics_enable       = var.auto_create_topics_enable
  min_insync_replicas             = var.min_insync_replicas
  default_replication_factor      = var.default_replication_factor
  unclean_leader_election_enable  = var.unclean_leader_election_enable
  offset_topic_replication_factor = var.offset_topic_replication_factor
}

module "msk_cluster" {
  source                            = "git::git@github.com:babylonhealth/platform-module-aws-msk.git//msk_cluster?ref=master"
  create                            = var.create
  cluster_name                      = "msk-${local.name}"
  kafka_version                     = var.kafka_version
  kafka_broker_count                = var.kafka_broker_count
  kafka_configuration_arn           = coalesce(var.kafka_configuration_arn, module.msk_configuration.msk_configuration_arn)
  kafka_configuration_revision      = coalesce(var.kafka_configuration_revision, module.msk_configuration.msk_configuration_latest_revision)
  broker_instance_type              = var.broker_instance_type
  broker_ebs_volume_size            = var.broker_ebs_volume_size
  vpc_security_group_ids            = [module.aws_security_group.id]
  vpc_client_subnets_ids            = var.data_subnet_ids
  kms_encryption_key_arn            = module.aws_kms_key.arn[0]
  monitoring_jmx_exporter_enabled   = var.monitoring_jmx_exporter_enabled
  monitoring_node_exporter_enabled  = var.monitoring_node_exporter_enabled
  logging_cloudwatch_enabled        = var.logging_cloudwatch_enabled
  logging_cloudwatch_log_group_name = module.cloudwatch_log_group.log_group_name
  client_auth_ca_arns               = var.client_auth_ca_arns
  tags                              = local.tags
}
