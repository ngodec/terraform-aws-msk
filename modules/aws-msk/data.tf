data "template_file" "server_properties" {
  template = file("${path.module}/templates/server_properties.tpl")

  vars = {
    auto_create_topics_enable       = "${var.auto_create_topics_enable}"
    min_insync_replicas             = "${var.min_insync_replicas}"
    default_replication_factor      = "${var.default_replication_factor}"
    unclean_leader_election_enable  = "${var.unclean_leader_election_enable}"
    offset_topic_replication_factor = "${var.offset_topic_replication_factor}"
  }
}

data "aws_partition" "current" {}
