#!/usr/bin/env bash

STS_SESSION_NAME=$(whoami)-$(date +%s)
STS=$(aws sts assume-role \
 --role-arn $ROLE_ARN \
 --role-session-name "${STS_SESSION_NAME}")
export AWS_ACCESS_KEY_ID=$(echo "${STS}" | jq -r .Credentials.AccessKeyId)
export AWS_SECRET_ACCESS_KEY=$(echo "${STS}" | jq -r .Credentials.SecretAccessKey)
export AWS_SESSION_TOKEN=$(echo "${STS}" | jq -r .Credentials.SessionToken)

PCA_INFO=$(aws acm-pca describe-certificate-authority --certificate-authority-arn "$PCA_ARN" --region $REGION)
PCA_STATUS=$(echo "$PCA_INFO" | jq -r '.CertificateAuthority.Status')

if [[ "$PCA_STATUS" != "PENDING_CERTIFICATE" ]]; then
  echo "Error: CA is '$PCA_STATUS', cannot activate"
  exit 1
fi

echo "Getting the CSR..."
aws acm-pca get-certificate-authority-csr \
    --certificate-authority-arn "${PCA_ARN}" \
    --output text --region $REGION > msk-ca.csr

echo "Issuing the root CA cert..."
aws acm-pca issue-certificate \
  --certificate-authority-arn "$PCA_ARN" \
  --csr fileb://msk-ca.csr \
  --signing-algorithm SHA256WITHRSA \
  --validity "Value=$VALIDITY_DAYS,Type=\"DAYS\"" \
  --template-arn "arn:aws:acm-pca:::template/RootCACertificate/V1" \
  --region $REGION --output json \
  | jq -r '.CertificateArn' > msk-ca-cert-arn

sleep 10

echo "Fetching the root CA cert..."
aws acm-pca get-certificate \
  --certificate-authority-arn "$PCA_ARN" \
  --certificate-arn "$(cat msk-ca-cert-arn)" \
  --region $REGION --output text > msk-cert.pem

echo "Activating the root PCA..."
aws acm-pca import-certificate-authority-certificate \
  --certificate-authority-arn "$PCA_ARN" \
  --region $REGION \
  --certificate fileb://msk-cert.pem

rm msk-ca.csr
rm msk-cert.pem
rm msk-ca-cert-arn