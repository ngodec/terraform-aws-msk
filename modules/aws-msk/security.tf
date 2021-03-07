resource "aws_security_group" "msk_sg" {
  description = var.sg_description
  name        = var.cluster_name
  vpc_id      = var.vpc_id
  tags        = local.tags
}

resource "aws_kms_key" "msk_key" {

  description              = var.kms_key_description
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  deletion_window_in_days  = 30
  is_enabled               = true
  enable_key_rotation      = true
  tags                     = local.tags
}

resource "aws_kms_alias" "msk_key_alias" {

  name          = "alias/${var.cluster_name}"
  target_key_id = aws_kms_key.msk_key.key_id
}
