resource "aws_sns_topic" "this" {
  name              = var.cluster_name
  kms_master_key_id = var.sns_kms_master_key_id

  tags = local.tags
}


resource "aws_cloudwatch_metric_alarm" "kafka_cpu_system_broker" {
  count               = var.kafka_broker_count
  alarm_name          = "${var.cluster_name}-kafka-data-disk-used-broker-${count.index + 1}"
  alarm_description   = "Triggers alarm when MSK broker disk usage > 85%"
  alarm_actions       = [aws_sns_topic.this.arn]
  ok_actions          = [aws_sns_topic.this.arn]
  actions_enabled     = true
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 5
  threshold           = "85"
  unit                = "Percent"
  treat_missing_data  = "treat_missing_data"
  metric_name         = "KafkaDataLogsDiskUsed"
  namespace           = "AWS/Kafka"
  period              = "60"
  statistic           = "Average"

  dimensions = {
    "Cluster Name" = "msk-${var.cluster_name}"
    "Broker ID"    = count.index + 1
  }

  tags = local.tags
}

resource "aws_cloudwatch_metric_alarm" "kafka_global_partition_count" {
  alarm_name        = "${var.cluster_name}-kafka-global-partition-count"
  alarm_description = "Triggers alarm when number of global partitions goes above 1000"
  alarm_actions     = [aws_sns_topic.this.arn]
  ok_actions        = [aws_sns_topic.this.arn]
  actions_enabled   = true

  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 5
  threshold           = "1000"
  unit                = "Count"
  treat_missing_data  = "treat_missing_data"
  metric_name         = "GlobalPartitionCount"
  namespace           = "AWS/Kafka"
  period              = "60"
  statistic           = "Average"

  dimensions = {
    "Cluster Name" = "msk-${var.cluster_name}"
  }

  tags = local.tags
}

resource "aws_cloudwatch_metric_alarm" "kafka_offline_partitions_count" {
  alarm_name        = "${var.cluster_name}-kafka-offline-partitions-count"
  alarm_description = "Triggers alarm when number of OfflinePartitionsCount goes above 0"
  alarm_actions     = [aws_sns_topic.this.arn]
  ok_actions        = [aws_sns_topic.this.arn]
  actions_enabled   = true

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "5"
  threshold           = "0"
  unit                = "Count"
  treat_missing_data  = "treat_missing_data"
  metric_name         = "OfflinePartitionsCount"
  namespace           = "AWS/Kafka"
  period              = "60"
  statistic           = "Average"

  dimensions = {
    "Cluster Name" = "msk-${var.cluster_name}"
  }

  tags = local.tags
}