<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| client\_auth\_ca\_arns | List of ACM Certificate Authority ARNs for Client Auth. | list(string) | n/a | yes |
| cluster\_name | The name of the MSK cluster to create. | string | n/a | yes |
| region | AWS region to which resources will be deployed | string | n/a | yes |
| terraform\_role\_arn | ARN AWS IAM role that is allowed to deploy and manipulate the resources in the target AWS account | string | n/a | yes |
| vpc\_client\_subnets\_ids | Subnet IDs where the MSK cluster will be deployed | list(string) | n/a | yes |
| vpc\_id | AWS VPC ID | string | n/a | yes |
| acmpca | Configuration for the ACM PCA root Certificate Manager | object | `{}` | no |
| auto\_create\_topics\_enable | Enables topic autocreation on the server | bool | `"false"` | no |
| broker\_ebs\_volume\_size | Kafka Brokers EBS volume size. | number | `"100"` | no |
| broker\_instance\_type | Kafka Brokers instance type. | string | `"kafka.t3.small"` | no |
| custom\_pca\_arns | List of ARNs of ACM PCA that you want this MSK cluster to use for client authentication | list(string) | `[]` | no |
| default\_replication\_factor | The default replication factor for automatically created topics | number | `"3"` | no |
| kafka\_broker\_count | Number of Kafka broker nodes. | number | `"3"` | no |
| kafka\_client\_broker\_encryption\_type | Encryption setting for data in transit between clients and brokers. Valid values: TLS, TLS_PLAINTEXT, and PLAINTEXT. | string | `"TLS"` | no |
| kafka\_configuration\_arn | ARN of the MSK Configuration to use in the cluster. | string | `"null"` | no |
| kafka\_configuration\_revision | Revision of the MSK Configuration to use in the cluster. | number | `"null"` | no |
| kafka\_in\_cluster\_encryption\_enabled | Whether data communication among broker nodes is encrypted. | bool | `"true"` | no |
| kafka\_version | Kafka Cluster version. | string | `"2.6.0"` | no |
| log\_group\_kms\_key\_id | (Optional) The ARN of the KMS Key to use when encrypting log data in Cloudwatch. | string | `"null"` | no |
| log\_group\_retention\_in\_days | The number of days you want to retain log events in the newly created log group | number | `"30"` | no |
| min\_insync\_replicas | min.insync.replicas specifies the minimum number of replicas that must acknowledge a write for the write to be considered successful | number | `"2"` | no |
| monitoring\_jmx\_exporter\_enabled | Specifies whether the JMX Exporter for Prometheus is enabled. | bool | `"true"` | no |
| monitoring\_node\_exporter\_enabled | Specifies whether the Node Exporter for Prometheus is enabled. | bool | `"true"` | no |
| offset\_topic\_replication\_factor | The replication factor for the offsets topic | number | `"3"` | no |
| prometheus\_open\_monitoring | Populate this variable if you use Prometheus for monitoring | object | `{}` | no |
| sns\_kms\_master\_key\_id | (Optional) The ARN of the KMS Key to use when encrypting log data in SNS. | string | `"null"` | no |
| unclean\_leader\_election\_enable | Indicates whether to enable replicas not in the ISR set to be elected as leader as a last resort, even though doing so may result in data loss | bool | `"false"` | no |

## Outputs

| Name | Description |
|------|-------------|
| bootstrap\_brokers |  |
| bootstrap\_brokers\_tls |  |
| kafka\_configuration\_arn |  |
| kafka\_configuration\_revision |  |
| msk\_cluster\_name |  |
| pca\_arns | The ARNs of the PCA used for the MSK cluster |
| zookeeper\_connect\_string |  |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->