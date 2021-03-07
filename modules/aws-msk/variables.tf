variable "region" {
  description = "AWS region to which resources will be deployed"
  type        = string
}

variable "terraform_role_arn" {
  description = "ARN AWS IAM role that is allowed to deploy and manipulate the resources in the target AWS account"
  type        = string
}

variable "data_subnet_ids" {
  description = "Subnet IDs of the data subnets. MSK cluster will be deployed to these"
  type        = list(string)
}

variable "vpc_id" {
  description = "AWS VPC ID"
  type        = string
}

variable "cluster_name" {
  description = "The name of the MSK cluster to create."
  type        = string
}

variable "kafka_version" {
  description = "Kafka Cluster version."
  type        = string
  default     = "2.6.0"
}

variable "kafka_broker_count" {
  description = "Number of Kafka broker nodes."
  type        = number
  default     = 3
}

variable "broker_instance_type" {
  description = "Kafka Brokers instance type."
  type        = string
  default     = "kafka.t3.small"
}

variable "broker_ebs_volume_size" {
  description = "Kafka Brokers EBS volume size."
  type        = number
  default     = 100
}

variable "monitoring_jmx_exporter_enabled" {
  description = "Specifies whether the JMX Exporter for Prometheus is enabled."
  type        = bool
  default     = true
}

variable "monitoring_node_exporter_enabled" {
  description = "Specifies whether the Node Exporter for Prometheus is enabled."
  type        = bool
  default     = true
}

variable "logging_cloudwatch_enabled" {
  description = "Specifies whether the Cloudwatch Logging is enabled."
  type        = bool
  default     = true
}

variable "logging_cloudwatch_log_group_name" {
  description = "Cloudwatch Log Group name for MSK logging."
  type        = string
  default     = null
}


variable "client_auth_ca_arns" {
  description = "List of ACM Certificate Authority ARNs for Client Auth."
  type        = list(string)
}


variable "kafka_configuration_arn" {
  description = "ARN of the MSK Configuration to use in the cluster."
  type        = string
  default     = null
}

variable "kafka_configuration_revision" {
  description = "Revision of the MSK Configuration to use in the cluster."
  type        = number
  default     = null
}

variable "kafka_client_broker_encryption_type" {
  description = "Encryption setting for data in transit between clients and brokers. Valid values: TLS, TLS_PLAINTEXT, and PLAINTEXT."
  type        = string
  default     = "TLS"
}

variable "msk_configuration_kafka_versions" {
  description = "List of Apache Kafka versions which can use this configuration"
  type        = list(string)
  default     = ["2.6.0"]
}

variable "msk_configuration_description" {
  description = "Description of the configuration"
  type        = string
  default     = "MSK cluster configuration"
}

variable "sg_description" {
  description = "Description of the Security Group"
  type        = string
  default     = "Security Group for MSK Cluster"
}

variable "kms_key_description" {
  description = "Description of the KMS Key"
  type        = string
  default     = "KMS Key for MSK Cluster"
}


variable "auto_create_topics_enable" {
  description = "Enables topic autocreation on the server"
  type        = bool
  default     = false
}

variable "min_insync_replicas" {
  description = "min.insync.replicas specifies the minimum number of replicas that must acknowledge a write for the write to be considered successful"
  type        = number
  default     = 2
}

variable "default_replication_factor" {
  description = "The default replication factor for automatically created topics"
  type        = number
  default     = 3
}

variable "unclean_leader_election_enable" {
  description = "Indicates whether to enable replicas not in the ISR set to be elected as leader as a last resort, even though doing so may result in data loss"
  type        = bool
  default     = false
}

variable "offset_topic_replication_factor" {
  description = "The replication factor for the offsets topic"
  type        = number
  default     = 3
}

variable "sns_kms_master_key_id" {
  description = "(Optional) The ARN of the KMS Key to use when encrypting log data in SNS."
  type        = string
  default     = null
}
#----------------------------------------------
# Cloudwatch log group parameters
variable "log_group_kms_key_id" {
  description = "(Optional) The ARN of the KMS Key to use when encrypting log data in Cloudwatch."
  type        = string
  default     = null
}

variable "log_group_retention_in_days" {
  description = "The number of days you want to retain log events in the newly created log group"
  type        = number
  default     = 30
}

variable "acmpca" {
  description = "Configuration for the ACM PCA root Certificate Manager"
  type = object({
    country                         = string
    organization                    = string
    organizational_unit             = string
    permanent_deletion_time_in_days = string
    revocation_enabled              = bool
    revocation_days                 = number
    revocation_custom_cname         = string
    revocation_s3_bucket_name       = string
  })
  default = {}
}