# This will create the AWS ACM Private Certificate Authority
# And its root certificate
# Since we are using a ROOT CA, it can sign its own certificate

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

  tags = local.tags
}

resource "aws_acmpca_certificate_authority_certificate" "msk_pca_ca_cert" {
  certificate_authority_arn = aws_acmpca_certificate_authority.msk_pca.arn

  certificate       = aws_acmpca_certificate.msk_pca_cert.certificate
  certificate_chain = aws_acmpca_certificate.msk_pca_cert.certificate_chain
}

resource "aws_acmpca_certificate" "msk_pca_cert" {
  certificate_authority_arn   = aws_acmpca_certificate_authority.msk_pca.arn
  certificate_signing_request = aws_acmpca_certificate_authority.msk_pca.certificate_signing_request
  signing_algorithm           = "SHA512WITHRSA"

  template_arn = "arn:${data.aws_partition.current.partition}:acm-pca:::template/RootCACertificate/V1"

  validity {
    type  = "YEARS"
    value = var.ca_cert_validity_years
  }
}
