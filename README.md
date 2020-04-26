# terraform_ci_cd

Terraform mock module for terratest

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| google | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | n/a | `string` | n/a | yes |
| project\_id | n/a | `string` | n/a | yes |
| instance\_number | n/a | `number` | `1` | no |
| machine\_type | n/a | `string` | `"n1-standard-1"` | no |
| name | n/a | `string` | `"cloudlad"` | no |
| region | n/a | `string` | `"europe-west4"` | no |
| zone | n/a | `string` | `"europe-west4-c"` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket\_name | n/a |
| instance\_group\_name | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
