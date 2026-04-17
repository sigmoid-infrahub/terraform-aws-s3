# Module: S3

This module creates and manages an Amazon S3 bucket with support for versioning and tagging.

## Features
- S3 Bucket creation
- Versioning configuration (Enabled/Suspended)
- Force destroy option for non-empty buckets
- Tagging support

## Usage
```hcl
module "s3" {
  source = "../../terraform-modules/terraform-aws-s3"

  bucket = "my-unique-bucket-name"
}
```

## Inputs
| Name | Type | Default | Description |
|------|------|---------|-------------|
| `bucket` | `string` | n/a | Bucket name |
| `versioning` | `any` | `null` | Versioning configuration |
| `force_destroy` | `bool` | `false` | Force destroy the bucket |
| `tags` | `map(string)` | `{}` | Tags to apply to the bucket |

## Outputs
| Name | Description |
|------|-------------|
| `bucket_id` | Bucket name |
| `bucket_arn` | Bucket ARN |
| `bucket_domain_name` | Bucket domain name |
| `bucket_regional_domain_name` | Bucket regional domain name |
| `module` | Full module outputs |

## Environment Variables
None

## Notes
- Bucket names must be globally unique.
- Setting `force_destroy` to `true` allows the bucket to be deleted even if it contains objects.
