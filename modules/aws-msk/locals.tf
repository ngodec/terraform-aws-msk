locals {
  tags = {
    module = "terraform-aws-msk"
    name   = var.cluster_name
  }
  # If configuration for a PCA was passed in, then create the PCA and use it for the MSK cluster
  # Otherwise - use the custom_pca_arns var, which can be empty
  pca_arns = var.acmpca != {} ? [aws_acmpca_certificate_authority.*.msk_pca.arn[0]] : var.custom_pca_arns
}
