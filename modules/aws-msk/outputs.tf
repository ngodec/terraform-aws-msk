output "pca_arns" {
  description = "The ARNs of the PCA used for the MSK cluster"
  value       = local.pca_arns
}

output "kafka_configuration_arn" {
  value = aws_msk_configuration.this.arn
}

output "kafka_configuration_revision" {
  value = aws_msk_configuration.this.latest_revision
}

output "zookeeper_connect_string" {
  value = aws_msk_cluster.this.zookeeper_connect_string
}

output "bootstrap_brokers" {
  value = aws_msk_cluster.this.bootstrap_brokers
}

output "bootstrap_brokers_tls" {
  value = aws_msk_cluster.this.bootstrap_brokers_tls
}

output "msk_cluster_name" {
  value = aws_msk_cluster.this.cluster_name
}
