resource "aws_msk_configuration" "this" {
  kafka_versions    = [var.kafka_versions]
  name              = "cluster-configuration-${var.cluster_name}"
  description       = "MSK cluster configuration for ${var.cluster_name}"
  server_properties = data.template_file.server_properties.rendered
}

resource "aws_msk_cluster" "this" {
  cluster_name           = var.cluster_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.kafka_broker_count

  broker_node_group_info {
    instance_type   = var.broker_instance_type
    ebs_volume_size = var.broker_ebs_volume_size
    client_subnets  = var.vpc_client_subnets_ids
    security_groups = [aws_security_group.msk_sg.id]
  }

  client_authentication {
    tls {
      certificate_authority_arns = local.pca_arns
    }
  }

  # Configuration block for specifying a MSK Configuration to attach to Kafka brokers
  configuration_info {
    # Amazon Resource Name (ARN) of the MSK Configuration to use in the cluster.
    arn = aws_msk_configuration.this.arn
    # (Required) Revision of the MSK Configuration to use in the cluster.
    revision = aws_msk_configuration.this.latest_revision
  }

  #checkov:skip=CKV_AWS_81:: Error with Ensure MSK Cluster encryption in rest and transit is enabled
  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.msk_key.arn
    # Encrypting Data at rest
    encryption_in_transit {
      # Encryption setting for data in transit between clients and brokers
      client_broker = var.kafka_client_broker_encryption_type
      # Whether data communication among broker nodes is encrypted
      in_cluster = var.kafka_in_cluster_encryption_enabled
    }
  }

  dynamic "open_monitoring" {
    for_each = var.prometheus_open_monitoring != {} ? ["Enabled open monitoring"] : []
    content {
      prometheus {
        jmx_exporter {
          enabled_in_broker = var.prometheus_open_monitoring.jmx_exporter_enabled
        }
        node_exporter {
          enabled_in_broker = var.prometheus_open_monitoring.node_exporter_enabled
        }
      }
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.msk_log_group
      }
    }
  }

  tags = local.tags

  depends_on = [aws_acmpca_certificate_authority_certificate.msk_pca_ca_cert]
}
