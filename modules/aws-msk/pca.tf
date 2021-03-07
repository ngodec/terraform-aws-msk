# This will create the AWS ACM Private Certificate Authority
# Creating this resource will leave the certificate authority
# in a PENDING_CERTIFICATE status, which means it cannot yet issue certificates.
# Terraform does not yet support signing the PCA certs natively.
# Use the solution from this thread https://github.com/hashicorp/terraform-provider-aws/issues/5552
# until the issue is resolved and a new Terra resource is added
resource "aws_acmpca_certificate_authority" "msk_pca" {
  count = var.acmpca != {} ? 1 : 0
  certificate_authority_configuration {
    key_algorithm     = "RSA_2048"
    signing_algorithm = "SHA512WITHRSA"

    subject {
      common_name         = var.acmpca.common_name
      country             = var.acmpca.country
      organization        = var.acmpca.organization
      organizational_unit = var.acmpca.organizational_unit
    }
  }

  type                            = "ROOT"
  permanent_deletion_time_in_days = var.acmpca.permanent_deletion_time_in_days

  dynamic "revocation_configuration" {
    for_each = var.acmpca.revocation_enabled ? ["revocation is enabled"] : []
    crl_configuration {
      enabled            = var.acmpca.revocation_enabled
      expiration_in_days = var.acmpca.revocation_days
      custom_cname       = var.acmpca.revocation_custom_cname
      s3_bucket_name     = var.acmpca.revocation_s3_bucket_name
    }
  }

  # This bit is the non-native solution to signing the root CA cert
  provisioner "local-exec" {
    command = <<EOT
    export PCA_ARN='${aws_acmpca_certificate_authority.msk_pca.arn}'
    export VALIDITY_DAYS=3650
    export REGION=${var.region}
    export ROLE_ARN=${var.terraform_role_arn}
    ${path.module}/scripts/activate-pca.sh
    EOT
  }

  tags = local.tags
}
