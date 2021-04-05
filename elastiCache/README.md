Terraform Setup

```
terraform init \
  -backend-config="bucket=bucket-name" \
  -backend-config="key=path/terraform.state"
